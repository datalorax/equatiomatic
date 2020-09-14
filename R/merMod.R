#' Utility function to wrap things as normally distributed
#' @keywords internal
#' @noRd
wrap_normal_dist <- function(mean, sigma = "\\sigma^2") {
  paste0("N \\left(", mean, ",", sigma, " \\right)")
}


# Other utility functions for interactions and moving terms around
is_interaction <- function(l) {
  grepl(":", l$`\\alpha`)
}

pull_interactions <- function(l) {
  l$`\\alpha`[is_interaction(l)]
}

sep_interactions <- function(l) {
  ints <- pull_interactions(l)
  strsplit(ints, ":")
}

pull_first_var_int <- function(l) {
  vapply(sep_interactions(l), "[[", 1, FUN.VALUE = character(1))  
}

int_higher <- function(l) {
  int_vars <- pull_first_var_int(l)
  
  vapply(int_vars, function(x) {
    test <- vapply(l[-grep("^\\\\alpha", names(l))], function(y) {
      x %in% y[1]
    }, FUN.VALUE = logical(1))
    any(test)
  }, FUN.VALUE = logical(1))
}

drop_higher_interactions_alpha <- function(l) {
  higher_ints <- int_higher(l)
  if(length(names(higher_ints)[higher_ints]) == 0) {
    return(l)
  }
  
  drop <- !(names(l[[1]]) %in% names(higher_ints)[higher_ints])
  l[[1]] <- l[[1]][drop]
  l
}

drop_higher_interactions_across <- function(full_l) {
  for(i in seq_along(full_l)) {
    ints <- full_l[[i]][[1]][is_interaction(full_l[[i]])]
    tests <- lapply(full_l[(i + 1):length(full_l)], function(x) {
      tst <- ints %in% unlist(x)
      names(tst) <- names(ints)[tst]
      tst
    })
    if (any(unlist(tests))) {
      pull <- names(Reduce(`|`, tests))
      pull <- pull[!is.na(pull)]
      
      for(j in seq_along(pull)) {
        full_l[[i]][[1]] <- full_l[[i]][[1]][-grep(pull[j], names(full_l[[i]][[1]]), fixed = TRUE)]  
      }
    }
  }
  full_l
}

match_fun <- function(text, text_to_match_vec) {
  test <- lapply(text_to_match_vec, function(x) x %in% text[1])
  test <- vapply(test, any, FUN.VALUE = logical(1))
  if(any(test)) {
    # Return the match, but only the second term (the one that doesn't match)
    # and is actually predicting that term
    return(c("(Intercept)", text_to_match_vec[test][[1]][2])) 
  }
  text
}

move_terms <- function(l) {
  dropped <- drop_higher_interactions_alpha(l)
  int_sep <- sep_interactions(l)
  lapply(dropped, function(x) match_fun(x, int_sep))
}



#' Utility function to vectorize pattern replacement
#'
#' Searches \code{text_vec} for each element in \code{pattern_vec} and
#' \code{pattern_vec} and \code{replacement_vec} args must be the same length.
#' @param text_vec The text/character vector to search through
#' @param pattern_vec A vector of patterns to search for
#' @param replacement_vec The replacement for each pattern.
#' @keywords internal
#' @noRd
#' @examples \dontrun {
#' equatiomatic:::sub_vectorized(c("aa", "ab", "bc"),
#'                               c("a", "b"),
#'                               c("\\alpha", "\\beta"))
#' #>
#' #> [1] "\\alpha\\alpha" "\\alpha\\beta"  "\\betac"
#' }
sub_vectorized <- function(text_vec, pattern_vec, replacement_vec) {
  stopifnot(length(pattern_vec) == length(replacement_vec))

  for(i in seq_along(pattern_vec)) {
    text_vec <- gsub(pattern_vec[i], replacement_vec[i], text_vec,
                     fixed = TRUE)
  }
  text_vec
}


