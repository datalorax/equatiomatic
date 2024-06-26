create_eq <- function(model, lhs, ...) {
  UseMethod("create_eq", model)
}

#' Create the full equation
#'
#' @keywords internal
#'
#' @param lhs A character string of the left-hand side variable extracted with
#'   \code{extract_lhs}
#' @param rhs A data frame of right-hand side variables extracted with
#'   \code{extract_rhs}.
#'
#' @inheritParams extract_eq
#' @noRd

create_eq.default <- function(model, lhs, rhs, ital_vars, use_coefs, coef_digits,
                              fix_signs, intercept, greek, 
                              greek_colors, subscript_colors, 
                              var_colors, var_subscript_colors,
                              raw_tex, index_factors, swap_var_names, 
                              swap_subscript_names, ...) {

   check_dots(...)
  rhs$final_terms <- create_term(rhs, ital_vars, 
                                 swap_var_names, swap_subscript_names, 
                                 var_colors, var_subscript_colors)

  if (use_coefs) {
    rhs$final_terms <- add_coefs(rhs, rhs$final_terms, coef_digits)
  } else if (index_factors) {
    rhs$final_terms <- ifelse(
      grepl("\\\\times", rhs$final_terms),
      paste0("\\left(", rhs$final_terms, "\\right)"),
      rhs$final_terms
    )
    rhs$final_terms <- ifelse(
      rhs$final_terms == "",
      "\\alpha",
      rhs$final_terms
    )
  } else {
    rhs$final_terms <- add_greek(rhs, rhs$final_terms, greek, intercept, 
                                 greek_colors, subscript_colors, 
                                 raw_tex)
  }

  # Add error row or not in lm
  if (!use_coefs) {
    error_row <- rhs[nrow(rhs) + 1, ]
    error_row$term <- "error"
    error_row$final_terms <- "\\epsilon"
    error_row$final_terms <- colorize(
      greek_colors[length(greek_colors)], 
      error_row$final_terms
    )
    rhs <- rbind(rhs, error_row)
  }

  list(lhs = list(lhs), rhs = list(rhs$final_terms))
}

#' @noRd
#' @inheritParams extract_eq
create_eq.glm <- function(model, lhs, rhs, ital_vars, use_coefs, coef_digits,
                          fix_signs, intercept, greek, 
                          greek_colors, subscript_colors, 
                          var_colors, var_subscript_colors,
                          raw_tex, index_factors,
                          swap_var_names, swap_subscript_names, ...) {
  check_dots(...)
  rhs$final_terms <- create_term(rhs, ital_vars, swap_var_names, 
                                 swap_subscript_names,
                                 var_colors, var_subscript_colors)

  if (use_coefs) {
    rhs$final_terms <- add_coefs(rhs, rhs$final_terms, coef_digits)
  } else if (index_factors) {
    rhs$final_terms <- ifelse(
      grepl("\\\\times", rhs$final_terms),
      paste0("\\left(", rhs$final_terms, "\\right)"),
      rhs$final_terms
    )
    rhs$final_terms <- ifelse(
      rhs$final_terms == "",
      "\\alpha",
      rhs$final_terms
    )
  } else {
    rhs$final_terms <- add_greek(rhs, rhs$final_terms, greek, intercept, 
                                 greek_colors, subscript_colors, raw_tex)
  }
  if (!is.null(model$offset)) {
    rhs <- rbind(rhs, c(
      rep(NA, (dim(rhs)[2] - 1)),
      add_tex_ital(tail(names(attr(model$terms, "dataClasses")), 1), ital_vars)
    ))
  }

  list(lhs = list(lhs), rhs = list(rhs$final_terms))
}

