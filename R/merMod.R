#' Provides the order of the levels
#' @param rhs_random output from \code{extract_rhs.lmerMod}, subset as 
#' \code{rhs[rhs$effect == "ran_pars", ]}.
#' @noRd
get_order <- function(rhs_random) {
  sort(tapply(rhs_random$original_order, rhs_random$group, min))
} 

vary_higher_subscripts <- function(term, rhs_random, lev_omit = NULL) {
  splt_random <- split(rhs_random, rhs_random$group)
  lev_indexes <- letters[seq_along(splt_random) + 9]
  
  order <- get_order(rhs_random)
  splt_random <- splt_random[names(order)]
  
  if (!is.null(lev_omit)) {
    lev_indexes <- lev_indexes[-seq_along(grep(lev_omit, names(splt_random)))]
    splt_random <- splt_random[-seq_along(grep(lev_omit, names(splt_random)))]
  }
  
  out <- rep(NA_character_, length(lev_indexes))
  for (i in seq_along(splt_random)) {
    if (any(grepl(term, splt_random[[i]]$term))) {
      out[i] <- paste0(lev_indexes[i], "[i]")
    }
  }
  paste0(out[!is.na(out)], collapse = ",")
}

#' Create a vector to split by
#' The vector denotes which level the term (for the given row) 
#' should be added to in the equation (e.g., l1, l2, l3, etc.)
#' @param rhs_fixed output from \code{extract_rhs.lmerMod}, subset as 
#' \code{rhs[rhs$effect == "fixed", ]}
#' @param rhs_random output from \code{extract_rhs.lmerMod}, subset as 
#' \code{rhs[rhs$effect == "ran_pars", ]}
#' @return A named vector where the names represent the term and the 
#' values represent the level. For example, the output may look similar
#' to \code{c("(Intercept)" = "l1", "wave" = "l1", 
#'          "grouplow" = "sid", "groupmedium" = "sid")}
#' @noRd        
pred_level_split <- function(rhs_fixed, rhs_random) {

  order <- get_order(rhs_random)
  
  vapply(rhs_fixed$pred_level, function(x) {
    if (length(x) == 0) out <- "l1"
    if (length(x) == 1) out <- x
    if (length(unique(x)) == 1) out <- unique(x)
    if (length(unique(x)) > 1) {
      out <- order[x]
      out <- names(out[which.max(out)])
    }
    out
  }, FUN.VALUE = character(1))
}

pull_term_subscript <- function(greek_coef, n = 1) {
  regex <- paste0("(.+\\{.{", n, "}).+(\\})")
  gsub(regex, "\\1\\2", greek_coef)
}

pull_min_level <- function(one_crossdata, one_detected, one_lev, one_var, 
                           order) {
  all_vars <- mapply_chr(function(lev, var) {
    d <- one_crossdata[[lev]]
    
    out <- d[d$term == var, ]$greek
    if (length(out) == 0) {
      return("")
    }
    out
  }, one_lev, one_var)
  
  min_lev <- one_lev[which.min(order[one_lev])]
  all_vars[names(min_lev)]
}

pull_superscript <- function(slp_preds, detect_cross, cross_data, order) {
  order <- c("l1" = 0, order)
  levs <- Map(function(predlev, detected) {
    predlev[detected]
  }, slp_preds$pred_level, detect_cross)
  
  vars <- Map(function(splt, detected) {
    splt[detected]
  }, slp_preds$split, detect_cross)
  
  ss <- mapply_chr(function(cd, detected, lev, var) {
    pull_min_level(cd, detected, lev, var, order)
  }, cross_data, detect_cross, levs, vars)
  
  superscripts <- if (length(ss) == 0) {
    ""
  } else {
    ifelse(is.na(ss), "", ss)
  }
  superscripts
}


