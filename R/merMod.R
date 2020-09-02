wrap_normal_dist <- function(mean, sigma = "\\sigma^2") {
  paste0("N \\left(", mean, ",", sigma, " \\right)")
}

assign_re_subscripts <- function(rhs) {
  re_levs <- unique(rhs$group)
  n_levels <- sum(re_levs != "Residual", na.rm = TRUE)

  re_levs <- re_levs[!is.na(re_levs) & re_levs != "Residual"]
  re_subscripts <- letters[10:(10 + (n_levels - 1))]

  rhs$re_subscripts <- as.character(factor(rhs$group,
                                           levels = re_levs,
                                           labels = re_subscripts))
  rhs$re_subscripts <- paste0(rhs$re_subscripts, "[i]")
  rhs
}

create_intercept_merMod <- function(rhs) {
  rhs <- assign_re_subscripts(rhs)
  rhs <- rhs[!is.na(rhs$re_subscripts) &
               grepl("sd__(Intercept)", rhs$term, fixed = TRUE), ]

  paste0("\\alpha_{", paste(rhs$re_subscripts, collapse = ","), "}")
}

create_betas_merMod <- function(rhs, ital_vars) {
  rhs <- assign_re_subscripts(rhs)
  fixed <- rhs[rhs$effect == "fixed" & rhs$term != "(Intercept)", ]
  if(nrow(fixed) == 0) {
    return()
  }
  random <- rhs[rhs$effect == "ran_pars" &
                  rhs$group != "Residual" &
                  !grepl("cor__", rhs$term, fixed = TRUE) &
                  !grepl("(Intercept)", rhs$term, fixed = TRUE), ]
  if(nrow(random) > 0) {
    random_splt <- split(random, random$term)
    random_splt <- lapply(random_splt, function(x) paste0(x$re_subscripts, collapse = ","))

    to_merge <- data.frame(term = gsub("sd__", "", names(random_splt)),
                           random_indicator = unlist(random_splt))

    betas <- merge(fixed, to_merge, by = "term", all = TRUE)
    betas$random_indicator <- ifelse(is.na(betas$random_indicator), "", betas$random_indicator)
  } else {
    betas <- fixed
    betas$random_indicator <- ""
  }
  betas <- betas[order(betas$original_order), ]
  betas$betas <- paste0("\\beta_{", seq_len(nrow(betas)), betas$random_indicator, "}", "(", create_term(betas, ital_vars), ")")

  paste(betas$betas, collapse = " + ")
}

create_distributed_as_merMod <- function(model, ital_vars, sigma = "\\sigma^2") {
  rhs <- extract_rhs(model)
  lhs <- extract_lhs(model, ital_vars)
  int <- create_intercept_merMod(rhs)
  betas <- create_betas_merMod(rhs, ital_vars)
  if(!is.null(betas)) {
    normal_dist <- wrap_normal_dist(paste(int, "+", betas), sigma)
  } else {
    normal_dist <- wrap_normal_dist(int, sigma)
  }

  paste(lhs, "\\sim", normal_dist)
}

assign_ranef_greek <- function(v, index = NULL) {
  slopes <- v[!grepl("(Intercept)", v)]
  if(!is.null(index)) {
    int <- paste0("\\alpha_{", index, "}")
    if(length(slopes) > 0) {
      betas <- paste0("\\beta_{", seq_along(slopes), index, "}")
    } else {
      return(int)
    }
  } else {
    int <- "\\alpha"
    if(length(slopes) > 0) {
      betas <- paste0("\\beta_{", seq_along(slopes), "}")
    } else {
      return(int)
    }
  }

  c(int, betas)
}

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

extract_random_vars <- function(rhs) {
  vc <- rhs[rhs$group != "Residual" & rhs$effect == "ran_pars", ]
  splt <- split(vc, vc$group)

  lapply(splt, function(x) {
    vars <- x[!grepl("cor__", x$term), ]
    gsub(".+__(.+)", "\\1", vars$term)
  })
}

