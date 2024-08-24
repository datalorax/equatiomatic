# PhG: I am not a fan of stating all the possible arguments in the generic
# function like it is currently the case for extract_eq(). May be keep only the
# common and most used ones and allow for varying arguments with ... However,
# changing this could possibly break backward compatibility. So, I leave it as
# it is for now... but I had to homogenize for all methods, otherwise CRAN would
# reject the package!

#' 'LaTeX' equation for R models
#' 
#' Extract the variable names from a model to produce a 'LaTeX' equation.
#' Supports any model where there is a [broom::tidy()] method. This is a generic
#' function with methods for lmerMod objects obtained with [lme4::lmer()],
#' glmerMod objects with [lme4::glmer()], forecast_ARIMA with
#' [forecast::Arima()] and default, with the later further covering most "base"
#' R models implemented in [broom::tidy()] like lm objects with [stats::lm()],
#' glm objects with [stats::glm()] or polr objects with [MASS::polr()]. The
#' default method also supports clm objects obtained with [ordinal::clm()].
#'
#' @param model A fitted model
#' @param intercept How should the intercept be displayed? Default is \code{"alpha"},
#'   but can also accept \code{"beta"}, in which case the it will be displayed
#'   as beta zero.
#' @param greek What notation should be used for
#'   coefficients? Currently only accepts \code{"beta"} (with plans for future
#'   development). Can be used in combination with \code{raw_tex} to use any
#'   notation, e.g., \code{"\\hat{\\beta}"}.
#' @param greek_colors The colors of the greek notation in the equation. Must
#'   be a single color (named or HTML hex code) or a vector of colors (which
#'   will be recycled if smaller than the number of terms in the model). When
#'   rendering to PDF, I suggest using HTML hex codes, as not all named colors
#'   are recognized by LaTeX, but equatiomatic will internally create the
#'   color definitions for you if HTML codes are supplied. Note that this is 
#'   not yet implemented for mixed effects models (lme4). 
#' @param subscript_colors The colors of the subscripts for the greek notation.
#'   The argument structure is equivalent to \code{greek_colors} (i.e., see
#'   above for more detail).
#' @param var_colors The color of the variable names. This takes a named vector
#'   of the form \code{c("variable" = "color")}. For example 
#'   \code{c("bill_length_mm" = "#00d4fa", "island" = "#00fa85")}. Colors can
#'   be names (e.g., \code{"red"}) or HTML hex codes, as shown in the example.
#' @param var_subscript_colors The colors of the factor subscripts for 
#'   categorical variables. The interface for this is equivalent to 
#'   \code{var_colors}, and all subscripts for a given variable will be 
#'   displayed in the provided color. For example, the code 
#'   \code{c("island" = "green")} would result in the subscripts for "Dream"
#'   and "Torgersen" being green (assuming "Biscoe" was the reference group).
#' @param raw_tex Logical. Is the greek code being passed to denote coefficients
#' raw tex code?
#' @param swap_var_names A vector of the form c("old_var_name" = "new name"). 
#'   For example: c("bill_length_mm" = "Bill Length (MM)").
#' @param swap_subscript_names A vector of the form 
#'   c("old_subscript_name" = "new name"). For example: 
#'   c("f" = "Female").
#' @param ital_vars Logical, defaults to \code{FALSE}. Should the variable names
#'   not be wrapped in the \code{\\operatorname{}} command?
#' @param label A label for the equation, which can then be used for in-text 
#'   references. See example [here](https://www.overleaf.com/learn/latex/Cross_referencing_sections,_equations_and_floats#Referencing_equations.2C_figures_and_tables).
#'   Note that this **only works for PDF output**. The in-text references also 
#'   must match the label exactly, and must be formatted as 
#'   \code{\\ref{eq: label}}, where \code{label} is a place holder for the
#'   specific label. Notice the space after the colon before the label. This
#'   also must be there, or the cross-reference will fail.
#' @param index_factors Logical, defaults to \code{FALSE}. Should the factors 
#' be indexed, rather than using subscripts to display all levels?
#' @param show_distribution Logical. When fitting a logistic or probit
#'   regression, should the binomial distribution be displayed? Defaults to
#'   \code{FALSE}.
#' @param wrap Logical, defaults to \code{FALSE}. Should the terms on the
#'   right-hand side of the equation be split into multiple lines? This is
#'   helpful with models with many terms.
#' @param terms_per_line Integer, defaults to 4. The number of right-hand side
#'   terms to include per line. Used only when \code{wrap} is \code{TRUE}.
#' @param operator_location Character, one of \dQuote{end} (the default) or
#'   \dQuote{start}. When terms are split across multiple lines, they are split
#'   at mathematical operators like `+`. If set to \dQuote{end}, each line will
#'   end with a trailing operator (`+` or `-`). If set to \dQuote{start}, each
#'   line will begin with an operator.
#' @param align_env TeX environment to wrap around equation. Must be one of
#'   \code{aligned}, \code{aligned*}, \code{align}, or \code{align*}. Defaults
#'   to \code{aligned}.
#' @param use_coefs Logical, defaults to \code{FALSE}. Should the actual model
#'   estimates be included in the equation instead of math symbols?
#' @param coef_digits Integer, defaults to 2. The number of decimal places to
#'   round to when displaying model estimates.
#' @param fix_signs Logical, defaults to \code{TRUE}. If disabled,
#'   coefficient estimates that are negative are preceded with a "+" (e.g.
#'   `5(x) + -3(z)`). If enabled, the "+ -" is replaced with a "-" (e.g.
#'   `5(x) - 3(z)`).
#' @param font_size The font size of the equation. Defaults to default of
#'   the output format. Takes any of the standard LaTeX arguments (see 
#'   [here](https://www.overleaf.com/learn/latex/Font_sizes,_families,_and_styles#Font_styles)).
#' @param mean_separate Currently only support for \code{\link[lme4]{lmer}}
#'   models. Should the mean structure be inside or separated from the
#'   normal distribution? Defaults to \code{NULL}, in which case it will become
#'   \code{TRUE} if there are more than three fixed-effect parameters. If
#'   \code{TRUE}, the equation will be displayed as, for example,
#'   outcome ~ N(mu, sigma); mu = alpha + beta_1(wave). If \code{FALSE}, this
#'   same equation would be outcome ~ N(alpha + beta, sigma).
#' @param return_variances Logical. When \code{use_coefs = TRUE} with a mixed
#'   effects model (e.g., \code{lme4::lmer()}), should the variances and
#'   co-variances be returned? If \code{FALSE} (the default) standard deviations
#'   and correlations are returned instead.
#' @param se_subscripts Logical. If \code{se_subscripts = TRUE} then the 
#'   equation will include the standard errors below each coefficient. 
#'   This is supported for lm and glm models.
#' @param ... Additional arguments (for future development; not currently used).
#' @export
#'
#' @return A character of class \dQuote{equation}.
#' 
#' @details
#' The different methods all use the same arguments, but not all arguments are
#' suitable to all models. Check here above to determine if a feature is
#' implemented for a given model.
#' 
#' @examples
#' # Simple model
#' mod1 <- lm(mpg ~ cyl + disp, mtcars)
#' extract_eq(mod1)
#'
#' # Include all variables
#' mod2 <- lm(mpg ~ ., mtcars)
#' extract_eq(mod2)
#'
#' # Works for categorical variables too, putting levels as subscripts
#' mod3 <- lm(body_mass_g ~ bill_length_mm + species, penguins)
#' extract_eq(mod3)
#'
#' set.seed(8675309)
#' d <- data.frame(
#'   cat1 = rep(letters[1:3], 100),
#'   cat2 = rep(LETTERS[1:3], each = 100),
#'   cont1 = rnorm(300, 100, 1),
#'   cont2 = rnorm(300, 50, 5),
#'   out = rnorm(300, 10, 0.5)
#' )
#' mod4 <- lm(out ~ ., d)
#' extract_eq(mod4)
#'
#' # Don't italicize terms
#' extract_eq(mod1, ital_vars = FALSE)
#'
#' # Wrap equations in an "aligned" environment
#' extract_eq(mod2, wrap = TRUE)
#'
#' # Wider equation wrapping
#' extract_eq(mod2, wrap = TRUE, terms_per_line = 4)
#'
#' # Include model estimates instead of Greek letters
#' extract_eq(mod2, wrap = TRUE, terms_per_line = 2, use_coefs = TRUE)
#'
#' # Don't fix doubled-up "+ -" signs
#' extract_eq(mod2, wrap = TRUE, terms_per_line = 4, use_coefs = TRUE, fix_signs = FALSE)
#'
#' # Use indices for factors instead of subscripts
#' extract_eq(mod2, wrap = TRUE, terms_per_line = 4, index_factors = TRUE)
#'
#' # Use other model types, like glm
#' set.seed(8675309)
#' d <- data.frame(
#'   out = sample(0:1, 100, replace = TRUE),
#'   cat1 = rep(letters[1:3], 100),
#'   cat2 = rep(LETTERS[1:3], each = 100),
#'   cont1 = rnorm(300, 100, 1),
#'   cont2 = rnorm(300, 50, 5)
#' )
#' mod5 <- glm(out ~ ., data = d, family = binomial(link = "logit"))
#' extract_eq(mod5, wrap = TRUE)
extract_eq <- function(model, intercept = "alpha", greek = "beta",
                       greek_colors = NULL, subscript_colors = NULL,
                       var_colors = NULL, var_subscript_colors = NULL, 
                       raw_tex = FALSE, 
                       swap_var_names = NULL, swap_subscript_names = NULL,
                       ital_vars = FALSE, label = NULL,
                       index_factors = FALSE, show_distribution = FALSE,
                       wrap = FALSE, terms_per_line = 4,
                       operator_location = "end", align_env = "aligned",
                       use_coefs = FALSE, coef_digits = 2,
                       fix_signs = TRUE, font_size = NULL,
                       mean_separate = NULL, return_variances = FALSE,
                       se_subscripts = FALSE, ...) {
  UseMethod("extract_eq", model)
}