#' Creates the greek for the level 1 fixed effects
#' @param rhs_fixed output from \code{extract_rhs.lmerMod}, subset as 
#' \code{rhs[rhs$effect == "fixed", ]}
#' @param rhs_random output from \code{extract_rhs.lmerMod}, subset as 
#' \code{rhs[rhs$effect == "ran_pars", ]}
#' @return A character vector the same length at the number of rows in 
#'   \code{rhs_fixed} with the greek assigned for those that are at level 1 and 
#'   \code{NA_character_} otherwise (higher-level predictors).
#' @noRd
assign_l1_greek <- function(rhs_fixed, rhs_random) {
  beta_indices <- seq_along(rhs_fixed$l1[rhs_fixed$l1])
  if (any(rhs_fixed$term == "(Intercept)" & rhs_fixed$l1)) {
    beta_indices <- beta_indices[-length(beta_indices)]
  }
  l1 <- rep(NA_character_, length(rhs_fixed$term))
  l1[rhs_fixed$term == "(Intercept)" & rhs_fixed$l1] <- "\\alpha_{"
  l1[rhs_fixed$term != "(Intercept)" & rhs_fixed$l1] <- paste0("\\beta_{", beta_indices)
  
  terms <- rhs_fixed$term[!is.na(l1)]
  
  ss <- vapply(terms, function(x) vary_higher_subscripts(x, rhs_random),
               FUN.VALUE = character(1))
  l1[!is.na(l1)] <- paste0(l1[!is.na(l1)], ss, "}")
  l1  
}

#' Takes one level of the fixed effects data and assigns greek for that level
#' @param lev_data One level of the data, e.g. \code{splt[[1]]} where 
#'   \code{splt} is the \code{rhs_fixed} data split by the \code{predsplit} 
#'   column.
#' @param lev_data_name A character vector specifying the name of the level, 
#'   e.g., \code{"sid"}, \code{"school"}, \code{"site"}.
#' @param splt The \code{rhs_fixed} data split by the \code{predsplit} 
#'   column.
#' @param rhs_random output from \code{extract_rhs.lmerMod}, subset as 
#' \code{rhs[rhs$effect == "ran_pars", ]}
#' @return The full data \code{rhs_fixed} data frame for that level with the
#'   \code{greek} column filled in
#' @noRd
assign_higher_levels <- function(lev_data, lev_data_name, splt, rhs_random) {
  if (is.null(lev_data)) {
    return()
  }
  split_terms <- split(lev_data, lev_data$crosslevel)
  order <- get_order(rhs_random)
  
  # create intercepts
  int_preds <- split_terms$`FALSE`
  ss <- lapply(int_preds$term, function(x) vary_higher_subscripts(x, rhs_random, lev_data_name))
  int_preds$greek <- paste0("\\gamma_{", seq_len(nrow(int_preds)), ss, "}")
  
  # Cross-level interactions
  slp_preds <- split_terms$`TRUE`
  if (is.null(slp_preds)) {
    return(int_preds)
  }
  
  detect_cross <- lapply(slp_preds$pred_level, function(x) {
    !grepl(lev_data_name, x)
  })
  
  cross_data <- Map(function(pred_levs, cross_detected) {
    splt[pred_levs[cross_detected]]
  },
  slp_preds$pred_level,
  detect_cross)
  
  superscripts <- pull_superscript(slp_preds, detect_cross, cross_data, order)
  superscripts <- pull_term_subscript(superscripts)
  
  coef_number <- unlist(tapply(superscripts, superscripts, seq_along))
  
  subscripts <- vapply(slp_preds$term, function(x) {
    vary_higher_subscripts(x, rhs_random, lev_data_name)
  }, FUN.VALUE = character(1))
  
  slp_preds$greek <- paste0("\\gamma^{", superscripts, "}_{", coef_number, subscripts, "}")
  
  # return
  out <- rbind(int_preds, slp_preds)
  out[order(out$original_order), ]
}

#' Create the fixed effects portion of the equation
#' @param model The fitted \code{\link[lme4]{lmer}} model
#' @return The \code{extract_rhs} data frame where \code{effect == fixed} with
#'   a new \code{greek} column denoting the greek for the specific
#'   coefficient (including indexing for the levels the fixed effects vary
#'   at), and a new \code{predsplit} column that allows this data frame
#'   to be split by the level at which the variable predicts.
#' @noRd
create_fixef_greek_merMod <- function(model, return_variances) {
  rhs <- extract_rhs(model, return_variances)
  rhs_fixed <- rhs[rhs$effect == "fixed", ]
  rhs_random <- rhs[rhs$effect == "ran_pars", ]
  rhs_random <- rhs_random[rhs_random$group != "Residual", ]
  
  order <- get_order(rhs_random)
  
  # fixed effects
  rhs_fixed$greek <- assign_l1_greek(rhs_fixed, rhs_random)
  rhs_fixed$predsplit <- pred_level_split(rhs_fixed, rhs_random)
  
  splt <- split(rhs_fixed, rhs_fixed$predsplit)[c("l1", names(order))]
  splt <- splt[!vapply(splt, is.null, FUN.VALUE = logical(1))]
  
  for (i in seq_along(splt)[-1]) {
    splt[[i]] <- assign_higher_levels(splt[[i]], names(splt)[i], splt, rhs_random) 
  }
  
  Reduce(rbind, splt)
}