#################### Fixed Effects Portion Generator ####################
# #' Create randomly varying subscripts
# #'
# #' Adds a column to rhs that indexes j/k/l etc. for each level (starting at j)
# #' @param rhs output from \code{extract_rhs}
# #' @keywords internal
# #' @noRd
# assign_re_subscripts <- function(rhs) {
#   # Figure out number of levels (randomly varying coefs)
#   re_levs <- unique(rhs$group)
#   n_levels <- sum(re_levs != "Residual", na.rm = TRUE)
#
#   # Pull actual levels
#   re_levs <- re_levs[!is.na(re_levs) & re_levs != "Residual"]
#
#   # Assign them subscripts, starting with j
#   re_subscripts <- letters[10:(10 + (n_levels - 1))]
#
#   # Store subscripts as a column in rhs
#   rhs$re_subscripts <- as.character(factor(rhs$group,
#                                            levels = re_levs,
#                                            labels = re_subscripts))
#   # Add [i]
#   rhs$re_subscripts <- paste0(rhs$re_subscripts, "[i]")
#   rhs
# }

## Create fixed effects portion
### with appropriate subscripts denoting which vary randomly

extract_fixef_merMod <- function(rhs) {
  rhs$term[rhs$effect == "fixed"]
}

#' Pull just the random variables
#' @param rhs output from \code{extract_rhs}
#' @keywords internal
#' @noRd
extract_random_vars <- function(rhs) {
  order <- rhs[rhs$group != "Residual", ]
  order <- sort(tapply(order$original_order, order$group, min))

  vc <- rhs[rhs$group != "Residual" & rhs$effect == "ran_pars", ]
  splt <- split(vc, vc$group)[names(order)]

  lapply(splt, function(x) {
    vars <- x[!grepl("cor__", x$term), ]
    gsub("sd__(.+)", "\\1", vars$term)
  })
}

