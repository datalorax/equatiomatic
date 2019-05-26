#' Latex code for `lm` models
#'
#' Uses the variable names supplied to \link[stats]{lm} to produce a LaTeX
#' equation, which is output to the screen.
#'
#' @param model A fitted `lm` model
#' @param preview Logical, defaults to \code{FALSE}. Should the equation be
#'   previewed in the viewer pane?
#' @param use_text Logical, defaults to \code{FALSE}. Should the variable names
#'   be wrapped in the \code{\\text{}} command?
#' @param aligned Logical, defaults to \code{FALSE}. Should the equation be
#'   inserted in a special \code{aligned} TeX environment and automatically
#'   wrapped to a specific width?
#' @param width Integer, defaults to 80. The suggested of characters per line in
#'   the split equation. Used only when \code{aligned} is \code{TRUE}
#' @param align_env TeX environment to wrap around equation. Must be one of
#'   \code{aligned}, \code{aligned*}, \code{align}, or \code{align*}. Defaults
#'   to \code{aligned}
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
#'
#' # Or preview the equation
#' extract_eq_lm(mod4, preview = TRUE)
#'
#' # Use \text{}
#' # Simple model
#' extract_eq_lm(mod1, use_text = TRUE)
#'
#' # Categorical variables
#' extract_eq_lm(mod3, use_text = TRUE)
#'
#' # Wrap equations in an "aligned" environment
#' extract_eq_lm(mod2, aligned = TRUE)
#'
#' # Wider equation wrapping
#' extract_eq_lm(mod2, aligned = TRUE, width = 100)

extract_eq_lm <- function(model, preview = FALSE, use_text = FALSE,
                          aligned = FALSE, width = 80, align_env = "aligned") {
  if (aligned & !align_env %in% c("aligned", "aligned*", "algin", "align*"))
    warning("align_env must be one of 'aligned', 'aligned*', 'align', or 'align*'")
  if (aligned & !is.numeric(width) | width <= 0)
    warning("width must be a positive integer")

  lhs  <- all.vars(formula(model))[1]

  formula_rhs <- labels(terms(formula(model)))
  full_rhs  <- colnames(model.matrix(model))[-1]

  cat_vars <- detect_categorical(formula_rhs, full_rhs)
  dummied <- add_dummy_subscripts(formula_rhs[cat_vars], full_rhs, use_text)

  if (use_text) {
    lhs <- wrap_text(lhs)

    dummied[formula_rhs[!cat_vars]] <- wrap_text(formula_rhs[!cat_vars])
  } else {
    dummied[formula_rhs[!cat_vars]] <- formula_rhs[!cat_vars]
  }

  full_rhs <- unlist(dummied[formula_rhs])

  # Construct TeX
  betas <- paste0("\\beta_{", seq_along(full_rhs), "}(")
  rhs_eq <- paste0(betas, full_rhs, ")")
  rhs_eq <- paste("\\alpha +", paste(rhs_eq, collapse = " + "))
  error <- "+ \\epsilon"

  if (aligned) {
    lhs_eq <- paste(lhs, "=& ")

    # Wrap equation
    math_wrapped <- strwrap(paste(paste0(lhs_eq, rhs_eq), error),
                            width = width, prefix = "& ", initial = "")

    # Build aligned environment
    eq <- paste0("$$\n",
                 "\\begin{", align_env, "}\n",
                 paste(math_wrapped, collapse = " \\\\\n"),
                 "\n\\end{", align_env, "}",
                 "\n$$")
  } else {
    lhs_eq <- paste(lhs, "= ")

    eq <- paste("$$\n", paste0(lhs_eq, rhs_eq), error, "\n$$")
  }

  if (preview) {
    if (!requireNamespace("texPreview", quietly = TRUE)) {
      stop("Package \"{texPreview}\" needed for preview functionality. Please install with `install.packages(\"texPreview\")`",
           call. = FALSE)
    }
    return(texPreview::tex_preview(eq))
  }

  cat(eq)
}
