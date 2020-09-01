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