create_greek_merMod <- function(model) {
  rhs <- extract_rhs(model)
  fixed <- extract_fixef_merMod(rhs)
  random <- extract_random_vars(rhs)
  lev_indexes <- letters[10:(10 + (length(random) - 1))]
  
  order <- rhs[rhs$group != "Residual", ]
  order <- sort(tapply(order$original_order, order$group, min))
  
  # Detect if group-level pred
  group_coefs <- detect_group_coef(model)
  
  # all this higher_vars stuff could probs go in a separate function
  higher_vars <- lapply(names(group_coefs), function(x) fixed[grepl(x, fixed)])
  names(higher_vars) <- group_coefs
  
  # split in case where multiple vars at a higher level
  higher_vars <- split(higher_vars, names(higher_vars))
  
  # put back into a single list (makes no difference if only one group var)
  higher_vars <- lapply(higher_vars, function(x) Reduce(`c`, x))
  
  higher_vars <- higher_vars[names(order)]
  names(higher_vars) <- names(order)
  
  # Remove higher-level terms from lower level
  fixed <- fixed[!(fixed %in% unlist(higher_vars))]
  
  # fixed effects
  if("(Intercept)" %in% unlist(random)) {
    names(fixed) <- ifelse(fixed == "(Intercept)", "\\alpha_{", paste0("\\beta_{", seq_along(fixed) - 1))
  } else {
    names(fixed) <- c("\\alpha", (paste0("\\beta_{", seq_along(fixed)[-length(fixed)])))
  }
  
  # Detect cross-level interactions
  # This is actually just detecting cross-level for higher levels with l1
  # Need to get it to work on all levels
  crosslevel <- lapply(higher_vars, function(x) lapply(fixed, function(y) x[grepl(y, x) & grepl(":", x)]))
  
  # Drop intercept term (only cross-level interactions)
  cross_interactions <- lapply(crosslevel, function(x) {
    x[-grepl("\\alpha", names(x), fixed = TRUE)]
  })
  
  # only non-cross-level interactions
  higher_nocross <- Map(setdiff, higher_vars, lapply(cross_interactions, unlist))
  
  # create intercept term
  intercepts <- lapply(higher_nocross, function(x) list("\\alpha" = x))
  
  # Put it together
  # need to get rid of variable name in cross-level interactions still
  higher_preds <- Map(function(x, y) c(x, y), intercepts, cross_interactions)
  
  # Drop terms with no vars
  higher_preds <- lapply(higher_preds, function(x) {
    x[vapply(x, length, FUN.VALUE = numeric(1)) > 0]
  })
  
  # close off subscripts for list names
  higher_preds <- lapply(higher_preds, function(x) {
    names(x) <- gsub("(\\_\\{\\d)", "\\1\\}", names(x))
    x
  })
  
  # Create l1 terms
  for(i in seq_along(random)) {
    names(fixed) <- ifelse(
      fixed %in% random[[i]], # check to see if it's random
      ifelse(
        grepl("\\]$", names(fixed)), # check if a previous level has been assigned
        paste0(names(fixed), ",", lev_indexes[i], "[i]"), # add comma if so
        paste0(names(fixed), lev_indexes[i], "[i]")# otherwise just add the level index
      ),
      names(fixed)
    )
  }
  names(fixed) <- paste0(names(fixed), "}")
  
  # Create subscripts group predictors varying vary  higher levels
  higher_lev_vary <- vector("list", length(higher_preds))
  for(i in seq_along(higher_preds)) {
    higher_lev_vary[[i]] <- lapply(higher_preds[[i]], function(x) {
      lapply(random, function(y) x %in% y)
    })
  }
  higher_level_subscripts <- lapply(higher_lev_vary, function(hlv) {
    lapply(hlv, function(x) {
      Map(function(y, z) ifelse(y, z, NA_character_), x, paste0(lev_indexes, "[i]"))
    })
  })
  
  higher_level_subscripts_collapsed <- lapply(higher_level_subscripts, function(x) {
    lapply(x, function(y) {
      apply(as.data.frame(y), 1, function(z) {
        paste(z[!is.na(z)], collapse = ",")
      })
    })
  })
  
  full_coefs <- Map(function(x, subscript) {
    coefs <- names(x)
    slopes <- Map(function(term, greek, ss) {
      paste0("\\gamma^{", greek, "}_{", seq_along(term), ss, "}")
    },
    term = x,
    greek = coefs,
    ss = subscript)
  },
  higher_preds, 
  higher_level_subscripts_collapsed)
  
  group_preds <- Map(function(a, b) {
    Map(function(x, y) {
      names(x) <- y
      x
    }, a, b)
  }, higher_preds, full_coefs)
  
  
  # create random
  
  #l1
  l1 <- Map(function(ran, lev_i) {
    ran[ran %in% fixed] <- names(fixed[fixed %in% ran])
    ss_rem <- gsub("(.+\\_\\{\\d?).+", "\\1", ran)
    
    # add on specific subscripts
    ss_rem[grepl("\\\\", ss_rem)] <- paste0(ss_rem[grepl("\\\\", ss_rem)],
                                            lev_i, "}")
    
    ss_rem
  },
  random,  
  lev_indexes)
  
  # get group-level coefs
  ul <- unlist(group_preds)
  coefs <- gsub("^.+\\.(.+)", "\\1", names(ul))
  coefs <- gsub("\\[i\\]", "", coefs)
  
  for(i in seq_along(l1)) {
    l1[[i]][ l1[[i]] %in% ul ] <- coefs[ul %in% l1[[i]]]
  }
  random_names <- Map(function(coef, lev) {
    multivary <- grepl(".+_\\{.+,", coef)
    coef[multivary] <- gsub("(.+_\\{\\d).+", 
                            paste0("\\1", lev, "}"), 
                            coef[multivary])
    coef
  },l1, lev_indexes)
  
  random <- Map(function(r, rn) setNames(r, rn), random, random_names)
  random <- lapply(random, function(x) x[order(names(x))])
  
  # Add intercept terms for group preds
  group_preds <- lapply(group_preds, function(x) {
    lapply(x, function(y) {
      intercept <- "(Intercept)"
      names(intercept) <- gsub("(.+)\\}_.+", "\\1\\}_\\{0\\}",  names(y[1]))
      c(intercept, y)
    })
  })
  
  # Note - below assumes the constant term in the interaction is always first
  # not sure if that's actually true
  group_preds <- lapply(group_preds, function(x) lapply(x, function(y) {
    if(length(y) < 1) {
      return()
    }
    check <- vapply(strsplit(y, ":"), "[", 1, FUN.VALUE = character(1))
    if(length(unique(check[-grepl("(Intercept)", check)])) == 1) {
      vapply(strsplit(y, ":"), function(x) {
        if(length(x) == 2) {
          return(x[2])
        } else {
          x[1]
        }
      }, FUN.VALUE = character(1))
    } else {
      y
    }
  }))
  
  # Find terms with group-level predictors
  group_pred_list <- lapply(group_preds, names)
  
  # drop final subscript from betas
  group_pred_list <- lapply(group_pred_list, function(x) gsub("\\}$", "", x))
  
  # drop these terms from greek$random
  drop_terms_v <- function(vector_to_subset, term_v) {
    for(i in seq_along(term_v)) {
      vector_to_subset <- vector_to_subset[
        -grepl(term_v[i], names(vector_to_subset), fixed = TRUE)
      ]
    }
    vector_to_subset
  }
  
  rand_no_group_terms <- Map(function(rand, terms_to_drop) {
    drop_terms_v(rand, terms_to_drop)
  },random, group_pred_list)
  
  final_coefs <- Map(function(a, b) {
    c(a, b)[order(names(c(a, b)))]
  }, rand_no_group_terms, group_preds)
  
  final_coefs <- drop_higher_interactions_across(final_coefs)
  final_coefs <- lapply(final_coefs, move_terms)
  
  final <- lapply(final_coefs, function(x) {
    for(i in seq_along(x)) {
      if(is.null(names(x[[i]]))) {
        if(length(x[[i]]) > 1) {
          names(x[[i]]) <- paste0("\\delta^{", names(x[i]), "}_{", seq_along(x[[i]]) - 1, "}")  
        } else {
          names(x[[i]]) <- names(x[i])
        }
      }
    }
    x
  })
  
  list(fixed = fixed, random = random, final = final)
}