#' @noRd
create_eq.polr <- function(model, lhs, rhs, ital_vars, use_coefs, coef_digits,
                           fix_signs, intercept, greek, 
                           greek_colors, subscript_colors, 
                           var_colors, var_subscript_colors,
                           raw_tex, index_factors,
                           swap_var_names, swap_subscript_names, ...) {

  check_dots(...)
  rhs$final_terms <- create_term(rhs, ital_vars, swap_var_names, 
                                 swap_subscript_names,
                                 var_colors, var_subscript_colors)

  if (use_coefs) {
    rhs$final_terms <- add_coefs(rhs, rhs$final_terms, coef_digits)
  } else if (index_factors) {
    rhs$final_terms <- ifelse(
      grepl("\\\\times", rhs$final_terms),
      paste0("\\left(", rhs$final_terms, "\\right)"),
      rhs$final_terms
    )
    rhs$final_terms <- ifelse(
      rhs$final_terms == "",
      "\\alpha",
      rhs$final_terms
    )
  } else {
    rhs$final_terms <- add_greek(rhs, rhs$final_terms, greek, intercept, 
                                 greek_colors, subscript_colors, raw_tex)
  }

  splt <- split(rhs, rhs$coef.type)
  rhs_final <- lapply(splt$scale$final_terms, function(x) {
    c(x, splt$coefficient$final_terms)
  })
  attributes(lhs) <- NULL
  list(lhs = lhs, rhs = rhs_final)
}

#' @noRd
create_eq.clm <- function(model, lhs, rhs, ital_vars, use_coefs, coef_digits,
                          fix_signs, intercept, greek, 
                          greek_colors, subscript_colors, 
                          var_colors, var_subscript_colors,
                          raw_tex, index_factors,
                          swap_var_names, swap_subscript_names, ...) {
  check_dots(...)
  rhs$final_terms <- create_term(rhs, ital_vars, swap_var_names, 
                                 swap_subscript_names,
                                 var_colors, var_subscript_colors)

  if (use_coefs) {
    rhs$final_terms <- add_coefs(rhs, rhs$final_terms, coef_digits)
  } else if (index_factors) {
    rhs$final_terms <- ifelse(
      grepl("\\\\times", rhs$final_terms),
      paste0("\\left(", rhs$final_terms, "\\right)"),
      rhs$final_terms
    )
    rhs$final_terms <- ifelse(
      rhs$final_terms == "",
      "\\alpha",
      rhs$final_terms
    )
  } else {
    rhs$final_terms <- add_greek(rhs, rhs$final_terms, greek, intercept, 
                                 greek_colors, subscript_colors, raw_tex)
  }

  splt <- split(rhs, rhs$coef.type)
  rhs_final <- lapply(splt$intercept$final_terms, function(x) {
    c(x, splt$location$final_terms)
  })

  attributes(lhs) <- NULL
  list(lhs = lhs, rhs = rhs_final)
}

