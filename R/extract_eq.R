#' LaTeX code for R models
#'
#' Extract the variable names from a model to produce a LaTeX equation, which is
#' output to the screen. Supports any model supported by
#' \code{broom::\link[broom]{tidy}}.
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
#'
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
#' # Preview the equation
#' extract_eq(mod4, preview = TRUE)
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
#' # Use other model types, like glm
#' set.seed(8675309)
#' d <- data.frame(out = sample(0:1, 100, replace = TRUE),
#'                 cat1 = rep(letters[1:3], 100),
#'                 cat2 = rep(LETTERS[1:3], each = 100),
#'                 cont1 = rnorm(300, 100, 1),
#'                 cont2 = rnorm(300, 50, 5))
#' mod5 <- glm(out ~ ., data = d, family = binomial(link = "logit"))
#' extract_eq(mod5, wrap = TRUE)
#'
extract_eq <- function(model, preview = FALSE, ital_vars = FALSE, wrap = FALSE,
                       width = 120, align_env = "aligned") {
  lhs <- extract_lhs(model)
  rhs <- extract_rhs(model)

  eq <- build_tex(lhs, rhs, ital_vars, wrap, width, align_env)

  if (preview) {
    if (!requireNamespace("texPreview", quietly = TRUE)) {
      stop("Package \"{texPreview}\" needed for preview functionality. Please install with `install.packages(\"texPreview\")`",
           call. = FALSE)
    }
    return(texPreview::tex_preview(eq))
  }

  cat(eq)
}


#' Extract left-hand side
#'
#' Extract a string of the outcome/dependent/y variable of a model
#'
#' @keywords internal
#'
#' @param model A fitted model
#'
#' @return A character string
#'
extract_lhs <- function(model) {
  lhs <- all.vars(formula(model))[1]

  return(lhs)
}


#' Extract right-hand side
#'
#' Extract a nested list of the explanatory/independent/x variables of a model
#'
#' @keywords internal
#'
#' @param model A fitted model
#'
#' @return A list with one element per future equation term. Term components
#'   like subscripts are nested inside each list element. List elements with two
#'   or more terms are interactions.
#'
#' @examples \dontrun{
#' mod1 <- lm(Sepal.Length ~ Sepal.Width + Species * Petal.Length, iris)
#'
#' str(extract_rhs(mod1))
#' #> List of 6
#' #>  $ Sepal.Width                   :List of 1
#' #>   ..$ :List of 1
#' #>   .. ..$ term: chr "Sepal.Width"
#' #>  $ Speciesversicolor             :List of 1
#' #>   ..$ :List of 2
#' #>   .. ..$ term     : chr "Species"
#' #>   .. ..$ subscript: chr "versicolor"
#' #>  $ Speciesvirginica              :List of 1
#' #>   ..$ :List of 2
#' #>   .. ..$ term     : chr "Species"
#' #>   .. ..$ subscript: chr "virginica"
#' #>  $ Petal.Length                  :List of 1
#' #>   ..$ :List of 1
#' #>   .. ..$ term: chr "Petal.Length"
#' #>  $ Speciesversicolor:Petal.Length:List of 2
#' #>   ..$ :List of 2
#' #>   .. ..$ term     : chr "Species"
#' #>   .. ..$ subscript: chr "versicolor"
#' #>   ..$ :List of 1
#' #>   .. ..$ term: chr "Petal.Length"
#' #>  $ Speciesvirginica:Petal.Length :List of 2
#' #>   ..$ :List of 2
#' #>   .. ..$ term     : chr "Species"
#' #>   .. ..$ subscript: chr "virginica"
#' #>   ..$ :List of 1
#' #>   .. ..$ term: chr "Petal.Length"
#' }
extract_rhs <- function(model) {
  # Extract RHS from formula
  formula_rhs <- labels(terms(formula(model)))  # RHS in formula

  # Extract unique terms from formula (no interactions)
  formula_rhs_terms <- formula_rhs[!grepl(":", formula_rhs)]

  # Extract coefficients from model
  full_rhs_raw <- broom::tidy(model, quick = TRUE)$term

  # Remove intercept (since some models might be intercept-less and we don't
  # want to automatically remove the first element with full_rhs[-1])
  full_rhs <- full_rhs_raw[!grepl("(Intercept)", full_rhs_raw)]

  # Make a list of all terms, with interactions split into character vectors
  split_rhs <- sapply(full_rhs, function(x) strsplit(x, ":"))

  # Build list of all model terms, subscripts, and interactions
  rhs <- lapply(split_rhs, function(eq_term) {
    sapply(eq_term, function(single_term) {
      # Check if an overarching term (e.g. "Species") is at the beginning of an
      # existing term (e.g. "Speciesversicolor"). If so, separate the combined
      # term into term and subscript elements
      extracted <- sapply(formula_rhs_terms, function(possible_term) {
        if (grepl(paste0("^", possible_term, "."), single_term)) {
          list(term = possible_term,
               subscript = gsub(possible_term, "", single_term))
        }
      }, USE.NAMES = FALSE)

      # Remove all NULLs from extracted
      extracted[sapply(extracted, is.null)] <- NULL

      # Return extracted pieces
      if (length(extracted) == 0) {
        list(list(term = single_term))
      } else {
        list(extracted[[1]])
      }
    }, USE.NAMES = FALSE)

  })

  return(rhs)
}