#' Create the full fixed-effects portion of an lmerMod
#'
#' @param model A fitted model from \code{\link[lme4]{lmer}}
#' @param ital_vars Logical, defaults to \code{FALSE}. Should the variable
#'   names not be wrapped in the \code{\\operatorname{}} command?
#' @param sigma The error term. Defaults to "\\sigma^2".
#' @keywords internal
#' @noRd
#' @examples \dontrun{
#' library(lme4)
#' fm1 <- lmer(Reaction ~ Days + (Days | Subject), sleepstudy)
#' equatiomatic:::create_fixed_merMod(fm1, FALSE)
# #> "\\operatorname{Reaction} \\sim N \\left(\\alpha_{j[i]} +
# #>  \\beta_{1j[i]}(\\operatorname{Days}),\\sigma^2 \\right)"
#' }
create_fixed_merMod <- function(model, mean_separate,
                                ital_vars, wrap, terms_per_line,
                                operator_location, sigma = "\\sigma^2") {
  rhs <- extract_rhs(model)
  lhs <- extract_lhs(model, ital_vars)
  greek <- create_greek_merMod(model)
  terms <- create_term(rhs[rhs$term %in% greek$fixed, ], ital_vars)
  terms <- vapply(terms, function(x) {
    if(nchar(x) == 0) {
      return("")
    }
    paste0("(", x, ")")
  }, character(1))

  fixed <- paste0(names(greek$fixed), terms)
  if(wrap) {
    if (operator_location == "start") {
      line_end <- "\\\\\n&\\quad + "
    } else {
      line_end <- "\\ + \\\\\n&\\quad "
    }
    fixed <- split(fixed, ceiling(seq_along(fixed) / terms_per_line))

    if(isFALSE(mean_separate)) {
      fixed <- lapply(fixed, function(x) {
        terms_added <- paste0(x, collapse = " + ")
        paste0("&", terms_added)
        })
      fixed <- paste0("\\begin{aligned}\n", paste0(fixed, collapse = "\\\\"), "\\end{aligned}")
    } else {
      fixed <- lapply(fixed, paste0, collapse = " + ")
      fixed <- paste0(fixed, collapse = line_end)
    }
  } else {
    fixed <- paste0(fixed, collapse = " + ")
  }

  if(is.null(mean_separate)) {
    mean_separate <- length(terms) > 3
  }
  if(mean_separate) {
    paste0(lhs, " \\sim ", wrap_normal_dist("\\mu", sigma),
           " \\\\ \\mu &=", fixed)
  }  else {
    paste(lhs, "\\sim", wrap_normal_dist(fixed, sigma))
  }
}