#' Create equations from forecast::Arima object
#'
#' @keywords internal
#'
#' @param lhs A data frame of right-hand side variables extracted with
#'   \code{extract_lhs}
#' @param rhs A data frame of right-hand side variables extracted with
#'   \code{extract_rhs}.
#' @param yt A data frame of regression variables extracted with
#'   \code{helper_arima_extract_lm}.
#'
#' @return A dataframe
#' @noRd
create_eq.forecast_ARIMA <- function(model, lhs, rhs, yt, ital_vars, use_coefs, 
                                     coef_digits, raw_tex, swap_var_names,
                                     swap_subscript_names, ...) {

  # Determine if we are working on Regression w/ Arima Errors
  regression <- helper_arima_is_regression(model)

  # Convert sides into LATEX-like terms
  lhs$final_terms <- create_term(lhs, ital_vars, swap_var_names, 
                                 swap_subscript_names)
  rhs$final_terms <- create_term(rhs, ital_vars, swap_var_names, 
                                 swap_subscript_names)

  # Combine coefs or greek letters with the terms
  if (use_coefs) {
    lhs$final_terms <- add_coefs(lhs, lhs$final_terms, coef_digits, side_sign = -1)
    rhs$final_terms <- add_coefs(rhs, rhs$final_terms, coef_digits, side_sign = 1)
  } else {
    lhs$final_terms <- add_greek(lhs, lhs$final_terms, regression, raw_tex, side_sign = -1)
    rhs$final_terms <- add_greek(rhs, rhs$final_terms, regression, raw_tex, side_sign = 1)
  }

  # Convert the final terms into proper Backshift notation for L/RHS
  ## Setup the parsing functions
  parsing_functions <- list(
    "ar" = function(x) paste("(1", paste0(x, collapse = " "), ")\\"),
    "diffs" = function(x) paste(x, collapse = "\\ "),
    "error" = function(x) x
  )

  parsing_functions["sar"] <- parsing_functions["ar"]
  parsing_functions["ma"] <- parsing_functions["ar"]
  parsing_functions["sma"] <- parsing_functions["ar"]


  ## Parse the LHS
  lhs_intercept <- lhs$final_terms[lhs$term %in% c("intercept", "drift")]

  if (length(lhs_intercept) > 0) {
    # An intercept or drift term exists for the ARIMA section.
    lhs_intercept <- paste0("(y_{t} ", lhs_intercept, ")")
  } else {
    lhs_intercept <- "y_{t}"
  }

  lhs_parse <- list(
    "ar" = lhs$final_terms[grepl("^ar", lhs$term)],
    "sar" = lhs$final_terms[grepl("^sar", lhs$term)],
    "diffs" = lhs$final_terms[lhs$term %in% c("zz_differencing", "zz_seas_Differencing")],
    "error" = if (regression) "\\eta_{t}" else lhs_intercept
  )

  lhs_parse <- lhs_parse[lengths(lhs_parse) > 0L]

  lhs_final <- Map(function(x, y) parsing_functions[x][[1]](y), names(lhs_parse), lhs_parse)

  ## Parse the RHS
  rhs_parse <- list(
    "ma" = rhs$final_terms[grepl("^ma", rhs$term)],
    "sma" = rhs$final_terms[grepl("^sma", rhs$term)],
    "diffs" = rhs$final_terms[rhs$term == "zz_seas_Differencing"],
    "error" = "\\varepsilon_{t}"
  )

  rhs_parse <- rhs_parse[lengths(rhs_parse) > 0L]

  rhs_final <- Map(function(x, y) parsing_functions[x][[1]](y), names(rhs_parse), rhs_parse)

  ## Output the ARIMA equation segments.
  arima_eq <- list(
    lhs = list(unlist(lhs_final)),
    rhs = list(unlist(rhs_final))
  )

  # If this is a linear model, also parse yt
  # Note that this is the same set of operations as earlier, but only with yt
  if (regression) {
    # Convert sides into LATEX-like terms
    yt$final_terms <- create_term(yt, ital_vars, swap_var_names, 
                                  swap_subscript_names)

    # Combine coefs or greek letters with the terms
    if (use_coefs) {
      yt$final_terms <- add_coefs(yt, yt$final_terms, coef_digits, side_sign = 1)
    } else {
      yt$final_terms <- add_greek(yt, yt$final_terms, regression, raw_tex, side_sign = 1)
    }

    # Output the LM equation segments
    lm_eq <- list(
      lhs = list("y_{t}"),
      rhs = list(c(yt$final_terms, "+\\eta_{t}"))
    )

    # Prep for final output
    eq_list <- list(
      lm_eq = lm_eq,
      arima_eq = arima_eq
    )
  } else {
    # No regression model
    # Prep for final output
    eq_list <- list(arima_eq = arima_eq)
  }

  # Explicit return
  return(eq_list)
}

create_term <- function(side, ...) {
  UseMethod("create_term", side)
}

