#################################################### BEGIN MODEL IMPLEMENTATION
##########################
# Model Implementation
# Package: forecast
# Class: forecast_ARIMA
##########################

##########################
# User-Facing Extension(s)
##########################
# Extension of user-facing equatiomatic methods. See defaults.R.

########## extract_eq

#' @title
#' 'LaTeX' code for forecast_ARIMA models.
#'
#' @description
#' \Sexpr[results=rd, stage=render]{rlang:::lifecycle("maturing")}
#'
#' @details
#' Extracts equation from \code{forecast::Arima()} built model.
#'
#' Implementations for different models may have additional arguments. Please
#' see model-specific documentation for a description of those arguments.
#'
#' @inherit extract_eq
#'
#' @return A character of class \dQuote{equation}.
#'
#' @family extraction functions
#'
#' @export
extract_eq.forecast_ARIMA <-
  function(
    .model,
    .ital_vars = FALSE,
    .wrap = FALSE,
    .terms_per_line = 4,
    .operator_location = "end",
    .align_env = "aligned",
    .use_coefs = FALSE,
    .coef_digits = 2,
    .fix_signs = TRUE,
    .font_size
  ) {
    ##########################
    # Extraction and model description
    ##########################

    # This is more than needed, but we"re being explicit for readability.
    # Orders structure in Arima model: c(p, q, P, Q, m, d, D)
    ords <- model$arma
    names(ords) <- c("p", "q", "P", "Q", "m", "d", "D")

    # Pull the full model with broom::tidy
    full_mdl <- broom::tidy(model)

    # Filter down to only the AR and SAR coefficients.
    ar_terms <- grepl("^ar", full_mdl$term)
    sar_terms <- grepl("^sar", full_mdl$term)

    # Filter down to only the MA terms and seasonal drift
    ma_terms <- grepl("^ma", full_mdl$term)
    sma_terms <- grepl("^sma", full_mdl$term)
    drift_terms <- grepl("^drift", full_mdl$term)
    regression_terms <- !(ar_terms | sar_terms| ma_terms | sma_terms | drift_terms)

    # Get properties
    ## Subscripts
    subscript_loc <- regexpr("\\d+", full_mdl$term)
    subscript_bool <- ( subscript_loc > 0 ) & !regression_terms
    subscripts <- substring( full_mdl$term, subscript_loc )

    subscripts[drift_terms] <- full_mdl$term[drift_terms]


    ##########################
    # Convert to Terms
    ##########################

    # Convert to terms
    terms <- convert2terms(full_mdl)

    # Suffix
    terms <- set_suffix(terms, eq_variable("B"), ar_terms | sar_terms| ma_terms | sma_terms)

    # Suffix Variables
    terms <- set_variable_name(terms, "suffix", "t", drift_terms)
    terms <- set_variable_name(terms, "suffix", full_mdl$term[regression_terms], regression_terms)

    # Variable Variables
    terms <- set_variable_name(terms, "variable", "\\phi", ar_terms)
    terms <- set_variable_name(terms, "variable", "\\Phi", sar_terms)
    terms <- set_variable_name(terms, "variable", "\\theta", ma_terms)
    terms <- set_variable_name(terms, "variable", "\\Theta", sma_terms)
    terms <- set_variable_name(terms, "variable", "\\delta", drift_terms)
    terms <- set_variable_name(terms, "variable", "\\beta", regression_terms)

    # Subscripts
    terms <- set_variable_subscript(terms, "suffix", "t", regression_terms)
    terms <- set_variable_subscript(terms, "variable", subscripts, subscript_bool)
    terms <- set_variable_subscript(terms, "variable", 1:sum(regression_terms), regression_terms)

    # Superscripts
    ## Get the superscript for the backshift operator.
    ### This is equal to the number on the term for AR/MA
    ### and the number on the term * the seasonal frequency for SAR/SMA.
    terms <- set_variable_superscript(terms, "suffix", subscripts, subscript_bool)

    terms <-
      apply_variable_superscript(
        terms, "suffix",
        function(sar) { as.numeric(sar) * ords[["m"]] },
        sar_terms
      )

    terms <-
      apply_variable_superscript(
        terms, "suffix",
        function(sma) { as.numeric(sma) * ords[["m"]] },
        sma_terms
      )

    ### Differencing
    #### The AR-side has differencing and seasonal differencing.
    if(ords["d"] > 0) {
      terms[["differencing"]] <-
        c_term(
          "(1 - B)",
          if(ords["d"] > 1) { paste("^{", ords["d"], "}", sep = "")}
        )
    }

    if(ords["D"] > 0) {
      terms[["seasonal_differencing"]] <-
        c_term(
          "(1 - B",
          if(ords["m"] > 1) { paste("^{", ords["m"], "}", sep = "") },
          ")",
          if(ords["D"] > 1) { paste("^{", ords["D"], "}", sep = "") }
        )
    }

    ##########################
    # Cleanup and Argument Application
    ##########################

    ### Superscript Reduction
    ##### Reduce any "1" superscripts to blank
    terms <-
      apply_variable_superscript(
        terms,
        c("variable", "suffix"),
        function(superscript) {
          if( !is.na(superscript) & (superscript == 1 | superscript == "1") ) {
            NA_character_
          } else {
            as.character(superscript)
          }
        }
      )

    ### Italics
    if (!ital_vars) {
      terms <- set_variable_italic(terms, c("variable", "suffix"), ital_vars)
    }

    ##########################
    # Regression + ARIMA Errors vs ARIMA Only
    ##########################

    # Regression
    # Regression Differences
    ## Add a y_0 for regression terms
    ## Add a y_t for regression terms
    if ( sum(regression_terms) > 0 ) {
      # Generate Constant Terms
      terms[['y0']] = eq_variable("y", .subscript = "0", .italic = ital_vars)
      terms[["yt"]] = eq_variable("y", .subscript = "t", .italic = ital_vars)

      # TODO: Implement wrapping!
      # Generate basic lines (do not worry about wrapping)
      let_line <-
        eq_line(
          "&\\text{let}\\quad &&",
          terms[["yt"]],
          "=",
          terms[["y0"]],
          "+",
          terms[["drift"]],
          "+",
          combine_by(terms[1:length(regression_terms)][regression_terms], "+"),
          "+",
          "\\eta_{t}"
        )

      arma_line <-
        eq_line(
          "&\\text{where}\\quad  &&",
          combine_by(terms[1:length(ar_terms)][ar_terms], function(x) { c_term("(1-", x, ")") }),
          combine_by(terms[1:length(sar_terms)][sar_terms], function(x) { c_term("(1-", x, ")") }),
          terms[["differencing"]],
          terms[["seasonal_differencing"]],
          "\\eta_{t}",
          "\\\\\n",
          "& &&=",
          combine_by(terms[1:length(ma_terms)][ma_terms], function(x) { c_term("(1-", x, ")") }),
          combine_by(terms[1:length(sma_terms)][sma_terms], function(x) { c_term("(1-", x, ")") }),
          "varepsilon_{t}"
        )

      err_line <-
        eq_line(
          "&\\text{where}\\quad &&\\varepsilon_{t} \\sim{WN(0, \\sigma^{2})}"
        )

      # Generate equation
      eq <-
        eq_equation(
          let_line,
          arma_line,
          err_line
        )
    }
    else {
      eq <-
        eq_equation(
          combine_by(terms[1:length(ar_terms)][ar_terms], function(x) { c_term("(1-", x, ")") }),
          combine_by(terms[1:length(sar_terms)][sar_terms], function(x) { c_term("(1-", x, ")") }),
          terms[["differencing"]],
          terms[["seasonal_differencing"]],
          if( sum(drift_terms) > 0 ) { c_term("(y_{t}", terms[[drift_terms]], ")") } else { "y_{t}" }
        )
    }

    ##########################
    # Convert to latex
    ##########################
    eq <- convert2latex(eq)

    ##########################
    # Convert to latex
    ##########################
    eq
  }


##########################
# Internal Method(s)
##########################
# Extension of internal equatiomatic methods. See defaults.R.
#TODO: Separate equation and converting to latex


##########################
# Utilities & Internal Methods
##########################
# These functions are used on this class and are not expected to be used
# elsewhere or with method dispatch.

#################################################### END MODEL IMPLEMENTATION