# PhG: we do not want to repeat usage, so no @describeIn extract_eq default `extract_eq()` method
#' Default function for extracting an equation from a model object
#'
#' @keywords internal
#' @export
#' @noRd
extract_eq.default <- function(model, intercept = "alpha", greek = "beta",
                               greek_colors = NULL, subscript_colors = NULL,
                               var_colors = NULL, var_subscript_colors = NULL, 
                               raw_tex = FALSE, 
                               swap_var_names = NULL, swap_subscript_names = NULL,
                               ital_vars = FALSE, label = NULL,
                               index_factors = FALSE, show_distribution = FALSE,
                               wrap = FALSE, terms_per_line = 4,
                               operator_location = "end", align_env = "aligned",
                               use_coefs = FALSE, coef_digits = 2,
                               fix_signs = TRUE, font_size = NULL,
                               mean_separate = NULL, return_variances = FALSE, 
                               se_subscripts = FALSE, ...) {
  if (index_factors & use_coefs) {
    stop("Coefficient estimates cannot be returned when factors are indexed.")
  }
  
  lhs <- extract_lhs(model, ital_vars, show_distribution, use_coefs, 
                     swap_var_names, var_colors)
  rhs <- extract_rhs(model, index_factors)
  
  eq_raw <- create_eq(
    model, lhs, rhs, ital_vars, use_coefs, coef_digits,
    fix_signs, intercept, greek, 
    greek_colors, subscript_colors, var_colors, var_subscript_colors, raw_tex,
    index_factors, swap_var_names, swap_subscript_names
  )
  
  if (se_subscripts) {
    eq_raw$rhs[[1]] <- add_se(eq_raw$rhs[[1]], model)
  }

  if (wrap) {
    if (operator_location == "start") {
      line_end <- "\\\\\n&\\quad + "
    } else {
      line_end <- "\\ + \\\\\n&\\quad "
    }

    # Split all the RHS terms into groups of length terms_per_line
    rhs_groups <- lapply(eq_raw$rhs, function(x) {
      split(x, ceiling(seq_along(x) / terms_per_line))
    })

    # Collapse the terms with + within each group
    rhs_groups_collapsed <- lapply(rhs_groups, function(x) {
      vapply(x, paste0, collapse = " + ", FUN.VALUE = character(1))
    })

    # Collapse the collapsed groups with the line ending (trailing or leading +)
    rhs_combined <- lapply(rhs_groups_collapsed, function(x) {
      paste(x, collapse = line_end)
    })
  } else {
    rhs_combined <- lapply(eq_raw$rhs, function(x) {
      paste(x, collapse = " + ")
    })
  }

  if (wrap | 
      length(rhs_combined) > 1 | 
      show_distribution | 
      !is.null(font_size)) {
    needs_align <- TRUE
  } else {
    needs_align <- FALSE
  }

  # Combine RHS and LHS
  eq <- Map(function(.lhs, .rhs) {
    paste(.lhs, .rhs,
      sep = ifelse(needs_align, " &= ", " = ")
    )
  },
  .lhs = eq_raw$lhs,
  .rhs = wrap_rhs(model, rhs_combined)
  )

  if (use_coefs && fix_signs) {
    eq <- lapply(eq, fix_coef_signs)
  }
  
  if (use_coefs && fix_signs && se_subscripts) {
    eq <- lapply(eq, fix_coef_signs_se)
  }

  if (length(eq) > 1) {
    eq <- paste(eq, collapse = " \\\\\n")
  } else {
    eq <- eq[[1]]
  }

  # Add environment finally, if wrapping or if there are multiple equations
  # This comes later so that multiple equations don't get their own environments
  if (needs_align) {
    eq <- paste0(
      "\\begin{", align_env, "}\n",
      eq,
      "\n\\end{", align_env, "}"
    )
  }
  if (!is.null(label)) {
    eq <- paste0("\\label{eq: ", label, "}\n", eq)
  }
  if (!is.null(font_size)) {
    eq <- paste0("\\", font_size, "\n", eq)
  }
  
  if (
    any(
      !is.null(c(greek_colors, 
                 subscript_colors, 
                 var_colors, 
                 var_subscript_colors))
      )
    ) {
    
    full_colors <- unique(
      c(greek_colors, subscript_colors, var_colors, var_subscript_colors)
    ) 
  
    attributes(eq) <- list(
      latex_define_colors = define_latex_html_colors(full_colors)
    )
  }
  
  class(eq) <- c("equation", "character")
  
  return(eq)
}



