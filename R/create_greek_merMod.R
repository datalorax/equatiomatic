get_order <- function(rhs_random) {
  sort(tapply(rhs_random$original_order, rhs_random$group, min))
} 

vary_higher_subscripts <- function(term, rhs_random, lev_omit = NULL) {
  splt_random <- split(rhs_random, rhs_random$group)
  lev_indexes <- letters[seq_along(splt_random) + 9]
  
  order <- get_order(rhs_random)
  splt_random <- splt_random[names(order)]
  
  if(!is.null(lev_omit)) {
    lev_indexes <- lev_indexes[-seq_len(grep(lev_omit, names(splt_random)))]
    splt_random <- splt_random[-seq_len(grep(lev_omit, names(splt_random)))]
  }
  
  out <- rep(NA_character_, length(lev_indexes))
  for(i in seq_along(splt_random)) {
    if(any(grepl(term, splt_random[[i]]$term))) {
      out[i] <- paste0(lev_indexes[i], "[i]")
    }
  }
  paste0(out[!is.na(out)], collapse = ",")
}

# create a variable that denotes which level the term should be added to
pred_level_split <- function(rhs_fixed, rhs_random) {

  order <- get_order(rhs_random)
  
  vapply(rhs_fixed$pred_level, function(x) {
    if (length(x) == 0) out <- "l1"
    if (length(x) == 1) out <- x
    if (length(x) > 1) {
      out <- order[x]
      out <- names(out[which.max(out)])
    }
    out
  }, FUN.VALUE = character(1))
}
  
assign_l1_greek <- function(rhs_fixed, rhs_random) {
  l1 <- ifelse(rhs_fixed$term == "(Intercept)" & rhs_fixed$l1,
         "\\alpha_{",
         ifelse(rhs_fixed$l1,
                paste0("\\beta_{", seq_along(fixed)),
                NA_character_)
  )
  terms <- rhs_fixed$term[!is.na(l1)]
  
  ss <- vapply(terms, function(x) vary_higher_subscripts(x, rhs_random),
               FUN.VALUE = character(1))
  l1[!is.na(l1)] <- paste0(l1[!is.na(l1)], ss, "}")
  l1  
}

pull_term_subscript <- function(greek_coef, n = 1) {
  regex <- paste0("(.+\\{.{", n, "}).+(\\})")
  gsub(regex, "\\1\\2", greek_coef)
}