#' @noRd
create_term.default <- function(side, ital_vars, swap_var_names, 
                                swap_subscript_names, var_colors,
                                var_subscript_colors, ...) {
  check_dots(...)
  side$primary <- lapply(side$primary, function(x) {
    names(x) <- x
    x
  })
  
  subscript_nms <- Map(function(.x, .y) {
    names(.x) <- .y
    .x
    }, 
    .x = side$subscripts,
    .y = side$primary
  )
  
  if (!is.null(swap_var_names)) {
    side$primary <- swap_names(swap_var_names, side$primary)
  }
  if (!is.null(swap_subscript_names)) {
    side$subscripts <- swap_names(swap_subscript_names, side$subscripts)
    side$subscripts <- Map(function(.x, .y) {
      names(.x) <- names(.y)
      .x
    }, 
    .x = side$subscripts,
    .y = subscript_nms
    )
  }
  
  prim_escaped <- lapply(side$primary, function(x) {
    vapply(x, escape_tex, FUN.VALUE = character(1))
  })
  prim_escaped <- add_math(prim_escaped, side$subscripts)
  prim <- lapply(prim_escaped, add_tex_ital_v, ital_vars)
  
  if (!is.null(var_colors)) {
    prim <- colorize_terms(var_colors, side$primary, prim)
  }
  
  drop_subscripts <- vapply(side$primary, 
                            function(x) any(grepl("poly|<|>", x)), 
                            FUN.VALUE = logical(1))
  
  subs <- ifelse(drop_subscripts, "", side$subscripts)
  
  subs_escaped <- lapply(subs, function(x) {
    vapply(x, escape_tex, FUN.VALUE = character(1))
  })
  subs <- lapply(subs_escaped, add_tex_ital_v, ital_vars)
  subs <- lapply(subs, add_tex_subscripts_v)
  
  if (!is.null(var_subscript_colors)) {
    subs <- Map(function(.x, .y) {
      names(.x) <- names(.y)
      .x
    }, 
    .x = subs,
    .y = subscript_nms
    )
    
    subs <- colorize_terms(var_subscript_colors, side$primary, subs)
  }

  final <- Map(paste0, prim, subs)

  vapply(final, add_tex_mult, FUN.VALUE = character(1))
}

# swap out log, exp
add_math <- function(primary, subscripts) {
  Map(check_math, primary, subscripts)
}

check_math <- function(primary, subscripts) {
  checks <- c("log", "exp", "poly\\((.+),.+", "I\\((.+)\\)")
  replacements <- c("\\\\log", "\\\\exp", paste0("\\1^", subscripts), "\\1")
  for(i in seq_along(checks)) {
    primary <- gsub(checks[i], replacements[i], primary)  
  }
  gsub("\\^1$", "", primary)
}

#' Create a full term w/subscripts
#'
#' @keywords internal
#'
#' @param side A data frame of right-hand side variables extracted with
#'   \code{extract_rhs} or \code{extract_rhs} or \code{helper_arima_extract_lm}.
#'
#' @inheritParams extract_eq
#' @noRd
create_term.forecast_ARIMA <- function(side, ital_vars, swap_var_names,
                                       swap_subscript_names, ...) {
  check_dots(...)
  if (!is.null(swap_var_names)) {
    side$primary <- swap_names(swap_var_names, side$primary)
  }
  if (!is.null(swap_subscript_names)) {
    side$subscripts <- swap_names(swap_subscript_names, side$subscripts)
  }
  # Get and format the primaries
  # Do not escape seasonal differecing primary
  prim_escaped <- lapply(side$primary, function(x) {
    vapply(x, escape_tex, FUN.VALUE = character(1))
  })
  term_check <- side$term %in% c("zz_differencing", "zz_seas_Differencing")
  prim_escaped[term_check] <- side[term_check, "primary"]

  prim <- lapply(prim_escaped, add_tex_ital_v, ital_vars)

  if (!ital_vars) {
    # We don"t want (1-B) inside \\operatorname
    prim[term_check] <- gsub("B", "\\\\operatorname{B}", side$primary[term_check])
  }

  # Get and format the subscripts
  subs_escaped <- lapply(side$subscripts, function(x) {
    vapply(x, escape_tex, FUN.VALUE = character(1))
  })

  subs <- lapply(subs_escaped, add_tex_ital_v, ital_vars)
  subs <- lapply(subs, add_tex_subscripts_v)

  # Get and format the superscripts
  supers_escaped <- lapply(side$superscript, function(x) {
    vapply(x, escape_tex, FUN.VALUE = character(1))
  })

  supers <- lapply(supers_escaped, add_tex_ital_v, ital_vars)
  supers <- lapply(supers, add_tex_superscripts_v)

  # Combine operators
  final <- Map(paste0, prim, subs, supers)

  # Add any multiplication for interaction terms
  final <- vapply(final, add_tex_mult, FUN.VALUE = character(1))

  # Explicit return
  return(final)
}

#' Swap out variable names for more human readable forms
#' @param name_vector A vector of the form c("old_var_name" = "new name"). For
#' example: c("bill_length_mm" = "Bill Length (MM)")
#' @param primary The primary column from \code{rhs}
#' @noRd
swap_names <- function(name_vector, primary) {
  missing <- setdiff(unique(unlist(primary)), names(name_vector))
  names(missing) <- missing
  full_name_vector <- c(name_vector, missing)
  
  lapply(primary, function(x) {
    full_name_vector[match(x, names(full_name_vector))]
  })
}

