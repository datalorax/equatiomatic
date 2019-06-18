#' LaTeX code for R models
#'
#' Extract the variable names from a model to produce a LaTeX equation, which is
#' output to the screen. Supports any model supported by
#' [broom::tidy][broom::tidy].
#'
#' @param model A fitted model
#' @param ital_vars Logical, defaults to \code{FALSE}. Should the variable names
#'   not be wrapped in the \code{\\text{}} command?
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
#' @param fix_signs Logical, defaults to \code{FALSE}. If disabled,
#'   coefficient estimates that are negative are preceded with a "+" (e.g.
#'   `5(x) + -3(z)`). If enabled, the "+ -" is replaced with a "-" (e.g.
#'   `5(x) - 3(z)`).
#' @export
#'
#' @return A character of class \dQuote{equation}.
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
#' mod3 <- lm(Sepal.Length ~ Sepal.Width + Species, iris)
#' extract_eq(mod3)
#'
#' set.seed(8675309)
#' d <- data.frame(cat1 = rep(letters[1:3], 100),
#'                 cat2 = rep(LETTERS[1:3], each = 100),
#'                 cont1 = rnorm(300, 100, 1),
#'                 cont2 = rnorm(300, 50, 5),
#'                 out   = rnorm(300, 10, 0.5))
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
#' # Use other model types, like glm
#' set.seed(8675309)
#' d <- data.frame(out = sample(0:1, 100, replace = TRUE),
#'                 cat1 = rep(letters[1:3], 100),
#'                 cat2 = rep(LETTERS[1:3], each = 100),
#'                 cont1 = rnorm(300, 100, 1),
#'                 cont2 = rnorm(300, 50, 5))
#' mod5 <- glm(out ~ ., data = d, family = binomial(link = "logit"))
#' extract_eq(mod5, wrap = TRUE)

extract_eq <- function(model, ital_vars = FALSE,
                       wrap = FALSE, terms_per_line = 4, operator_location = "end",
                       align_env = "aligned",
                       use_coefs = FALSE, coef_digits = 2, fix_signs = TRUE) {

  lhs <- extract_lhs(model, ital_vars)
  rhs <- extract_rhs(model)

  eq_raw <- create_eq(lhs,
                      rhs,
                      ital_vars,
                      use_coefs,
                      coef_digits,
                      fix_signs,
                      model)

  if (wrap) {
    if (operator_location == "start") {
      line_end <- "\\\\\n &\\quad + "
    } else {
      line_end <- "\\ + \\\\\n &\\quad "
    }

    # Split all the RHS terms into groups of length terms_per_line
    rhs_groups <- split(eq_raw$rhs, ceiling(seq_along(eq_raw$rhs) / terms_per_line))

    # Collapse the terms with + within each group
    rhs_groups_collapsed <- vapply(rhs_groups, paste0, collapse = " + ",
                                   FUN.VALUE = character(1))

    # Collapse the collapsed groups with the line ending (trailing or leading +)
    rhs_combined <- paste(rhs_groups_collapsed, collapse = line_end)

    eq <- paste0("\\begin{", align_env, "}\n",
                 paste(eq_raw$lhs,
                       rhs_combined,
                       sep = " &= "),
                 "\n\\end{", align_env, "}")
  } else {
    eq <- paste(eq_raw$lhs,
                paste(eq_raw$rhs, collapse = " + "),
                sep = " = ")
  }

  if (use_coefs && fix_signs) {
    eq <- fix_coef_signs(eq)
  }

  class(eq) <- c('equation', 'character')

  return(eq)
}