# These args still need to be incorporated
# intercept, greek, raw_tex
# I haven't incorporated wrap yet either and we should think about if we want to
# It might be better to have an alternative for matrix notation

# PhG: we do not want to repeat usage, so no @describeIn extract_eq lmerMod `extract_eq()` method
#' @export
#' @noRd
extract_eq.lmerMod <- function(model, intercept = "alpha", greek = "beta",
                               greek_colors = NULL, subscript_colors = NULL,
                               var_colors = NULL, var_subscript_colors = NULL, 
                               raw_tex = FALSE,
                               swap_var_names = NULL, swap_subscript_names = NULL,
                               ital_vars = FALSE, label = NULL,
                               index_factors = FALSE, show_distribution = FALSE,
                               wrap = FALSE, terms_per_line = 4,
                               operator_location = "end", align_env = "aligned",
                               use_coefs = FALSE, coef_digits = 2,
                               fix_signs = TRUE, font_size = NULL,
                               mean_separate = NULL, return_variances = FALSE,
                               se_subscripts = FALSE, ...) {
  if (isTRUE(se_subscripts)) {
    warning("Standard errors are not supported for mixed effects models",
      call. = FALSE
    )
  }
  
  if (!is.null(greek_colors)) {
    warning(
      paste0("Colorization of greek notation not currently ",
             "implemented for merMod models"),
      call. = FALSE
    )
  }
  if (!is.null(subscript_colors)) {
    warning(
      paste0("Colorization of subscripts not currently ",
             "implemented for merMod models"),
      call. = FALSE
      )
  }
  l1 <- create_l1(model, mean_separate,
    ital_vars, wrap, terms_per_line,
    use_coefs, coef_digits, fix_signs,
    operator_location,
    sigma = "\\sigma^2", return_variances,
    swap_var_names, swap_subscript_names,
    var_colors, var_subscript_colors
  )
  vcv <- create_ranef_structure_merMod(
    model, ital_vars, use_coefs, coef_digits,
    fix_signs, return_variances, swap_var_names, swap_subscript_names,
    var_colors, var_subscript_colors
  )
  
  # check for double line breaks
  dbl_brk <- any(
    vapply(vcv, function(x) grepl("\n\\W+\n", x), FUN.VALUE = logical(1))
  )
  
  if (dbl_brk) {
      vcv <- lapply(vcv, function(x) {
        gsub("^\n(.+)", "\\1", x)
      })
  }

  eq <- paste(c(l1, vcv), collapse = " \\\\")
  eq <- gsub("\\sim", " &\\sim", eq, fixed = TRUE)
  eq <- paste(eq, collapse = " \\\\ \n")
  eq <- paste0(
    "\\begin{", align_env, "}\n",
    paste0("  ", eq),
    "\n\\end{", align_env, "}"
  )
  if (!is.null(label)) {
    eq <- paste0("\\label{eq: ", label, "}\n", eq)
  }
  if (!is.null(font_size)) {
    eq <- paste0("\\", font_size, "\n", eq)
  }
  class(eq) <- c("equation", "character")

  eq
}