#' Escape TeX
#'
#' Escape special TeX characters.
#'
#' Ten characters have special meaning in TeX \code{& \% $ # _ { } ~ ^ \\}.
#' This function either escapes them with \\, or in the case of the last three,
#' replaces them with special TeX macros.
#'
#' @keywords internal
#'
#' @param term A character string to escape
#'
#' @return A character string
#' @noRd

escape_tex <- function(term) {
  unescaped <- c(" ", "&", "%", "$", "#", "_", "{", "}", "~", "^", "\\")
  
  hat <- ifelse(is_html_output(), "\\texttt{^}", "\\texttt{\\^{}}")
  
  escaped <- c(
    "\\ ", "\\&", "\\%", "\\$", "\\#", "\\_", "\\{", "\\}",
    "\\char`\\~", hat, "\\backslash "
  )

  # Split term into a vector of single characters
  characters <- strsplit(term, "")[[1]]

  # Go through term and replace all unescaped characters with their escaped versions
  replaced <- vapply(characters,
    function(x) {
      ifelse(x %in% unescaped,
        escaped[which(x == unescaped)],
        x
      )
    },
    FUN.VALUE = character(1)
  )

  # Return the reassembled term
  paste0(replaced, collapse = "")
}


#' Wrap text in \code{\\operatorname{}}
#'
#' Add tex code to make string not italicized within an equation
#'
#' @keywords internal
#'
#' @param term A character to wrap in \code{\\operatorname{}}
#' @param ital_vars Passed from \code{extract_eq}
#'
#' @return A character string
#' @noRd

add_tex_ital <- function(term, ital_vars) {
  if (any(nchar(term) == 0, ital_vars)) {
    return(term)
  }
  paste0("\\operatorname{", term, "}")
}


#' Wrap text in \code{\\operatorname{}} (vectorized)
#'
#' Add tex code to make string not italicized within an equation for a vector
#' of strings
#'
#' @keywords internal
#'
#' @return A vector of characters
#' @noRd

add_tex_ital_v <- function(term_v, ital_vars) {
  vapply(term_v, add_tex_ital, ital_vars, FUN.VALUE = character(1))
}


#' Wrap text in \code{_{}}
#'
#' Add tex code to make subscripts for a single string
#'
#' @keywords internal
#'
#' @param term A character string to TeXify
#'
#' @return A character string
#' @noRd

add_tex_subscripts <- function(term) {
  if (any(nchar(term) == 0)) {
    return(term)
  }
  paste0("_{", term, "}")
}


#' Wrap text in \code{_{}}
#'
#' Add tex code to make subscripts for a vector of strings
#'
#' @keywords internal
#'
#' @return A vector of characters
#' @noRd

add_tex_subscripts_v <- function(term_v) {
  vapply(term_v, add_tex_subscripts, FUN.VALUE = character(1))
}

#' Wrap text in \code{_{}}
#'
#' Add tex code to make subscripts for a single string
#'
#' @keywords internal
#'
#' @param term A character string to TeXify
#'
#' @return A character string
#' @noRd
add_tex_superscripts <- function(term) {
  if (any(nchar(term) == 0)) {
    return(term)
  }
  paste0("^{", term, "}")
}


#' Wrap text in \code{_{}}
#'
#' Add tex code to make subscripts for a vector of strings
#'
#' @keywords internal
#'
#' @return A vector of characters
#' @noRd
add_tex_superscripts_v <- function(term_v) {
  vapply(term_v, add_tex_superscripts, FUN.VALUE = character(1))
}

#' Add multiplication symbol for interaction terms
#'
#' @keywords internal
#' @noRd

add_tex_mult <- function(term) {
  paste(term, collapse = " \\times ")
}

#' Add a hat sign to the response variable in lm
#'
#' @keywords internal
#' @noRd

add_hat <- function(term) {
  paste0("\\widehat{", term, "}")
}



