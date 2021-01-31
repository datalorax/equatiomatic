#' Determine if the forecast::Arima model is Regression w/ Arima Errors
#' or Arima only.
#'
#' @keywords internal
#'
#' @param model A forecast::Arima object
#'
#' @return A boolean
#' @noRd
helper_arima_is_regression <- function(model) {
  # Determine if we are working on Regerssion w/ Arima Errors
  !(is.null(model$xreg) || ((NCOL(model$xreg) == 1) && is.element("drift", names(model$coef))))
}


#' Extract regression components from forecast::Arima when using Regression w/
#' Arima Errors. Similar to \code{extract_rhs} and \code{extract_lhs}.
#'
#' @keywords internal
#'
#' @param model A forecast::Arima object
#'
#' @return A dataframe
#' @noRd
helper_arima_extract_lm <- function(model) {
  # ARIMA is a linear model and Exogenous Regressors can be included.
  # This function will pull out the linear portion with the exception of constants.

  # Following the rest of the package.
  # Pull the full model with broom::tidy
  full_mdl <- broom::tidy(model)
  full_mdl$term <- as.character(full_mdl$term)

  # Filter down to only non-ARMA coefficients
  full_rhs <- full_mdl[!grepl("^s?ar|^s?ma", full_mdl$term), ]

  # Extract RHS from formula, excluding constants
  formula_rhs <- full_rhs$term[!grepl("^intercept|^drift", full_rhs$term)]

  # Extract unique (primary) terms from formula (no interactions)
  formula_rhs_terms <- formula_rhs[!grepl(":", formula_rhs)]

  # Similar to extract_rhs.lm.
  ## Split interactions split into character vectors
  full_rhs$split <- strsplit(full_rhs$term, ":")

  ## Parse primary coefficients.
  full_rhs$primary <- extract_primary_term(
    formula_rhs_terms,
    full_rhs$term
  )

  full_rhs$primary[full_rhs$term == "drift"] <- "t"

  ## Build up the subscripts (on the primary)
  ## All non-constant coefficients will need a "t" subscript to represent time.
  full_rhs$subscripts <- extract_all_subscripts(
    full_rhs$primary,
    full_rhs$split
  )

  full_rhs$subscripts[full_rhs$term %in% c("intercept", "drift")] <- ""

  rhs_t_subscript <- rep("t", nrow(full_rhs))
  rhs_t_subscript[grepl("^intercept|^drift", full_rhs$term)] <- ""

  full_rhs$subscripts <- paste(full_rhs$subscripts, rhs_t_subscript, sep = ",")
  full_rhs$subscripts <- gsub("^,", "", full_rhs$subscripts)

  ## If the coefficient is drift then we need to add a y0 term
  if ("drift" %in% full_rhs$term) {
    # Then there is a drift term
    # Draw up y0 row. It will need to end up at the top of the dataframe.
    y0_df <- data.frame(
      term = "y0",
      estimate = NA,
      std.error = NA,
      split = "y",
      primary = "y",
      subscripts = "0",
      stringsAsFactors = FALSE
    )

    # rbind to add y0 to the top
    full_rhs <- rbind(y0_df, full_rhs)
  }

  # Set subscripts so that create_term works later
  full_rhs$superscripts <- ""

  # Set the class
  class(full_rhs) <- c(class(model), "data.frame")

  # Explicit return
  return(full_rhs)
}