#################### Random Effects VCV Generator ####################

# #' Create greek terms for a vector
# #'
# #' Subscript generator for random effects. Sometimes you want just, e.g.,
# #'   "\\alpha", other times "\\alpha_{j}".
# #' @param v Character vector of terms in the model
# #' @param index Logical. Should the indices (j, k, etc.) be included.
# #'   Defaults to \code{TRUE}.
# #' @keywords internal
# #' @noRd
# assign_ranef_greek <- function(rhs, index = TRUE) {
#   random_vars <- extract_random_vars(rhs)
#
#   int <- create_intercept_merMod(rhs)
#   betas <- create_betas_merMod(rhs, ital_vars)
#
#   coefs <- strsplit(c(int = int, betas = betas), "\\+")
#
#   # pull which coefficients vary at which levels
#   lev_vary <- lapply(coefs, function(x) {
#       drop_vars <- gsub("\\(.+", "", x)
#       names(drop_vars) <- seq_along(drop_vars)
#       subscripts <- gsub(".+\\{(.+)\\}", "\\1", drop_vars)
#       gsub("\\[i\\]", "", subscripts)
#     })
#
#   lev_vary$betas <- gsub("\\d", "", lev_vary$betas)
#   lev_vary <- lapply(lev_vary, strsplit, ",")
#
#   lev_vary$int <- with(lev_vary, int[vapply(int, length, numeric(1)) > 0])
#   lev_vary$betas <- with(lev_vary, betas[vapply(betas, length, numeric(1)) > 0])
#
#   if(index) {
#     int <- paste0("\\alpha_{", unlist(lev_vary$int), "}")
#     if(length(lev_vary$betas) > 0) {
#       betas <- Map(function(index, level) {
#         paste0("\\beta_{", index, level, "}")
#       },
#       index = names(lev_vary$betas),
#       level = lev_vary$betas)
#       betas <- unlist(betas)
#     } else {
#       return(int) # if no slopes - return just the intercept
#     }
#   } else { # if no index
#     int <- "\\alpha"
#     if(length(lev_vary$betas) > 0) {
#       betas <- lapply(lev_vary$betas, function(level) {
#         paste0("\\beta_{", level, "}")
#         })
#       betas <- unlist(betas)
#     } else {
#       return(int)
#     }
#   }
#   c(int, betas)
# }

#### Create array functions ####

#' Create a one column array from a vector
#' This may be able to be incorporated into the `convert_matrix` function
#' @param v character vector to put into a one-column array
#' @keywords internal
#' @noRd
#' @examples \dontrun {
#' equatiomatic:::create_onecol_array(c("\\alpha_{j}", "\\beta_{1j}"))
# #> [1] "\\left(\n \\begin{array}{c} \\alpha_{j} \\\\ \\beta_{1j}
#          \\end{array}\n \\right)"
#' }
#' # Note that the actual function does not return with the linebreak
create_onecol_array <- function(v) {
  if(length(v) == 1 | is.null(v)) {
    return(v)
  }
  v <- paste0("&", v)
  paste0(
    "\\left(\n \\begin{array}{c} \n",
        "\\begin{aligned}\n",
         paste0(v, collapse = " \\\\ "),
        "\n",
        "\\end{aligned}\n",
      " \\end{array}\n \\right)"
  )
}