pull_cross_var <- function(cross_splt_frame, order) {
  if (nrow(cross_splt_frame) == 0) {
    return()
  }
  interaction_terms <- strsplit(cross_splt_frame$term, ":")
  order <- c("l1" = 0, order)
  orders <- lapply(cross_splt_frame$pred_level, function(x) {
    order[x]
  })
  
  # put in order from lowest to highest level
  interaction_terms <- Map(order_split, 
                           interaction_terms, 
                           cross_splt_frame$pred_level)
  
  term <- mapply_chr(function(interaction, order) {
    interaction[which.min(order)]
  }, interaction_terms, orders)
  unique(term)
}

rm_crosslev_int_redundancy <- function(model, lev_data, term) {
  formula_rhs <- labels(terms(formula(model)))
  formula_rhs <- formula_rhs[!grepl(":|\\|", formula_rhs)]
  terms <- vapply(term, function(x) {
    unlist(extract_primary_term(formula_rhs, x))
  }, FUN.VALUE = character(1))
  
  subset <- lapply(lev_data$primary, function(x) {
    exact <- x %in% paste0(terms, collapse = "|")
    detected <- grepl(paste0(terms, collapse = "|"), x)
    
    if (any(exact)) {
      !exact
    } else {
      !detected
    }
  })
  
  lev_data$primary <- Map(function(x, ss) x[ss], lev_data$primary, subset)
  lev_data$subscripts <- Map(function(x, ss) x[ss], lev_data$subscripts, subset)
  lev_data
}

# Make cross-level interactions go on the intercept level if the coef
# it predicts doesn't vary at this level (because there's no mean structure
# for it)
check_interact_vary <- function(splt_lev_fixed, splt_lev_random, order) {
  cross <- splt_lev_fixed[splt_lev_fixed$crosslevel, ]
  lower_var <- pull_cross_var(cross, order)
  check_vary <- lower_var %in% splt_lev_random$term
  
  check <- vapply(lower_var, function(x) {
    grepl(x, splt_lev_fixed$term)
  }, FUN.VALUE = logical(length(splt_lev_fixed$term)))
  as.logical(check %*% check_vary)
}

pull_intercept <- function(splt_lev_fixed, splt_lev_random, order, 
                           use_coefs, coef_digits, fix_signs) {

  int <- "\\alpha"

  if (is.null(splt_lev_fixed)) {
    return()
  }
  
  check <- check_interact_vary(splt_lev_fixed, splt_lev_random, order)
  
  # Check if lower-level variable in cross-level interactions varies at this level
  splt_lev_fixed$crosslevel <- check & splt_lev_fixed$crosslevel
    
  nocross <- splt_lev_fixed[!splt_lev_fixed$crosslevel, ]
  
  # remove any previous superscripts
  nocross$greek <- gsub("(.+)\\^.+(_\\{.+$)", "\\1\\2",  nocross$greek)
  
  # renumber
  nocross$greek <- paste0(gsub("(.+_\\{).+", "\\1", nocross$greek),
                          seq_along(nocross$greek),
                          gsub(".+_\\{.{1}(.+)", "\\1", nocross$greek))
  
  # add alpha superscript
  nocross$greek <- paste0(nocross$greek, paste0("^{", int, "}"))
  
  if (use_coefs) {
    coef_terms <- paste0(round(nocross$estimate, coef_digits), 
                         "_{", nocross$greek, "}",  
                         nocross$terms)
    if (length(coef_terms) == 0) {
      coef_terms <- 0
    }
    coef_terms <- paste0(coef_terms, collapse = " + ")
    if (fix_signs) {
      coef_terms <- fix_coef_signs(coef_terms)
    }
    out <- data.frame(term = "(Intercept)", 
                      greek = coef_terms)
  } else {
    coef_terms <- paste0(nocross$greek, nocross$terms)
    # add intercept term
    coef_terms <- c(paste0("\\gamma_{0}^{", int, "}"), coef_terms)
    out <- data.frame(term = "(Intercept)", 
                      greek = paste0(coef_terms, collapse = " + "),
                      stringsAsFactors = FALSE)
    if (nrow(out) == 0) {
      return()
    }
  }

  out
}