add_coefs <- function(rhs, ...) {
  UseMethod("add_coefs", rhs)
}

#' Add coefficient values to the equation
#'
#' @keywords internal
#' @noRd

add_coefs.default <- function(rhs, term, coef_digits, ...) {
  check_dots(...)
  ests <- round(rhs$estimate, coef_digits)
  ifelse(
    rhs$term == "(Intercept)",
    paste0(ests, term),
    paste0(ests, "(", term, ")")
  )
}

#' @keywords internal
#' @noRd

add_coefs.polr <- function(rhs, term, coef_digits, ...) {
  check_dots(...)
  ests <- round(rhs$estimate, coef_digits)
  ifelse(
    rhs$coef.type == "scale",
    paste0(ests, term),
    paste0(ests, "(", term, ")")
  )
}

#' @keywords internal
#' @noRd

add_coefs.clm <- function(rhs, term, coef_digits, ...) {
  check_dots(...)
  ests <- round(rhs$estimate, coef_digits)
  ifelse(
    rhs$coef.type == "intercept",
    paste0(ests, term),
    paste0(ests, "(", term, ")")
  )
}

#' Add coefficient values for forecast::Arima
#'
#' @keywords internal
#' @noRd
add_coefs.forecast_ARIMA <- function(rhs, term, coef_digits, side_sign = 1, ...) {
  check_dots(...)
  # Round the estimates and turn to a character vector
  ests <- round(rhs$estimate, coef_digits)

  # Use signif on anything where the round returns a zero
  ests[ests == 0 & !is.na(ests)] <- signif(rhs$estimate[ests == 0 & !is.na(ests)], 1)

  # Deal with signs
  ## Flip sign if needed
  ests <- ests * side_sign

  ## Setup for positive signs. Negative signs come automatically.
  signs <- ifelse(ests > 0, "+", "")

  # Deal with NAs
  signs[is.na(ests)] <- ""
  ests[is.na(ests)] <- ""

  # Combine final terms and the coeficients
  final_terms <- paste0(signs, ests, term)

  # Explicit return
  return(final_terms)
}

add_greek <- function(rhs, ...) {
  UseMethod("add_greek", rhs)
}

#' Adds greek symbols to the equation
#'
#' @keywords internal
#' @noRd

add_greek.default <- function(rhs, terms, greek = "beta", intercept = "alpha",
                              greek_colors, subscript_colors,
                              raw_tex = FALSE, ...) {
  check_dots(...)
  int <- switch(intercept,
    "alpha" = "\\alpha",
    "beta" = "\\beta_{0}"
  )
  if (raw_tex & !(intercept %in% c("alpha", "beta"))) {
    int <- intercept
  }
  
  indices <- if ("(Intercept)" %in% rhs$term) {
    seq_len(nrow(rhs)) - 1
  } else {
    seq_len(nrow(rhs))
  } 
  
  ifelse(rhs$term == "(Intercept)",
    colorize(greek_colors[1], int),
    anno_greek(
      greek, 
      indices, 
      terms, 
      greek_colors, 
      subscript_colors, 
      raw_tex
    )
  )
}

#' @keywords internal
#' @noRd

add_greek.polr <- function(rhs, terms, greek, intercept, greek_colors, 
                           subscript_colors, raw_tex, ...) {
  rhs$idx <- unlist(lapply(split(rhs, rhs$coef.type), function(x) {
    seq_along(x$coef.type)
  }))

  ifelse(
    rhs$coef.type == "scale",
    anno_greek(
      "alpha", 
      rhs$idx, 
      greek_colors = greek_colors[1], 
      subscript_colors = subscript_colors[1]
    ),
    anno_greek(
      "beta", 
      rhs$idx, 
      terms,
      greek_colors = greek_colors[-1],
      subscript_colors = subscript_colors[-1]
    )
  )
}

#' @keywords internal
#' @noRd

add_greek.clm <- function(rhs, terms, greek, intercept, greek_colors, 
                          subscript_colors, raw_tex, ...) {
  rhs$idx <- unlist(lapply(split(rhs, rhs$coef.type), function(x) {
    seq_along(x$coef.type)
  }))

  ifelse(
    rhs$coef.type == "intercept",
    anno_greek(
      "alpha", 
      rhs$idx, 
      greek_colors = greek_colors[1], 
      subscript_colors = subscript_colors[1]
    ),
    anno_greek(
      "beta", 
      rhs$idx, 
      terms,
      greek_colors = greek_colors[-1],
      subscript_colors = subscript_colors[-1]
    )
  )
}

