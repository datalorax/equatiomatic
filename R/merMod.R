#' Utility function to wrap things as normally distributed
#' @keywords internal
#' @noRd
wrap_normal_dist <- function(mean, sigma = "\\sigma^2") {
  paste0("N \\left(", mean, ",", sigma, " \\right)")
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

create_greek_merMod <- function(rhs) {
  fixed <- extract_fixef_merMod(rhs)
  random <- extract_random_vars(rhs)
  lev_indexes <- letters[10:(10 + (length(random) - 1))]

  # fixed effects
  if("(Intercept)" %in% unlist(random)) {
    names(fixed) <- ifelse(fixed == "(Intercept)", "\\alpha_{", paste0("\\beta_{", seq_along(fixed) - 1))
  } else {
    names(fixed) <- c("\\alpha", (paste0("\\beta_{", seq_along(fixed)[-length(fixed)])))
  }
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

  # random effects

  # create beta indexes (drop intercept)
  indexes <- lapply(random, function(x) x[!grepl("Intercept", x)])
  indexes <- lapply(indexes, function(x) seq_along(fixed)[fixed %in% x] - 1)
  random <- Map(function(r, lev) {
    names(r) <- gsub("(Intercept)",
                     paste0("\\alpha_{", lev, "}"),
                     r,
                     fixed = TRUE)
    r
  },
  r = random,
  lev = lev_indexes
  )

  random <- Map(function(r, index, lev) {
    names(r)[grepl("[^\\(Intercept\\)]", r)] <- paste0("\\beta_{", index, lev, "}")
    r
  },
  r = random,
  index = indexes,
  lev = lev_indexes
  )
  list(fixed = fixed, random = random)
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
  greek <- create_greek_merMod(rhs)
  terms <- create_term(rhs[rhs$effect == "fixed", ], ital_vars)
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
  if(length(v) == 1) {
    return(v)
  }
  paste0(
    "\\left(
       \\begin{array}{c} ",
         paste0(v, collapse = " \\\\ "),
      " \\end{array}
     \\right)"
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
create_lhs_vcov_merMod <- function(rhs) {
  greek <- create_greek_merMod(rhs)
  lapply(greek$random, function(x) create_onecol_array(names(x)))
}

#' Create mean structure showing how the random effects are distributed
#' @param rhs output from \code{extract_rhs}
#' @keywords internal
#' @noRd
create_mean_structure_merMod <- function(rhs) {
  greek <- create_greek_merMod(rhs)
  means <- lapply(greek$random, function(x) paste0("\\mu_{", names(x), "}"))
  lapply(means, create_onecol_array)
}

##### Create actual variance-covariance matrix

# Create the variance terms (for the diagonals)
create_vars_merMod <- function(rhs) {
  greek <- create_greek_merMod(rhs)
  lapply(greek$random, function(x) paste0("\\sigma^2_{", names(x), "}"))
}

# Create the covariance terms (off-diagonals)
create_covars_merMod <- function(rhs) {
  greek <- create_greek_merMod(rhs)
  random_covars <- extract_random_covars(rhs)

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
create_vcov_matrix_merMod <- function(rhs) {
  vars <- create_vars_merMod(rhs)
  covars <- create_covars_merMod(rhs)

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
create_ranef_structure_merMod <- function(model) {
  rhs <- extract_rhs(model)
  lhs <- create_lhs_vcov_merMod(rhs)

  means <- create_mean_structure_merMod(rhs)
  error_structure <- create_vcov_matrix_merMod(rhs)

  norm <- wrap_normal_dist(means, error_structure)
  levs <- names(means)
  indexes <- letters[10:(10 + (length(levs) - 1))]
  norm <- paste(norm, ", \\text{ for ", levs, "}",
                indexes, " = 1, \\dots , ", toupper(indexes))

  norm <- paste0(lhs, "\\sim ", norm)

  paste0(norm, collapse = " \\\\ ")

}