pull_slope_superscript <- function(greek) {
  gsub(".+\\^\\{(.+)\\}_.+", "\\1", greek)
}

create_slope_intercept <- function(term) {
  gsub("(.+)(.{1})(\\}$)", "\\10\\3", term)
}

pull_slopes <- function(model, splt_lev_fixed, splt_lev_random, ital_vars,
                        order, use_coefs, coef_digits, fix_signs) {
  if (is.null(splt_lev_fixed)) {
    return()
  }
  
  check <- check_interact_vary(splt_lev_fixed, splt_lev_random, order)
  splt_lev_fixed$crosslevel <- check & splt_lev_fixed$crosslevel
  
  cross <- splt_lev_fixed[splt_lev_fixed$crosslevel, ]
  
  # pull the specific slope that is predicted by the cross-level interaction
  cross$slope_predicted <- pull_slope_superscript(cross$greek)
  
  # split the df by the slope that is predicted
  cross_splt <- split(cross, cross$slope_predicted)
  
  # pull the name of the variable being predicted
  terms_predicted <- lapply(cross_splt, pull_cross_var, order)
  
  # remove that variable from interaction so there's no redundancies
  cross_splt <- Map(function(cross, terms) {
    rm_crosslev_int_redundancy(model, cross, terms)
  }, cross_splt, terms_predicted)
  
  # recreate terms
  cross_splt <- lapply(cross_splt, function(x) {
    x$terms <- create_term(x, ital_vars)
    
    x$terms <- vapply(x$terms, function(x) {
      if (nchar(x) == 0) {
        return("")
      }
      paste0("(", x, ")")
    }, character(1))
    x
  })
  
  if (use_coefs) {
    final_slopes <- lapply(cross_splt, function(x) {
      slopes <- paste0(round(x$estimate, coef_digits),
                       "_{",
                       #gsub("(^.+)\\^\\{.+\\}\\}(.+)", 
                        #    "\\1\\2", 
                        cross_splt[[1]]$greek, #),
                       "}",
                       x$terms)
      paste0(slopes, collapse = " + ")
    })
  } else {
    final_slopes <- lapply(cross_splt, function(x) {
      int <- create_slope_intercept(x$greek[1])
      slopes <- paste0(x$greek, x$terms)
      paste0(c(int, paste0(slopes, collapse = " + ")), collapse = " + ")
    })
  }
  if (fix_signs) {
    final_slopes <- lapply(final_slopes, fix_coef_signs)
  }
  out <- data.frame(term = unlist(terms_predicted),
                    greek = unlist(final_slopes))
  if (nrow(out) == 0) {
    return()
  }
  out
}

rbind_named <- function(l) {
  null <- vapply(l, is.null, FUN.VALUE = logical(1))
  l <- Map(function(lst, lst_names) {
    lst$group <- lst_names
    lst
  }, l[!null], names(l)[!null])
  
  Reduce(rbind, l)
}

