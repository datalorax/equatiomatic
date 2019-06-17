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

create_eq <- function(lhs, rhs, ital_vars, use_coefs, coef_digits, fix_signs,
                      model) {
  rhs$final_terms <- create_term(rhs, ital_vars)

  if (use_coefs) {
    rhs$final_terms <- add_coefs(rhs, rhs$final_terms, coef_digits)
  } else {
    rhs$final_terms <- add_greek(rhs, rhs$final_terms)
  }
  full_rhs <- paste(rhs$final_terms, collapse = " + ")

  if (use_coefs && fix_signs) {
    full_rhs <- fix_coef_signs(full_rhs, fix_signs)
  }

  paste0(lhs, " = ", full_rhs, " + \\epsilon")
}





#' Create a full term w/subscripts
#'
#' @keywords internal
#'
#' @param rhs A data frame of right-hand side variables extracted with
#'   \code{extract_rhs}.
#'
#' @inheritParams extract_eq

create_term <- function(rhs, ital_vars) {
  prim <- lapply(rhs$primary, add_tex_ital_v, ital_vars)
  subs <- lapply(rhs$subscripts, add_tex_ital_v, ital_vars)
  subs <- lapply(subs, add_tex_subscripts_v)

  final <- Map(paste0, prim, subs)

  vapply(final, add_tex_mult, FUN.VALUE = character(1))
}


#' Wrap text in \code{\\text{}}
#'
#' Add tex code to make string not italicized within an equation
#'
#' @keywords internal
#'
#' @param term A character to wrap in \code{\\text{}}
#' @param ital_vars Passed from \code{extract_eq}
#'
#' @return A character string

add_tex_ital <- function(term, ital_vars) {
  if (any(nchar(term) == 0, ital_vars)) {
    return(term)
  }
  paste0("\\text{", term, "}")
}


#' Wrap text in \code{\\text{}} (vectorized)
#'
#' Add tex code to make string not italicized within an equation for a vector
#' of strings
#'
#' @keywords internal
#'
#' @return A vector of characters

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

add_tex_subscripts_v <- function(term_v) {
  vapply(term_v, add_tex_subscripts, FUN.VALUE = character(1))
}


#' Add multiplication symbol for interaction terms
#'
#' @keywords internal

add_tex_mult <- function(term) {
  paste(term, collapse = " \\times ")
}





#' Add coefficient values to the equation
#'
#' @keywords internal

add_coefs <- function(rhs, term, coef_digits) {
  ests <- round(rhs$estimate, coef_digits)
  ifelse(
    rhs$term == "(Intercept)",
    paste0(ests, term),
    paste0(ests, "(", term, ")")
  )
}




#' Adds greek symbols to the equation
#'
#' @keywords internal

add_greek <- function(rhs, terms) {
  if (any(grepl("(Intercept)", terms))) {
    add_betas(terms, seq_len(nrow(rhs)))
  } else {
    ifelse(rhs$term == "(Intercept)",
           "\\alpha",
           add_betas(terms, seq_len(nrow(rhs)) - 1))
  }
}


#' Intermediary function to wrap text in `\\beta_{}`
#'
#' @keywords internal

add_betas <- function(terms, nums) {
  paste0("\\beta_{", nums,"}",
         "(", terms, ")"
  )
}





#' Deduplicate operators
#'
#' Convert "+ -" to "-"
#'
#' @keywords internal
#'
#' @param eq String containing a LaTeX equation
#'
#' @inheritParams extract_eq
#'
fix_coef_signs <- function(eq, fix_signs) {
  if (fix_signs) {
    gsub("\\+ -", "- ", eq)
  } else {
    eq
  }
}