# PhG: we do not want to repeat usage, so no @describeIn extract_eq glmerMod `extract_eq()` method
#' @export
#' @noRd
extract_eq.glmerMod <- function(model, intercept = "alpha", greek = "beta",
                                greek_colors = NULL, subscript_colors = NULL,
                                var_colors = NULL, var_subscript_colors = NULL, 
                                raw_tex = FALSE,
                                swap_var_names = NULL, swap_subscript_names = NULL,
                                ital_vars = FALSE, label = NULL,
                                index_factors = FALSE, show_distribution = FALSE,
                                wrap = FALSE, terms_per_line = 4,
                                operator_location = "end", align_env = "aligned",
                                use_coefs = FALSE, coef_digits = 2,
                                fix_signs = TRUE, font_size = NULL,
                                mean_separate = NULL, return_variances = FALSE,
                                se_subscripts = FALSE, ...) {
  if (!is.null(greek_colors)) {
    warning(
      paste0("Colorization of greek notation not currently ",
             "implemented for merMod models"))
  }
  if (!is.null(subscript_colors)) {
    warning(
      paste0("Colorization of subscripts not currently ",
             "implemented for merMod models"))
  }
  extract_eq.lmerMod(model, intercept = intercept, greek = greek,
    greek_colors = greek_colors, subscript_colors = subscript_colors,
    var_colors = var_colors, var_subscript_colors = var_subscript_colors,
    raw_tex = raw_tex, swap_var_names = swap_var_names,
    swap_subscript_names = swap_subscript_names, ital_vars = ital_vars,
    label = label, index_factors = index_factors,
    show_distribution = show_distribution, wrap = wrap,
    terms_per_line = terms_per_line, operator_location = operator_location,
    align_env = align_env, use_coefs = use_coefs, coef_digits = coef_digits,
    fix_signs = fix_signs, font_size = font_size, mean_separate = mean_separate,
    return_variances = return_variances, se_subscripts = se_subscripts, ...)
}