extract_random_covars <- function(rhs) {
  vc <- rhs[rhs$group != "Residual" & rhs$effect == "ran_pars", ]
  splt <- split(vc, vc$group)

  lapply(splt, function(x) {
    vars <- x[grepl("cor__", x$term), ]
    gsub(".+__(.+)", "\\1", vars$term)
  })
}

# This is just the left-hand side. The variables that randomly vary.
create_lhs_merMod <- function(rhs) {
  random_vars <- extract_random_vars(rhs)
  lev_index <- letters[10:(10 + (length(random_vars) - 1))]

  random_vars <- Map(assign_ranef_greek,
                     v = random_vars,
                     index = lev_index)
  lapply(random_vars, create_onecol_array)
}

# Mean structure
create_mean_structure_merMod <- function(rhs) {
  random_vars <- extract_random_vars(rhs)
  random_vars <- lapply(random_vars, assign_ranef_greek)
  means <- lapply(random_vars, function(x) paste0("\\mu_{", x, "}"))
  lapply(means, create_onecol_array)
}

# just the variances
create_vars_merMod <- function(rhs) {
  random_vars <- extract_random_vars(rhs)
  random_vars <- lapply(random_vars, assign_ranef_greek)
  lapply(random_vars, function(x) paste0("\\sigma^2_{", x, "}"))
}

sub_vectorized <- function(text_vec, pattern_vec, replacement_vec) {
  stopifnot(length(pattern_vec) == length(replacement_vec))

  for(i in seq_along(pattern_vec)) {
    text_vec <- gsub(pattern_vec[i], replacement_vec[i], text_vec,
                     fixed = TRUE)
  }
  text_vec
}

create_covars_merMod <- function(rhs) {
  random_vars <- extract_random_vars(rhs)
  random_vars_greek <- lapply(random_vars, function(x) setNames(x, assign_ranef_greek(x)))
  random_vars_greek <- lapply(random_vars_greek, function(x) setNames(x, paste0("\\sigma_{", names(x), "}")))

  random_covars <- extract_random_covars(rhs)
  if(all(unlist(lapply(random_covars, function(x) length(x) == 0)))) {
    return()
  }
  # First replace non-interaction terms
  random_covars_greek1 <- Map(function(x, y) {
    sub_vectorized(x, y, names(y))
  },
  x = lapply(random_covars, function(x) x[!grepl(":", x)]),
  y = lapply(random_vars_greek, function(x) x[!grepl(":", x)])
  )

  # Then replace interaction terms
  random_covars_greek2 <- Map(function(x, y) {
    sub_vectorized(x, y, names(y))
  },
  x = lapply(random_covars, function(x) x[grepl(":", x)]),
  y = lapply(random_vars_greek, function(x) x[grepl(":", x)])
  )

  # Replace non-interaction terms in the interaction vector
  random_covars_greek2 <- Map(function(x, y) {
    sub_vectorized(x, y, names(y))
  },
  x = random_covars_greek2,
  y = lapply(random_vars_greek, function(x) x[!grepl(":", x)])
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

flip_order <- function(text) {
  splt <- strsplit(text, " ")[[1]]
  paste(splt[c(1, 3, 2)], collapse = " ")
}

create_matrix <- function(rhs) {
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

create_vcov_structure_merMod <- function(model) {
  rhs <- extract_rhs(model)
  lhs <- create_lhs_merMod(rhs)

  order <- rhs[rhs$group != "Residual", ]
  order <- sort(tapply(order$original_order, order$group, min))

  means <- create_mean_structure_merMod(rhs)[names(order)]
  error_structure <- create_matrix(rhs)[names(order)]

  norm <- wrap_normal_dist(means, error_structure)
  levs <- names(means)
  indexes <- letters[10:(10 + (length(levs) - 1))]
  norm <- paste(norm, ", \\text{ for ", levs, "}", indexes, " = 1, \\dots , ", toupper(indexes))

  norm <- paste0(lhs, "\\sim ", norm)

  paste0(norm, collapse = " \\\\ ")

}