#' Convert a matrix to a LaTeX array
#' @param mat An R matrix
#' @keywords internal
#' @noRd
#' @examples \dontrun {
#' m <- matrix(c("\\sigma^2_{\\alpha_{j}}",
#'               "\\rho \\sigma_{\\beta_{1j}} \\sigma_{\\alpha_{j}}",
#'               "\\rho \\sigma_{\\alpha_{j}} \\sigma_{\\beta_{1j}}",
#'               "\\sigma^2_{\\beta_{1j}"),
#'             ncol = 2)
#' equatiomatic:::convert_matrix(m)
# #> [1] "\\left(\n \\begin{array}{cc}\\sigma^2_{\\alpha_{j}} &
# #>                \\rho \\sigma_{\\alpha_{j}} \\sigma_{\\beta_{1j}} \\\\
# #>                \\rho \\sigma_{\\beta_{1j}} \\sigma_{\\alpha_{j}} &
# #>                \\sigma^2_{\\beta_{1j}\\end{array}\n \\right)"
#' }
#' # Note - actual output doesn't have line breaks
convert_matrix <- function(mat) {
  if(all(dim(mat) == c(1, 1))) {
    return(mat)
  }
  cols <- paste(rep("c", ncol(mat)), collapse = "")
  paste0(
    "\\left(
    \\begin{array}{", cols, "}",
    paste(apply(mat, 1, paste, collapse = " & "), collapse = "\\\\"),
    "\\end{array}
    \\right)"
  )
}

#' Pull just the covariances
#' @param rhs output from \code{extract_rhs}
#' @keywords internal
#' @noRd
extract_random_covars <- function(rhs) {
  order <- rhs[rhs$group != "Residual", ]
  order <- sort(tapply(order$original_order, order$group, min))

  vc <- rhs[rhs$group != "Residual" & rhs$effect == "ran_pars", ]
  splt <- split(vc, vc$group)[names(order)]

  lapply(splt, function(x) {
    vars <- x[grepl("cor__", x$term), ]
    gsub("cor__(.+)", "\\1", vars$term)
  })
}

#' Left hand side of the variance-covariance matrix
#'
#' These are the the coefficients that randomly vary, and for which we want
#' to show how they are assumed distributed.
#' @param rhs output from \code{extract_rhs}
#' @keywords internal
#' @noRd
create_lhs_vcov_merMod <- function(model) {
  greek <- create_greek_merMod(model)
  lapply(greek$random, function(x) create_onecol_array(names(x)))
}

#' Create mean structure showing how the random effects are distributed
#' @param rhs output from \code{extract_rhs}
#' @keywords internal
#' @noRd
create_mean_structure_merMod <- function(model, ital_vars) {
  rhs <- extract_rhs(model)
  greek <- create_greek_merMod(model)
  
  final <- lapply(greek$final, function(x) lapply(x, function(y) {
    if(length(y) > 1) {
      paste(names(y), "(", create_term(rhs[rhs$term %in% y, ], ital_vars), ")")
    } else {
      names(y) <- paste0("\\mu_{", names(y), "}")
    }
  }))
  
  # remove empty parens around intercepts
  final <- lapply(final, function(x) lapply(x, function(y) {
    gsub("\\(  \\)", "", y)
  }))
  
  means <- lapply(final, function(x) lapply(x, function(y) {
      paste0(y, collapse = " + ")
  }))
  
  means <- lapply(means, function(x) Reduce(`c`, x))
  
  lapply(means, create_onecol_array)
}

##### Create actual variance-covariance matrix

# Create the variance terms (for the diagonals)
create_vars_merMod <- function(model) {
  greek <- create_greek_merMod(model)
  lapply(greek$random, function(x) paste0("\\sigma^2_{", names(x), "}"))
}