#' Create the mean structure for the VCV matrix
#' @param rhs Output from \code{extract_rhs}
#' @param fixed_greek_mermod Output from \code{create_fixef_greek_merMod}.
#' @param model The fitted \code{\link[lme4]{lmer}} model
#' @param ital_vars Logical, defaults to \code{FALSE}. Should the variable
#'   names not be wrapped in the \code{\\operatorname{}} command?
#' @return A data frame with each term that varies at each higher level (term), 
#' the level at which it varies (group), the greek for the mean structure 
#' (greek), and the greek for the term that is varying (greek_vary). The 
#' \code{greek_vary} column defines the left hand side of ~. The greek for the 
#' mean structure (greek) will include any group-level predictors. If there are 
#' none, it will be replaced by \code{"\\mu_{greek_vary}"} where 
#' \code{greek_vary} is actually substituted in.
#' @noRd
create_means_merMod <- function(rhs, fixed_greek_mermod, model, ital_vars,
                                use_coefs, coef_digits, fix_signs) {
  rhs_random <- rhs[rhs$effect == "ran_pars", ]
  rhs_random <- rhs_random[rhs_random$group != "Residual" &
                             !grepl("^cor__", rhs_random$term), ]
  rhs_random$term <- gsub("sd__", "", rhs_random$term)
  
  order <- get_order(rhs_random)
  
  fixed_greek_mermod$terms <- create_term(fixed_greek_mermod, ital_vars)
  
  fixed_greek_mermod$terms <- vapply(fixed_greek_mermod$terms, function(x) {
    if (nchar(x) == 0) {
      return("")
    }
    paste0("(", x, ")")
  }, character(1))
  
  splt_fixed <- split(fixed_greek_mermod, fixed_greek_mermod$predsplit)
  splt_fixed <- splt_fixed[names(order)]
  names(splt_fixed) <- names(order)
  
  splt_rand <- split(rhs_random, rhs_random$group)
  splt_rand <- splt_rand[names(order)]
  names(splt_rand) <- names(order)
  
  ints <- Map(function(fixed, rand) {
    pull_intercept(fixed, rand, order, use_coefs, coef_digits, fix_signs)
  }, splt_fixed, splt_rand)
  ints <- rbind_named(ints)
  
  slopes <- Map(function(fixed, rand) {
    pull_slopes(model, fixed, rand, ital_vars, order, 
                use_coefs, coef_digits, fix_signs)
  }, splt_fixed, splt_rand)
  slopes <- rbind_named(slopes)
  
  int_slopes <- rbind(ints, slopes)
  if (is.null(int_slopes)) {
    out <- rhs_random
    out$greek <- NA_character_
    
  } else {
    out <- merge(rhs_random, int_slopes, 
                 all.x = TRUE, by = c("group", "term")) 
  }
  out <- out[order(out$original_order), c("group", "term", "greek", "original_order")]  
  random_vary <- fixed_greek_mermod[fixed_greek_mermod$term %in% unique(out$term), ]
  random_vary$greek_vary <- gsub("(.+\\{\\d?).+", "\\1}", random_vary$greek)
  random_vary$new_order <- random_vary$original_order
  
  out <- merge(out, 
               random_vary[, c("term", "greek_vary", "new_order")], 
               by = "term", 
               all.x = TRUE)
  
  lev_indexes <- setNames(letters[seq_along(order) + 9], names(order))
  lev_indexes <- lev_indexes[match(out$group, names(lev_indexes))]
  out$greek_vary <- ifelse(
    is.na(out$greek_vary), 
    "",
    paste0(gsub("(.+)\\}", "\\1", out$greek_vary), lev_indexes, "}")
  )
  
  if (use_coefs) {
    out$greek <- ifelse(is.na(out$greek), 0, out$greek)
  } else {
    out$greek <- ifelse(is.na(out$greek), 
                        paste0("\\mu_{", out$greek_vary, "}"),
                        out$greek) 
  }

  out[order(out$new_order), ]
}

assign_vcov_greek <- function(rand_lev, means_merMod) {
  assign <- lapply(rand_lev$terms, function(x) {
    means_merMod$greek_vary[match(x, means_merMod$term)]
  })
  lapply(assign, function(x) {
    if (length(x) == 1) {
      return(c(x, x))
    } else {
      x
    }
  })
}

create_greek_matrix <- function(v, mat, use_coefs, coef_digits, est) {
  if (identical(use_coefs, FALSE)) {
    if (length(unique(v)) == 1) {
      greek_vcov <- paste0("\\sigma^2_{", v[1], "}")
    } else {
      greek_vcov <- paste0("\\rho_{", 
                           paste0(v, collapse = ""), 
                           "}", 
                           collapse = "")
    }
  } else {
    greek_vcov <- round(est, coef_digits)
  }
  
  mat[v[1], v[2]] <- greek_vcov
  mat
}

pull_var <- function(term) {
  if (grepl("^cor__", term)) {
    ran_part <- gsub("(.+\\.).+", "\\1", term)
    term <- gsub(ran_part, "", term, fixed = TRUE)
  } else if (grepl("^sd__", term)) {
    ran_part <- "sd__"
    term <- gsub(paste0("^", ran_part), "", term)
  }
  term
}


