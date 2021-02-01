create_eq <- function(lhs, ...) {
  UseMethod("create_eq", lhs)
}

#' Create the full equation
#'
#' @export
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
                              raw_tex) {
  rhs$final_terms <- create_term(rhs, ital_vars)

  if (use_coefs) {
    rhs$final_terms <- add_coefs(rhs, rhs$final_terms, coef_digits)
  } else {
    rhs$final_terms <- add_greek(rhs, rhs$final_terms, greek, intercept, raw_tex)
  }

  # Add error row or not in lm
  if (!use_coefs) {
    error_row <- rhs[nrow(rhs) + 1, ]
    error_row$term <- "error"
    error_row$final_terms <- "\\epsilon"
    rhs <- rbind(rhs, error_row)
  }

  list(lhs = list(lhs), rhs = list(rhs$final_terms))
}

#' @export
#' @noRd
#' @inheritParams extract_eq
create_eq.glm <- function(model, lhs, rhs, ital_vars, use_coefs, coef_digits,
                          fix_signs, intercept, greek, raw_tex) {
  rhs$final_terms <- create_term(rhs, ital_vars)

  if (use_coefs) {
    rhs$final_terms <- add_coefs(rhs, rhs$final_terms, coef_digits)
  } else {
    rhs$final_terms <- add_greek(rhs, rhs$final_terms, greek, intercept, raw_tex)
  }
  if (!is.null(model$offset)) {
    rhs <- rbind(rhs, c(
      rep(NA, (dim(rhs)[2] - 1)),
      add_tex_ital(tail(names(attr(model$terms, "dataClasses")), 1), ital_vars)
    ))
  }

  list(lhs = list(lhs), rhs = list(rhs$final_terms))
}

#' @export
#' @noRd
create_eq.polr <- function(model, lhs, rhs, ital_vars, use_coefs, coef_digits,
                           fix_signs, ...) {
  rhs$final_terms <- create_term(rhs, ital_vars)

  if (use_coefs) {
    rhs$final_terms <- add_coefs(rhs, rhs$final_terms, coef_digits)
  } else {
    rhs$final_terms <- add_greek(rhs, rhs$final_terms)
  }

  splt <- split(rhs, rhs$coef.type)
  rhs_final <- lapply(splt$scale$final_terms, function(x) {
    c(x, splt$coefficient$final_terms)
  })
  attributes(lhs) <- NULL
  list(lhs = lhs, rhs = rhs_final)
}

