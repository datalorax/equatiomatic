#' LaTeX code for R models
#'
#' Extract the variable names from a model to produce a LaTeX equation, which is
#' output to the screen. Supports any model supported by
#' [broom::tidy][broom::tidy].
#'
#' @param model A fitted model
#' @param preview Logical, defaults to \code{FALSE}. Should the equation be
#'   previewed in the viewer pane?
#' @param ital_vars Logical, defaults to \code{FALSE}. Should the variable names
#'   not be wrapped in the \code{\\text{}} command?
#' @param wrap Logical, defaults to \code{FALSE}. Should the equation be
#'   inserted in a special \code{aligned} TeX environment and automatically
#'   wrapped to a specific width?
#' @param width Integer, defaults to 120. The suggested number of characters per
#'   line in the wrapped equation. Used only when \code{aligned} is \code{TRUE}.
#' @param align_env TeX environment to wrap around equation. Must be one of
#'   \code{aligned}, \code{aligned*}, \code{align}, or \code{align*}. Defaults
#'   to \code{aligned}.
#' @param use_coefs Logical, defaults to \code{FALSE}. Should the actual model
#'   estimates be included in the equation instead of math symbols?
#' @param coef_digits Integer, defaults to 2. The number of decimal places to
#'   round to when displaying model estimates.
#' @param fix_signs Logical, defaults to \code{FALSE}. If disabled,
#'   coefficient estimates that are negative are preceded with a "+" (e.g. 5(x)
#'   + -3(z)). If enabled, the "+ -" is replaced with a "-" (e.g. 5(x) - 3(z)).
#' @param \dots arguments passed to [texPreview::tex_preview][texPreview::tex_preview]
#' @export
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
#' extract_eq(mod2, wrap = TRUE, width = 150)
#'
#' # Include model estimates instead of Greek letters
#' extract_eq(mod2, wrap = TRUE, use_coefs = TRUE)
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

extract_eq <- function(model, preview = FALSE, ital_vars = FALSE,
                       wrap = FALSE, width = 120, align_env = "aligned",
                       use_coefs = FALSE, coef_digits = 2, fix_signs = TRUE) {

  lhs <- extract_lhs(model, ital_vars)
  rhs <- extract_rhs(model)

  eq <- create_eq(lhs,
                  rhs,
                  ital_vars,
                  use_coefs,
                  coef_digits,
                  fix_signs,
                  model)

  if(wrap) {
    eq <- wrap(eq, width, align_env)
  }
  if (preview) {
    preview(eq)
  }
  cat("$$\n", eq, "\n$$")
  invisible(eq)
}


#' wraps the full equation
#' @keywords internal
wrap <- function(full_eq, width, align_env) {
  eq <- gsub(" = ", " =& ", full_eq)
  eq_wrapped <- strwrap(eq, width = width, prefix = "& ", initial = "")
  paste0("\\begin{", align_env, "}\n",
         paste(eq_wrapped, collapse = " \\\\\n"),
         "\n\\end{", align_env, "}")
}


#' Preview equation
#'
#' Use [texPreview::tex_preview][texPreview::tex_preview] to preview the final
#' equation.
#'
#' @keywords internal
#'
#' @param eq LaTeX equation built with \code{create_eq}

preview <- function(eq) {
  if (!requireNamespace("texPreview", quietly = TRUE)) {
    stop("Package \"{texPreview}\" needed for preview functionality. Please install with `install.packages(\"texPreview\")`",
         call. = FALSE)
  }
  texPreview::tex_preview(paste0("$$\n", eq, "\n$$"))
}