create_vcov_merMod <- function(rhs_random_lev, means_merMod, 
                               use_coefs, coef_digits) {

  rand_lev <- rhs_random_lev[, c("group", "term", "estimate")]
  rand_lev$terms <- gsub("sd__|cor__", "", rand_lev$term)
  rand_lev$terms <- strsplit(rand_lev$terms, "\\.")
  
  # add extra row for reverse on correlation
  cors <- rand_lev[grepl("^cor__", rand_lev$term), ]
  cors$terms <- lapply(cors$terms, rev)
  
  rand_lev <- rbind(rand_lev, cors)
  
  means <- means_merMod[means_merMod$group == unique(rand_lev$group), ]
  rand_lev$vcov_greek <- assign_vcov_greek(rand_lev, means)
  
  rand_lev$terms_var <- vapply(rand_lev$term, pull_var, FUN.VALUE = character(1))
  rand_lev <- merge(rand_lev, means[, c("term", "new_order")], 
                    by.x = "terms_var", 
                    by.y = "term", 
                    all.x = TRUE)
  rand_lev <- rand_lev[order(rand_lev$new_order), ]
  
  # Create matrix
  sd_rows <- grepl("^sd__", rand_lev$term)
  
  mat <- diag(sum(sd_rows))
  dimnames(mat) <- list(unique(unlist(rand_lev$vcov_greek[sd_rows])),
                        unique(unlist(rand_lev$vcov_greek[sd_rows])))
  for (i in seq_along(rand_lev$vcov_greek)) {
    mat <- create_greek_matrix(rand_lev$vcov_greek[[i]], mat, 
                               use_coefs, coef_digits, 
                               est = rand_lev$estimate[i])
  }
  mat
}

create_ranef_structure_merMod <- function(model, ital_vars, use_coefs,
                                          coef_digits, fix_signs, 
                                          return_variances) {
  rhs <- extract_rhs(model, return_variances)
  rhs_random <- rhs[rhs$effect == "ran_pars", ]
  order <- get_order(rhs_random[rhs_random$group != "Residual", ])
  
  fixed_greek_mermod <- create_fixef_greek_merMod(model, return_variances)
  means_merMod <- create_means_merMod(rhs, fixed_greek_mermod, 
                                      model, ital_vars,
                                      use_coefs, coef_digits, 
                                      fix_signs)
  
  means_splt <- split(means_merMod, means_merMod$group)[names(order)]
  names(means_splt) <- names(order)
  
  rhs_random_splt <- split(rhs_random, rhs_random$group)[names(order)]
  
  vcov_mats <- lapply(rhs_random_splt, function(x) {
    create_vcov_merMod(x, means_merMod, use_coefs, coef_digits)
  })
  
  # create each final latex piece
  lhs <- lapply(means_splt, function(x) create_onecol_array(x$greek_vary))
  means <- lapply(means_splt, function(x) create_onecol_array(x$greek)) 
  vcovs <- lapply(vcov_mats, convert_matrix)
  
  distributed <- Map(wrap_normal_dist, means, vcovs)
  
  Map(function(lhs, dist, name, index) {
    paste0("\n    ", lhs, " \\sim ", dist,
           "\n    \\text{, for ", name, " ", tolower(index), " = 1,}",
           " \\dots ", "\\text{,", toupper(index), "}")
  }, lhs, distributed, names(lhs), letters[seq_along(lhs) + 9])
}