# Create the covariance terms (off-diagonals)
create_covars_merMod <- function(model) {
  rhs <- extract_rhs(model)
  random_covars <- extract_random_covars(rhs)
  greek <- create_greek_merMod(model)
  
  if(all(unlist(lapply(random_covars, function(x) length(x) == 0)))) {
    return()
  }
  
  # First replace non-interaction terms
  random_covars_greek1 <- Map(function(x, y) {
    sub_vectorized(x, y, names(y))
  },
  x = lapply(random_covars, function(x) x[!grepl(":", x)]),
  y = lapply(greek$random, function(x) x[!grepl(":", x)]) 
  )

  # Then replace interaction terms
  random_covars_greek2 <- Map(function(x, y) {
    sub_vectorized(x, y, names(y))
  },
  x = lapply(random_covars, function(x) x[grepl(":", x)]),
  y = lapply(greek$random, function(x) x[grepl(":", x)])
  )

  # Replace non-interaction terms in the interaction vector
  random_covars_greek2 <- Map(function(x, y) {
    sub_vectorized(x, y, names(y))
  },
  x = random_covars_greek2,
  y = lapply(greek$random, function(x) x[!grepl(":", x)])
  )

  # Now put them together
  random_covars_greek <- Map(`c`, random_covars_greek1, random_covars_greek2)
  random_covars_greek <- lapply(random_covars_greek, sort)

  lapply(random_covars_greek, function(x) {
    if(length(x) > 0) {
      paste("\\rho", gsub("\\.", " ", x))
    }
  })
}

# Flip the order of two terms (e.g., "\\alpha \\beta" becomes "\\beta \\alpha")
flip_order <- function(text) {
  splt <- strsplit(text, " ")[[1]]
  paste(splt[c(1, 3, 2)], collapse = " ")
}

#' Create variance-covariance matrix for random effects
#' @param rhs output from \code{extract_rhs}
#' @keywords internal
#' @noRd
#' @examples \dontrun {
#' library(lme4)
#' m <- lmer(bill_length_mm ~ bill_depth_mm +
#'            (bill_depth_mm | species) +
#'            (bill_depth_mm | island), data = penguins)
#' rhs <- equatiomatic:::extract_rhs(m)
#' equatiomatic:::create_vcov_matrix_merMod(rhs)
# #> $island
# #> [1] "\\left(\n \\begin{array}{cc}\\sigma^2_{\\alpha} &
# #>      \\rho \\sigma_{\\alpha} \\sigma_{\\beta_{1}} \\\\
# #>      \\rho \\sigma_{\\beta_{1}} \\sigma_{\\alpha} &
# #>      \\sigma^2_{\\beta_{1}}\\end{array}\n \\right)"
#
# #> $species
# #> [1] "\\left(\n \\begin{array}{cc}\\sigma^2_{\\alpha} &
# #>      \\rho \\sigma_{\\alpha} \\sigma_{\\beta_{1}}\\\\
# #>      \\rho \\sigma_{\\beta_{1}} \\sigma_{\\alpha} &
# #>      \\sigma^2_{\\beta_{1}}\\end{array}\n \\right)"
#' }
# # Note that linebreaks are not actualy there
create_vcov_matrix_merMod <- function(model) {
  rhs <- extract_rhs(model)
  vars <- create_vars_merMod(model)
  covars <- create_covars_merMod(model)

  matrices <- lapply(vars, function(x) diag(length(x)))

  if(all(unlist(lapply(covars, is.null)))) {
    matrices <- Map(function(m, var) {
      diag(m) <- var
      m
    },
    m = matrices,
    var = vars)
  } else {
    matrices <- Map(function(m, var, covar) {
      diag(m) <- var
      if(!is.null(covar)) {
        m[lower.tri(m)] <- covar
        m[upper.tri(m)] <- t(m)[upper.tri(m)]
      }
      m
    },
    m = matrices,
    var = vars,
    covar = covars)
  }

  matrices <- lapply(matrices, function(x) {
    if(!all(dim(x) == c(1, 1))) {
      x[lower.tri(x)] <- vapply(x[lower.tri(x)], flip_order,
                                FUN.VALUE = character(1))
    }
    x
  })
  lapply(matrices, convert_matrix)
}