assign_higher_levels <- function(lev_data, lev_data_name, splt, rhs_random) {
  if(is.null(lev_data)) {
    return()
  }
  split_terms <- split(lev_data, lev_data$crosslevel)
  
  # create intercepts
  int_preds <- split_terms$`FALSE`
  ss <- lapply(int_preds$term, function(x) vary_higher_subscripts(x, rhs_random, lev_data_name))
  int_preds$greek <- paste0("\\gamma_{", seq_len(nrow(int_preds)), ss, "}")
  
  # Cross-level interactions
  slp_preds <- split_terms$`TRUE`
  if(is.null(slp_preds)) {
    return(int_preds)
  }
  # split full rhs 
  detect_cross <- lapply(slp_preds$pred_level, function(x) {
    !grepl(lev_data_name, x)
  })
  
  # cross_data gives the data frames with the names
  # lapply(slp_preds$pred_level, function(x) {
  #   x[!grepl(lev_data_name, x)]
  # })
  
  cross_data <- Map(function(pred_levs, cross_detected) {
    splt[[ pred_levs[cross_detected] ]]
  },
  slp_preds$pred_level,
  detect_cross)
  
  superscripts <- mapply_chr(function(cross_data, slp_preds_splt, cross_detected) {
    ss <- cross_data[cross_data[["term"]] == slp_preds_splt[cross_detected], ]$greek
    ifelse(is.na(ss), "", ss)
  },
  cross_data = cross_data,
  slp_preds_splt = slp_preds$split,
  cross_detected = detect_cross)
  
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

create_fixef_greek_merMod <- function(model) {
  rhs <- extract_rhs(model)
  rhs_fixed <- rhs[rhs$effect == "fixed", ]
  rhs_random <- rhs[rhs$effect == "ran_pars", ]
  rhs_random <- rhs_random[rhs_random$group != "Residual", ]
  
  order <- get_order(rhs_random)
  
  # fixed effects
  rhs_fixed$greek <- assign_l1_greek(rhs_fixed, rhs_random)
  rhs_fixed$predsplit <- pred_level_split(rhs_fixed, rhs_random)
  
  splt <- split(rhs_fixed, rhs_fixed$predsplit)[c("l1", names(order))]
  splt <- splt[!vapply(splt, is.null, FUN.VALUE = logical(1))]
  
  for(i in seq_along(splt)[-1]) {
    splt[[i]] <- assign_higher_levels(splt[[i]], names(splt)[i], splt, rhs_random) 
  }
  
  Reduce(rbind, splt)
}

pull_cross_var <- function(cross_splt_frame, order) {
  interaction_terms <- strsplit(cross_splt_frame$term, ":")
  order <- c("l1" = 0, order)
  orders <- lapply(cross_splt_frame$pred_level, function(x) {
    order[x]
  })
  term <- mapply_chr(function(interaction, order) {
    interaction[which.min(order)]
  }, interaction_terms, orders)
  unique(term)
}

remove_crosslevel_interaction_redundancy <- function(model, lev_data, term) {
  formula_rhs <- labels(terms(formula(model)))
  formula_rhs <- formula_rhs[!grepl(":|\\|", formula_rhs)]
  terms <- vapply(term, function(x) {
    unlist(extract_primary_term(formula_rhs, x))
  }, FUN.VALUE = character(1))
  
  lev_data$primary <- lapply(lev_data$primary, function(x) {
    x[!grepl(paste0(terms, collapse = "|"), x)]
  })
  lev_data$subscripts <- lapply(lev_data$subscripts, function(x) {
    x[!grepl(paste0(terms, collapse = "|"), names(x))]
  })
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

pull_intercept <- function(splt_lev_fixed, splt_lev_random, order) {
  int <- paste0("\\alpha")
  if(is.null(splt_lev_fixed)) {
    return()
  }
  
  check <- check_interact_vary(splt_lev_fixed, splt_lev_random, order)
  
  # Check if lower-level variable in cross-level interactions varies at this level
  splt_lev_fixed$crosslevel <- check & splt_lev_fixed$crosslevel
    
  nocross <- splt_lev_fixed[!splt_lev_fixed$crosslevel, ]
  
  # add alpha superscript
  nocross$greek <- paste0(nocross$greek, paste0("^{", int, "}"))
  
  coef_terms <- paste0(nocross$greek, nocross$terms)
  
  # add intercept term
  coef_terms <- c(paste0("\\gamma_{0}^{", int, "}"), coef_terms)
  data.frame(term = "(Intercept)", 
             greek = paste0(coef_terms, collapse = " + "))
}

pull_slope_superscript <- function(greek) {
  gsub(".+\\^\\{(.+)\\}_.+", "\\1", greek)
}

create_slope_intercept <- function(term) {
  gsub("(.+)(.{1})(\\}$)", "\\10\\3", term)
}

# splt_lev_fixed <- splt_fixed$sid
# splt_lev_random <- splt_rand$sid
pull_slopes <- function(model, splt_lev_fixed, splt_lev_random, ital_vars,
                        order) {
  if(is.null(splt_lev_fixed)) {
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
    remove_crosslevel_interaction_redundancy(model, cross, terms)
  }, cross_splt, terms_predicted)
  
  # recreate terms
  cross_splt <- lapply(cross_splt, function(x) {
    x$terms <- create_term(x, ital_vars)
    
    x$terms <- vapply(x$terms, function(x) {
      if(nchar(x) == 0) {
        return("")
      }
      paste0("(", x, ")")
    }, character(1))
    x
  })
  
  final_slopes <- lapply(cross_splt, function(x) {
    int <- create_slope_intercept(x$greek[1])
    slopes <- paste0(x$greek, x$terms)
    paste0(c(int, paste0(slopes, collapse = " + ")), collapse = " + ")
  })
  
  data.frame(term = unlist(terms_predicted),
             greek = unlist(final_slopes))
}

rbind_named <- function(l) {
  null <- vapply(l, is.null, FUN.VALUE = logical(1))
  l <- Map(function(lst, lst_names) {
    lst$group <- lst_names
    lst
  }, l[!null], names(l)[!null])
  
  Reduce(rbind, l)
}

# fixed_greek_mermod <- create_fixef_greek_merMod(model)
create_means_merMod <- function(rhs, fixed_greek_mermod, model, ital_vars) {
  rhs_random <- rhs[rhs$effect == "ran_pars", ]
  rhs_random <- rhs_random[rhs_random$group != "Residual" &
                             !grepl("^cor__", rhs_random$term), ]
  rhs_random$term <- gsub("sd__", "", rhs_random$term)
  
  order <- get_order(rhs_random)
  
  fixed_greek_mermod$terms <- create_term(fixed_greek_mermod, ital_vars)
  
  fixed_greek_mermod$terms <- vapply(fixed_greek_mermod$terms, function(x) {
    if(nchar(x) == 0) {
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
    pull_intercept(fixed, rand, order)
  }, splt_fixed, splt_rand)
  ints <- rbind_named(ints)
  
  slopes <- Map(function(fixed, rand) {
    pull_slopes(model, fixed, rand, ital_vars, order)
  }, splt_fixed, splt_rand)
  slopes <- rbind_named(slopes)
  
  out <- merge(rhs_random, rbind(ints, slopes), 
               all.x = TRUE, by = c("group", "term"))
  out <- out[order(out$original_order), c("group", "term", "greek", "original_order")]  
  
  random_vary <- fixed_greek_mermod[fixed_greek_mermod$term %in% unique(out$term), ]
  random_vary$greek_vary <- gsub("(.+\\{\\d?).+", "\\1}", random_vary$greek)
  
  out <- merge(out, random_vary[ ,c("term", "greek_vary")], by = "term", all.x = TRUE)
  
  lev_indexes <- setNames(letters[seq_along(order) + 9], names(order))
  lev_indexes <- lev_indexes[match(out$group, names(lev_indexes))]
  out$greek_vary <- paste0(gsub("(.+)\\}", "\\1", out$greek_vary), lev_indexes, "}")
  
  out$greek <- ifelse(is.na(out$greek), 
                      paste0("\\mu_{", out$greek_vary, "}"),
                      out$greek)
  out[order(out$original_order), ]
}

# rhs <- extract_rhs(model)
# fixed_greek_mermod <- create_fixef_greek_merMod(model)
# 
# rhs_random <- rhs[rhs$effect == "ran_pars", ]
# rhs_random_splt <- split(rhs_random, rhs_random$group)
# 
# rhs_random_lev <- rhs_random_splt$sid
# means_merMod <- create_means_merMod(rhs, fixed_greek_mermod, model, ital_vars)
# create_vcov_merMod <- function(rhs_random, means_merMod) {
# 
# }