# PhG: we do not want to repeat usage, so no @describeIn extract_eq forecast_ARIMA `extract_eq()` method
#' @export
#' @noRd
extract_eq.forecast_ARIMA <- function(model, intercept = "alpha", greek = "beta",
                                      greek_colors = NULL, subscript_colors = NULL,
                                      var_colors = NULL, var_subscript_colors = NULL, 
                                      raw_tex = FALSE, 
                                      swap_var_names = NULL, swap_subscript_names = NULL,
                                      ital_vars = FALSE, label = NULL,
                                      index_factors = FALSE, show_distribution = FALSE,
                                      wrap = FALSE, terms_per_line = 4,
                                      operator_location = "end", align_env = "aligned",
                                      use_coefs = FALSE, coef_digits = 2,
                                      fix_signs = TRUE, font_size = NULL,
                                      mean_separate = NULL, return_variances = FALSE,
                                      se_subscripts = FALSE, ...) {

  if (isTRUE(se_subscripts)) {
    warning("Standard errors are not supported for mixed effects models",
      call. = FALSE
    )
  }
  
  # Determine if we are working on Regression w/ Arima Errors
  regression <- helper_arima_is_regression(model)

  # Get each of the sides
  lhs <- extract_lhs(model)
  rhs <- extract_rhs(model)

  if (regression) {
    yt <- helper_arima_extract_lm(model)
  } else {
    yt <- NULL
  }

  # Extract the equation lists
  eq <- create_eq(
    model,
    lhs,
    rhs,
    yt,
    ital_vars,
    use_coefs,
    coef_digits,
    raw_tex,
    swap_var_names,
    swap_subscript_names
  )

  ##########
  # Wrapping has not been included due to the
  # Multiline nature of Regression w/ ARIMA errors
  ##########

  ##########
  # Fix signs is done automatically
  # This is necessary so that the Lag/Backshift equations will make sense.
  #########

  # Collapse down terms.
  eq <- lapply(eq, function(x) {
    lhs <- paste(x$lhs[[1]], collapse = " ")
    rhs <- paste(x$rhs[[1]], collapse = " ")
    rhs <- gsub("^\\+", "", rhs)

    # Alignment, if needed, will be added later.
    paste(lhs, rhs, sep = " = ")
  })

  # If regression w/ arima errors.
  if (regression) {
    # Add alignment to the regression function
    eq$lm_eq <- paste0("&\\text{let}\\quad &&", eq$lm_eq)

    # Add alignment and "where" to ARIMA line
    # Need to re-split the terms. This is redundant, but makes for less repeated code.
    # Ensure it is seen as a character vector first and foremost.
    split_arima <- strsplit(eq$arima_eq, "=")[[1]]
    names(split_arima) <- c("ar", "ma")

    split_arima["ar"] <- paste0("&\\text{where}\\quad  &&", split_arima["ar"])
    split_arima["ma"] <- paste0("& &&=", split_arima["ma"])

    eq$arima_eq <- paste(split_arima, collapse = " \\\\\n")

    # Add line (always the same) indicating the distribution of the residual.
    eq$err_dist <- "&\\text{where}\\quad &&\\varepsilon_{t} \\sim{WN(0, \\sigma^{2})}"

    # Add alignment to the equation structure.
    eq <- paste0(
      "\\begin{alignat}{2}\n",
      paste(eq, collapse = " \\\\\n"),
      "\n\\end{alignat}"
    )
    if (!is.null(font_size)) {
      eq <- paste0("\\", font_size, "\n", eq)
    }
  } else {
    # If arima only then we only need 1 line and no alignment.
    eq <- eq$arima_eq
    if (!is.null(label)) {
      eq <- paste0("\\label{eq: ", label, "}\n", eq)
    }
    if (!is.null(font_size)) {
      eq <- paste0(
        "\\begin{aligned}\n",
        paste(eq, collapse = " \\\\\n"),
        "\n\\end{aligned}"
      )
      eq <- paste0("\\", font_size, "\n", eq)
    }
  }
  
  # Set the class
  class(eq) <- c("equation", "character")

  # Explicit return
  return(eq)
}