#' Create a one column array from a vector
#' This may be able to be incorporated into the `convert_matrix` function
#' @param v character vector to put into a one-column array
#' @keywords internal
#' @noRd
#' @examples \dontrun {
#' equatiomatic:::create_onecol_array(c("\\alpha_{j}", "\\beta_{1j}"))
#'
#' }
#' # Note that the actual function does not return with the linebreak
create_onecol_array <- function(v) {
  if (length(v) == 1 | is.null(v)) {
    return(v)
  }
  v <- paste0("&", v)
  paste0("\n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n",
    paste0("      ", v, collapse = " \\\\\n"),
    "\n",
    "    \\end{aligned}\n",
    "  \\end{array}\n\\right)\n"
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
#' }
convert_matrix <- function(mat) {
  if (all(dim(mat) == c(1, 1))) {
    return(mat)
  }
  cols <- paste(rep("c", ncol(mat)), collapse = "")
  paste0("\n\\left(\n  \\begin{array}{", cols, "}\n",
    paste("    ", apply(mat, 1, paste, collapse = " & "), collapse = " \\\\ \n"),
    "\n  \\end{array}\n\\right)\n"
  )
}

create_l1_fixef <- function(model, ital_vars, use_coefs, coef_digits, 
                            mean_separate, fix_signs, wrap, terms_per_line, 
                            operator_location, return_variances) {
  rhs <- extract_rhs(model, return_variances)
  lhs <- extract_lhs(model, ital_vars, use_coefs)
  greek <- create_fixef_greek_merMod(model, return_variances)
  terms <- create_term(greek, ital_vars)
  
  terms <- vapply(terms, function(x) {
    if (nchar(x) == 0) {
      return("")
    }
    paste0("(", x, ")")
  }, character(1))
  
  if (use_coefs) {
    sigma <- round(sigma(model), coef_digits)
    l1 <- paste0(
      round(greek$estimate[greek$predsplit == "l1"], coef_digits),
      "_{", greek$greek[greek$predsplit == "l1"], "}",
      terms[greek$predsplit == "l1"]
    )
  } else {
    l1 <- paste0(greek$greek[greek$predsplit == "l1"], 
                 terms[greek$predsplit == "l1"])
    if(is_exposure_modeled(model)) {
      offset <- get_offset(model, ital_vars)
      l1 <- c(offset, l1)
    }
  }
  
  if (wrap) {
    if (operator_location == "start") {
      line_end <- "\\\\\n&\\quad + "
    } else {
      line_end <- "\\ + \\\\\n&\\quad "
    }
    l1 <- split(l1, ceiling(seq_along(l1) / terms_per_line))
    
    if (identical(mean_separate, FALSE)) {
      l1 <- lapply(l1, function(x) {
        terms_added <- paste0(x, collapse = " + ")
        paste0("&", terms_added)
      })
      l1 <- paste0("\\begin{aligned}\n", paste0(l1, collapse = "\\\\"), "\n\\end{aligned}")
      if (fix_signs) {
        l1 <- fix_coef_signs(l1)  
      }
    } else {
      l1 <- lapply(l1, paste0, collapse = " + ")
      l1 <- paste0(l1, collapse = line_end)
      if (fix_signs) {
        l1 <- fix_coef_signs(l1)  
      }
    }
  } else {
    l1 <- paste0(l1, collapse = " + ")
    if (fix_signs) {
      l1 <- fix_coef_signs(l1)  
    }
  }
}

create_l1 <- function(model, ...) {
  UseMethod("create_l1", model)
}

#' Create the full fixed-effects portion of an lmerMod
#'
#' @param model A fitted model from \code{\link[lme4]{lmer}}
#' @param ital_vars Logical, defaults to \code{FALSE}. Should the variable
#'   names not be wrapped in the \code{\\operatorname{}} command?
#' @param sigma The error term. Defaults to "\\sigma^2".
#' @keywords internal
#' @export
#' @noRd
#' @examples \dontrun{
#' library(lme4)
#' fm1 <- lmer(Reaction ~ Days + (Days | Subject), sleepstudy)
#' equatiomatic:::create_fixed_merMod(fm1, FALSE)
#' }
create_l1.lmerMod <- function(model, mean_separate,
                             ital_vars, wrap, terms_per_line,
                             use_coefs, coef_digits, fix_signs,
                             operator_location, sigma = "\\sigma^2",
                             return_variances) {
  
  rhs <- extract_rhs(model, return_variances)
  lhs <- extract_lhs(model, ital_vars, use_coefs)
  l1 <- create_l1_fixef(model, ital_vars, use_coefs, coef_digits, 
                        mean_separate, fix_signs, wrap, terms_per_line, 
                        operator_location, return_variances)
  if (is.null(mean_separate)) {
    mean_separate <- sum(rhs$l1) > 3
  }
  if (mean_separate) {
    paste0(lhs, " \\sim ", wrap_normal_dist("\\mu", sigma),
           " \\\\\n    \\mu &=", l1)
  }  else {
    paste(lhs, "\\sim", wrap_normal_dist(l1, sigma))
  }
}

#' @export
#' @noRd
create_l1.glmerMod <- function(model, mean_separate,
                              ital_vars, wrap, terms_per_line,
                              use_coefs, coef_digits, fix_signs,
                              operator_location, sigma = "\\sigma^2",
                              return_variances) {
  
  rhs <- extract_rhs(model, return_variances)
  lhs <- extract_lhs(model, ital_vars, use_coefs)
  l1 <- create_l1_fixef(model, ital_vars, use_coefs, coef_digits, 
                        mean_separate, fix_signs, wrap, terms_per_line, 
                        operator_location, return_variances)
  
  combo <- paste0(which_family(model), "-", which_link(model))
  
  switch(
    combo,
    "binomial-logit" = binomial_logit_l1(model, lhs, l1, ital_vars),
    "poisson-log" = poisson_log_l1(lhs, l1)
  )
}