#' @export
#' @noRd
create_eq.clm <- function(model, lhs, rhs, ital_vars, use_coefs, coef_digits,
                          fix_signs, ...) {
  rhs$final_terms <- create_term(rhs, ital_vars)

  if (use_coefs) {
    rhs$final_terms <- add_coefs(rhs, rhs$final_terms, coef_digits)
  } else {
    rhs$final_terms <- add_greek(rhs, rhs$final_terms)
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
create_eq.forecast_ARIMA <- function(model, lhs, rhs, yt, ital_vars, use_coefs, coef_digits, raw_tex, ...) {

  # Determine if we are working on Regerssion w/ Arima Errors
  regression <- helper_arima_is_regression(model)

  # Convert sides into LATEX-like terms
  lhs$final_terms <- create_term(lhs, ital_vars)
  rhs$final_terms <- create_term(rhs, ital_vars)

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
    yt$final_terms <- create_term(yt, ital_vars)

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

create_term <- function(side, ital_vars) {
  UseMethod("create_term", side)
}

#' @noRd
#' @export
create_term.default <- function(side, ital_vars) {
  prim_escaped <- lapply(side$primary, function(x) {
    vapply(x, escape_tex, FUN.VALUE = character(1))
  })
  prim <- lapply(prim_escaped, add_tex_ital_v, ital_vars)

  subs_escaped <- lapply(side$subscripts, function(x) {
    vapply(x, escape_tex, FUN.VALUE = character(1))
  })
  subs <- lapply(subs_escaped, add_tex_ital_v, ital_vars)
  subs <- lapply(subs, add_tex_subscripts_v)

  final <- Map(paste0, prim, subs)

  vapply(final, add_tex_mult, FUN.VALUE = character(1))
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
#' @export
create_term.forecast_ARIMA <- function(side, ital_vars) {
  # Get and format the primaries
  # Do not escape seasonal differecing primary
  prim_escaped <- lapply(side$primary, function(x) {
    vapply(x, escape_tex, FUN.VALUE = character(1))
  })

  prim_escaped[side$term %in% c("zz_differencing", "zz_seas_Differencing")] <- side[side$term %in% c("zz_differencing", "zz_seas_Differencing"), "primary"]

  prim <- lapply(prim_escaped, add_tex_ital_v, ital_vars)

  if (!ital_vars) {
    # We don"t want (1-B) inside \\operatorname
    prim[side$term %in% c("zz_differencing", "zz_seas_Differencing")] <- gsub("B", "\\\\operatorname{B}", side$primary[side$term %in% c("zz_differencing", "zz_seas_Differencing")])
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
  escaped <- c(
    "\\ ", "\\&", "\\%", "\\$", "\\#", "\\_", "\\{", "\\}",
    "\\char`\\~", "\\char`\\^", "\\backslash "
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
#' @export
#' @keywords internal
#' @noRd

add_coefs.default <- function(rhs, term, coef_digits) {
  ests <- round(rhs$estimate, coef_digits)
  ifelse(
    rhs$term == "(Intercept)",
    paste0(ests, term),
    paste0(ests, "(", term, ")")
  )
}

#' @export
#' @keywords internal
#' @noRd

add_coefs.polr <- function(rhs, term, coef_digits) {
  ests <- round(rhs$estimate, coef_digits)
  ifelse(
    rhs$coef.type == "scale",
    paste0(ests, term),
    paste0(ests, "(", term, ")")
  )
}

#' @export
#' @keywords internal
#' @noRd

add_coefs.clm <- function(rhs, term, coef_digits) {
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
add_coefs.forecast_ARIMA <- function(side, term, coef_digits, side_sign = 1) {
  # Round the estimates and turn to a character vector
  ests <- round(side$estimate, coef_digits)

  # Use signif on anything where the round returns a zero
  ests[ests == 0 & !is.na(ests)] <- signif(side$estimate[ests == 0 & !is.na(ests)], 1)

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
#' @export
#' @keywords internal
#' @noRd

add_greek.default <- function(rhs, terms, greek = "beta", intercept = "alpha",
                              raw_tex = FALSE) {
  int <- switch(intercept,
    "alpha" = "\\alpha",
    "beta" = "\\beta_{0}"
  )
  if (raw_tex & !(intercept %in% c("alpha", "beta"))) {
    int <- intercept
  }

  ifelse(rhs$term == "(Intercept)",
    int,
    anno_greek(greek, seq_len(nrow(rhs)) - 1, terms, raw_tex)
  )
}

#' @export
#' @keywords internal
#' @noRd

add_greek.polr <- function(rhs, terms, ...) {
  rhs$idx <- unlist(lapply(split(rhs, rhs$coef.type), function(x) {
    seq_along(x$coef.type)
  }))

  ifelse(rhs$coef.type == "scale",
    anno_greek("alpha", rhs$idx),
    anno_greek("beta", rhs$idx, terms)
  )
}

#' @export
#' @keywords internal
#' @noRd

add_greek.clm <- function(rhs, terms, ...) {
  rhs$idx <- unlist(lapply(split(rhs, rhs$coef.type), function(x) {
    seq_along(x$coef.type)
  }))

  ifelse(rhs$coef.type == "intercept",
    anno_greek("alpha", rhs$idx),
    anno_greek("beta", rhs$idx, terms)
  )
}

#' Add greek placeholders for forecast::Arima
#'
#' @keywords internal
#' @noRd
add_greek.forecast_ARIMA <- function(side, terms, regression, raw_tex = FALSE, side_sign = 1) {
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
  greek <- rep("", nrow(side))
  invisible(
    lapply(names(greek_letters), function(x) {
      greek[grepl(x, side$term)] <<- greek_letters[x]
    })
  )


  # To make life easier, we"re including the greek parsing for
  # the linear component here too.
  if (sum(grepl("^s?ar|^s?ma", side$term)) == 0) {
    # Then we are dealing with the linear component and not the ARIMA component

    # Beta will serve as the main letter for the linear component
    # Anything in greek that is blank, wasn"t accounted for with known paramters.
    greek[greek == "" & side$term != "y0"] <- "beta"

    # Generate the subs for the greek letters
    ## Initialize the vector
    subs <- rep("", nrow(side))

    ## Give numbers to non-constants
    subs[!(side$term %in% c("intercept", "drift", "y0"))] <- as.character(1:sum(!(side$term %in% c("intercept", "drift", "y0"))))
  } else {
    # Deal with ARIMA component

    # Format the greek letters to vibe with the final_terms
    # This is done, in part, with anno_greek for other functions.
    subs <- rep("", nrow(side))
    subs[grepl("^s?ar|^s?ma", side$term)] <- gsub("^s?ar|^s?ma", "", side$term[grepl("^s?ar|^s?ma", side$term)])
  }

  # Add subscripts to greek
  greek[subs != ""] <- paste0(greek[subs != ""], "_{", subs[subs != ""], "}")

  # Finalize greek based on raw_tex
  if (!raw_tex) {
    greek[greek != ""] <- paste0("\\", greek[greek != ""])
  }

  # Deal with signs on greek letters
  signs <- rep("", length(greek))
  signs[!(side$term %in% c("zz_differencing", "zz_seas_Differencing"))] <- if (side_sign > 0) "+" else "-"

  # Combine the final terms with the greek letters
  final_terms <- paste0(signs, greek, terms)

  # Explicit return
  return(final_terms)
}

#' Intermediary function to wrap text in `\\beta_{}`
#'
#' @keywords internal
#' @noRd

anno_greek <- function(greek, nums, terms = NULL, raw_tex = FALSE) {
  if (raw_tex) {
    out <- paste0(greek, "_{", nums, "}")
  } else {
    out <- paste0("\\", greek, "_{", nums, "}")
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