#' Add Standard Errors Below Coefficients
#' 
#' @param coef character vector of model coefficients (from output of the function create_eq)
#' @param model a fitted model 
#' 
#' @return a character vector adding the errors beneath each term
#' @noRd
add_se <- function(coef, model) {
  errors <- summary(model)$coefficients[,"Std. Error"]
  errors <- as.character(round(errors, 3))
  if (length(coef) != length(errors)) {
    result <- paste0("\\underset{(", errors, ")}{", coef[-length(coef)], "}")
    result <- c(result, coef[length(coef)])
  }
  else {
    result <- paste0("\\underset{(", errors, ")}{", coef, "}")
  }
  return(result)
}



#' Fixes the Signs When Using se_subscripts Argument
#' 
#' @param equation list that contains the equation
#' 
#' @return a list containing the equation with fixed signs
#' @noRd
fix_coef_signs_se <- function(equation) {
  components <- strsplit(equation, " + ", fixed = TRUE)
  components <- unlist(components)
  terms <- components[2:length(components)]
  negative <- ifelse(grepl(terms, pattern = "-"), " - ", " + ")
  terms <- lapply(X = terms, FUN = gsub,  pattern = "-", replacement = "")
  terms <- paste0(negative, terms, collapse = "")
  list(paste(components[1], terms))
}