#' TeXify an equation term
#'
#' Prepare an equation term for TeX, wrapping the text with \code{\\text{}}
#' if necessary
#'
#' @keywords internal
#'
#' @param term A character string to TeXify
#' @param ital_vars Passed from \code{extract_eq}
#'
#' @return A character string

texify_term <- function(term, ital_vars) {
  if (ital_vars) {
    out <- term
  } else {
    out <- paste0("\\text{", term, "}")
  }

  return(out)
}


#' Build a complete TeX equation
#'
#' Combine the left-hand and right-hand sides of a model, wrap them with TeX
#' commands, and combine them into a single equation
#'
#' @keywords internal
#'
#' @param lhs Left-hand side of the equation; character; comes from
#'   \code{extract_lhs}
#' @param rhs Right-hand side of the equation; list with nested elements; comes
#'   from \code{extract_rhs}
#' @param ital_vars Passed from \code{extract_eq}
#' @param wrap Passed from \code{extract_eq}
#' @param width Passed from \code{extract_eq}
#' @param align_env Passed from \code{extract_eq}
#'
#' @return A character string
#'
build_tex <- function(lhs, rhs, ital_vars = ital_vars, wrap = wrap,
                      width = width, align_env = align_env) {
  lhs <- texify_term(lhs, ital_vars)

  # Convert each equation element to TeX, adding subscripts and \text{}s where needed
  texified_terms <- sapply(rhs, function(eq_term) {
    sapply(eq_term, function(term_elements) {

      if (exists("subscript", where = term_elements)) {
        out <- paste0(texify_term(term_elements[["term"]], ital_vars = ital_vars),
                      "_{",
                      texify_term(term_elements[["subscript"]], ital_vars = ital_vars),
                      "}")
      } else {
        out <- texify_term(term_elements[["term"]], ital_vars = ital_vars)
      }

      out
    })
  })

  # If any of the texified terms are length > 1, they're interaction terms and
  # need to be joined by \times
  with_interactions <- sapply(texified_terms, function(x) {
    paste(x, collapse = " \\times ")
  })

  # Create vector of subscripted betas
  betas <- paste0("\\beta_{", seq_along(with_interactions), "}")

  # Add betas to terms and concatenate with +s
  with_betas <- paste0(betas, "(", with_interactions, ")", collapse = " + ")

  # Create complete equation, wrapped if needed
  if (wrap) {
    full_eq <- paste0(lhs, " =& ", "\\alpha + ", with_betas, " + \\epsilon")

    # Wrap equation
    eq_wrapped <- strwrap(full_eq, width = width, prefix = "& ", initial = "")

    # Build aligned environment
    eq <- paste0("$$\n",
                 "\\begin{", align_env, "}\n",
                 paste(eq_wrapped, collapse = " \\\\\n"),
                 "\n\\end{", align_env, "}",
                 "\n$$")
  } else {
    full_eq <- paste0(lhs, " = ", "\\alpha + ", with_betas, " + \\epsilon")

    eq <- paste("$$\n", full_eq, "\n$$")
  }

  return(eq)
}