#' Create full random effects structure
#' @param model A fitted model from \code{\link[lme4]{lmer}}
#' @keywords internal
#' @noRd
#' @examples \dontrun {
#' library(lme4)
#' m <- lmer(bill_length_mm ~ bill_depth_mm +
#'            (bill_depth_mm | species) +
#'            (bill_depth_mm | island), data = penguins)
#' equatiomatic:::create_ranef_structure_merMod(m)
# #> [1] "\\left(\n \\begin{array}{c} \\alpha_{k} \\\\ \\beta_{1k} \\end{array}
# #>       \n  \\right)\\sim N \\left(\\left(\n \\begin{array}{c}
# #>       \\mu_{\\alpha} \\\\ \\mu_{\\beta_{1}} \\end{array}\n \\right),
# #>       \\left(\n    \\begin{array}{cc}\\sigma^2_{\\alpha} & \\rho
# #>       \\sigma_{\\alpha} \\sigma_{\\beta_{1}}\\\\\\rho \\sigma_{\\beta_{1}}
# #>       \\sigma_{\\alpha} & \\sigma^2_{\\beta_{1}}\\end{array}\n \\right)
# #>       \\right) , \\text{ for  species } j  = 1, \\dots ,  J \\\\
# #>       \\left(\n \\begin{array}{c} \\alpha_{j} \\\\ \\beta_{1j}
# #>       \\end{array}\n     \\right)\\sim N \\left(\\left(\n
# #>       \\begin{array}{c} \\mu_{\\alpha} \\\\ \\mu_{\\beta_{1}}
# #>       \\end{array}\n \\right),\\left(\n \\begin{array}{cc}
# #>       \\sigma^2_{\\alpha} & \\rho \\sigma_{\\alpha}
# #>       \\sigma_{\\beta_{1}}\\\\\\rho \\sigma_{\\beta_{1}}
# #>       \\sigma_{\\alpha} & \\sigma^2_{\\beta_{1}}\\end{array}\n
# #>       \\right) \\right) , \\text{ for  island } k  = 1, \\dots ,  K"
#' }
#' # Note line breaks are not actually produced
#'
create_ranef_structure_merMod <- function(model, ital_vars) {
  rhs <- extract_rhs(model)
  lhs <- create_lhs_vcov_merMod(model)
  
  means <- create_mean_structure_merMod(model, ital_vars)
  error_structure <- create_vcov_matrix_merMod(model)

  norm <- wrap_normal_dist(means, error_structure)
  levs <- vapply(names(means), escape_tex, FUN.VALUE = character(1))
  indexes <- letters[10:(10 + (length(levs) - 1))]
  
  norm <- paste(norm, ", \\operatorname{ for ", levs, "}",
                indexes, " = 1, \\dots , ", toupper(indexes))

  norm <- paste0(lhs, "\\sim ", norm)

  paste0(norm, collapse = " \\\\ ")

}

detect_covar_level <- function(predictor, group) {

  nm <- names(group)
  v <- paste(predictor, group[ ,1], sep = " _|_ ")
  unique_v <- unique(v)
  test <- gsub(".+\\s\\_\\|\\_\\s(.+)", "\\1", unique_v)
  
  if(all(!duplicated(test))) {
    return(nm)
  }
}

detect_X_level <- function(X, group) {
  lapply(X, detect_covar_level, group)
}

collapse_list <- function(x, y) {
  null_x <- vapply(x, function(x) {
    if(any(is.null(x))) {
      return(is.null(x))
    } else return(is.na(x))
  }, FUN.VALUE = logical(1))
  
  null_y <- vapply(y, function(x) {
    if(any(is.null(x))) {
      return(is.null(x))
    } else return(is.na(x))
  }, FUN.VALUE = logical(1))
  
  y[null_x & !null_y] <- y[null_x & !null_y]
  y[!null_x & null_y] <- x[!null_x & null_y]
  y[!null_x & !null_y] <- x[!null_x & !null_y]
  
  unlist(lapply(y, function(x) ifelse(is.null(x), NA_character_, x)))
}

detect_group_coef <- function(model) {
  outcome <- all.vars(formula(model))[1]
  rhs <- extract_rhs(model)
  d <- model@frame
  
  random_levs <- names(extract_random_vars(rhs))
  random_lev_ids <- d[names(extract_random_vars(rhs))]
  X <- d[!(names(d) %in% c(random_levs, outcome))]
  
  lev_assign <- vector("list", length(random_levs))
  for(i in seq_along(random_lev_ids)) {
    lev_assign[[i]] <- detect_X_level(X, random_lev_ids[ , i, drop = FALSE])
  }

  out <- Reduce(collapse_list, rev(lev_assign))
  out[!is.na(out)]
}