#' @export
#' @noRd
extract_eq.model_fit <- 
  function(model, intercept = "alpha", greek = "beta",
           greek_colors = NULL, subscript_colors = NULL,
           var_colors = NULL, var_subscript_colors = NULL, 
           raw_tex = FALSE, 
           swap_var_names = NULL, swap_subscript_names = NULL,
           ital_vars = FALSE, label = NULL,
           index_factors = FALSE, show_distribution = FALSE,
           wrap = FALSE, terms_per_line = 4,
           operator_location = "end", align_env = "aligned",
           use_coefs = FALSE, coef_digits = 2,
           fix_signs = TRUE, font_size = NULL,
           mean_separate = NULL, return_variances = FALSE, 
           se_subscripts = FALSE, ...) {
    
  if ("fit" %in% names(model)) {
    fitted_model <- model$fit
    extract_eq(fitted_model, intercept = intercept, greek = greek,
      greek_colors = greek_colors, subscript_colors = subscript_colors,
      var_colors = var_colors, 
      var_subscript_colors = var_subscript_colors, 
      raw_tex = raw_tex, 
      swap_var_names = swap_var_names, 
      swap_subscript_names = swap_subscript_names,
      ital_vars = ital_vars, label = label,
      index_factors = index_factors, 
      show_distribution = show_distribution,
      wrap = wrap, terms_per_line = terms_per_line,
      operator_location = operator_location, 
      align_env = align_env,
      use_coefs = use_coefs, coef_digits = coef_digits,
      fix_signs = fix_signs, font_size = font_size,
      mean_separate = mean_separate, 
      return_variances = return_variances, 
      se_subscripts = se_subscripts, ...)  
  } else {
    stop("The 'model' does not appear to be a proper **model_fit** object ",
      "because it does not have a 'fit' component.")
  }
}

#' @export
#' @noRd
extract_eq.workflow <- 
  function(model, intercept = "alpha", greek = "beta",
           greek_colors = NULL, subscript_colors = NULL,
           var_colors = NULL, var_subscript_colors = NULL, 
           raw_tex = FALSE, 
           swap_var_names = NULL, swap_subscript_names = NULL,
           ital_vars = FALSE, label = NULL,
           index_factors = FALSE, show_distribution = FALSE,
           wrap = FALSE, terms_per_line = 4,
           operator_location = "end", align_env = "aligned",
           use_coefs = FALSE, coef_digits = 2,
           fix_signs = TRUE, font_size = NULL,
           mean_separate = NULL, return_variances = FALSE, 
           se_subscripts = FALSE, ...) {
    
  if ("fit" %in% names(model)) {
    fitted_stage <- model$fit
    if ("fit" %in% names(fitted_stage)) {
      fitted_model <- fitted_stage$fit
      extract_eq(fitted_model, intercept = intercept, greek = greek,
        greek_colors = greek_colors, subscript_colors = subscript_colors,
        var_colors = var_colors, 
        var_subscript_colors = var_subscript_colors, 
        raw_tex = raw_tex, 
        swap_var_names = swap_var_names, 
        swap_subscript_names = swap_subscript_names,
        ital_vars = ital_vars, label = label,
        index_factors = index_factors, 
        show_distribution = show_distribution,
        wrap = wrap, terms_per_line = terms_per_line,
        operator_location = operator_location, 
        align_env = align_env,
        use_coefs = use_coefs, coef_digits = coef_digits,
        fix_signs = fix_signs, font_size = font_size,
        mean_separate = mean_separate, 
        return_variances = return_variances, 
        se_subscripts = se_subscripts, ...) 
    } else {
      stop("The 'model' does not appear to be a proper **workflow** object ",
        "because it does not have a proper 'fit' component.")
    }
  } else {
    stop("The 'model' does not appear to be a proper **workflow** object ",
      "because it does not have a 'fit' component.")
  }
}
