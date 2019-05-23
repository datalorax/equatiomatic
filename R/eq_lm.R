#' Latex code for `lm` models
#'
#' Uses the variable names supplied to \link[stats]{lm} to produce a LaTeX
#' equation, which is output to the screen.
#'
#' @param model A fitted `lm` model
#'
#' @export
#' @examples
#'
#' # Simple model
#' mod1 <- lm(mpg ~ cyl + disp, mtcars)
#' extract_eq_lm(mod1)
#'
#' # Include all variables
#' mod2 <- lm(mpg ~ ., mtcars)
#' extract_eq_lm(mod2)
#'
#' # Works for categorical variables too, putting levels as subscripts
#' mod3 <- lm(Sepal.Length ~ Sepal.Width + Species, iris)
#' extract_eq_lm(mod3)
#'
#' set.seed(8675309)
#' d <- data.frame(cat1 = rep(letters[1:3], 100),
#'                 cat2 = rep(LETTERS[1:3], each = 100),
#'                 cont1 = rnorm(300, 100, 1),
#'                 cont2 = rnorm(300, 50, 5),
#'                 out   = rnorm(300, 10, 0.5))
#' mod4 <- lm(out ~., d)
#' extract_eq_lm(mod4)

extract_eq_lm <- function(model) {
  formula_rhs <- labels(terms(formula(model)))
  full_rhs  <- colnames(model.matrix(model))[-1]

  cat_vars <- detect_categorical(formula_rhs, full_rhs)
  dummied <- add_dummy_subscripts(formula_rhs[cat_vars], full_rhs)

  dummied[formula_rhs[!cat_vars]] <- formula_rhs[!cat_vars]

  full_rhs <- unlist(dummied[formula_rhs])

  lhs  <- all.vars(formula(model))[1]
  lhs_eq <- paste(lhs, "= ")

  betas <- paste0("\\beta_{", seq_along(full_rhs), "}(")
  rhs_eq <- paste0(betas, full_rhs, ")")
  rhs_eq <- paste("\\alpha +", paste(rhs_eq, collapse = " + "))
  error <- "+ \\epsilon"
  cat(
    paste("$$\n",
          paste0(lhs_eq, rhs_eq),
          error,
          "\n$$")
  )
}