#' Add greek placeholders for forecast::Arima
#'
#' @keywords internal
#' @noRd
add_greek.forecast_ARIMA <- function(rhs, terms, regression, raw_tex = FALSE, side_sign = 1, ...) {
  # These are the greek letters we need to use in REGEX
  # Others will be assigned manually
  greek_letters <- c(
    "^ar" = "phi",
    "^sar" = "Phi",
    "^ma" = "theta",
    "^sma" = "Theta",
    "^intercept$" = "mu",
    "^drift$" = "delta"
  )

  # We are going to use lapply to walk and change things for us.
  # Note the <<-. This affects something outside the function.
  # This is just a fancy for loop.
  greek <- rep("", nrow(rhs))
  invisible(
    lapply(names(greek_letters), function(x) {
      greek[grepl(x, rhs$term)] <<- greek_letters[x]
    })
  )


  # To make life easier, we are including the greek parsing for
  # the linear component here too.
  if (sum(grepl("^s?ar|^s?ma", rhs$term)) == 0) {
    # Then we are dealing with the linear component and not the ARIMA component

    # Beta will serve as the main letter for the linear component
    # Anything in greek that is blank, wasn"t accounted for with known paramters.
    greek[greek == "" & rhs$term != "y0"] <- "beta"

    # Generate the subs for the greek letters
    ## Initialize the vector
    subs <- rep("", nrow(rhs))

    ## Give numbers to non-constants
    int_drift_y0 <- !(rhs$term %in% c("intercept", "drift", "y0"))
    subs[int_drift_y0] <- as.character(1:sum(int_drift_y0))
  } else {
    # Deal with ARIMA component

    # Format the greek letters to vibe with the final_terms
    # This is done, in part, with anno_greek for other functions.
    subs <- rep("", nrow(rhs))
    subs[grepl("^s?ar|^s?ma", rhs$term)] <- gsub("^s?ar|^s?ma", "", rhs$term[grepl("^s?ar|^s?ma", rhs$term)])
  }

  # Add subscripts to greek
  greek[subs != ""] <- paste0(greek[subs != ""], "_{", subs[subs != ""], "}")

  # Finalize greek based on raw_tex
  if (!raw_tex) {
    greek[greek != ""] <- paste0("\\", greek[greek != ""])
  }

  # Deal with signs on greek letters
  signs <- rep("", length(greek))
  signs[!(rhs$term %in% c("zz_differencing", "zz_seas_Differencing"))] <- if (side_sign > 0) "+" else "-"

  # Combine the final terms with the greek letters
  final_terms <- paste0(signs, greek, terms)

  # Explicit return
  return(final_terms)
}

#' Intermediary function to wrap text in `\\beta_{}`
#'
#' @keywords internal
#' @noRd
anno_greek <- function(greek, nums, terms = NULL, 
                       greek_colors = NULL, subscript_colors = NULL, 
                       raw_tex = FALSE) {
  
  if (raw_tex) {
    out <- paste0(greek, "_{", nums, "}")
  } else {
    coefs <- colorize(greek_colors, paste0("\\", greek))
    subscripts <- colorize(subscript_colors, nums)
    out <- paste0(coefs, "_{", subscripts, "}")
  }
    
  if (!is.null(terms)) {
    out <- paste0(out, "(", terms, ")")
  }
  out
}


#' Deduplicate operators
#'
#' Convert "+ -" to "-"
#'
#' @keywords internal
#'
#' @param eq String containing a LaTeX equation
#' @noRd

fix_coef_signs <- function(eq) {
  # Side-by-side + -
  eq_clean <- gsub("\\+ -", "- ", eq)

  # + - that spans lines
  eq_clean <- gsub(
    "\\+ \\\\\\\\\\n&\\\\quad -",
    "- \\\\\\\\\n&\\\\quad ",
    eq_clean
  )

  eq_clean
}
