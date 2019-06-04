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

  eq <- create_eq(lhs, rhs, ital_vars, use_coefs, coef_digits, fix_signs)

  if(wrap) {
    eq <- wrap(eq, width, align_env)
  }
  if (preview) {
    preview(eq)
  }
  cat("$$\n", eq, "\n$$")
  invisible(eq)
}


#' Extract left-hand side
#'
#' Extract a string of the outcome/dependent/y variable of a model
#'
#' @keywords internal
#'
#' @inheritParams extract_eq
#'
#' @return A character string

extract_lhs <- function(model, ital_vars) {
  lhs <- all.vars(formula(model))[1]

  add_tex_ital_v(lhs, ital_vars)
}


#' Detect if a given term is part of a vector of full terms
#'
#' @keywords internal
#'
#' @param full_term The full name of a single term, e.g.,
#'   \code{"partyidOther party"}
#' @param primary_term_v A vector of primary terms, e.g., \code{"partyid"}.
#'   Usually the result of \code{formula_rhs[!grepl(":", formula_rhs)]}
#'
#' @return A logical vector the same length of \code{primary_term_v} indicating
#'   whether the \code{full_term} is part of the given \code{primary_term_v}
#'   element
#'
#' @examples \dontrun{
#' detect_primary("partyidStrong republican", c("partyid", "age", "race"))
#' detect_primary("age", c("partyid", "age", "race"))
#' detect_primary("raceBlack", c("partyid", "age", "race"))
#' }

detect_primary <- function(full_term, primary_term_v) {
  vapply(primary_term_v, function(indiv_term) {
    grepl(indiv_term, full_term)
  },
  logical(1)
  )
}


#' Extract the primary terms from all terms
#'
#' @inheritParams detect_primary
#'
#' @keywords internal
#'
#' @param all_terms A list of all the equation terms on the right hand side,
#'   usually the result of \code{broom::tidy(model, quick = TRUE)$term}.
#' @examples \dontrun{
#' primaries <- c("partyid", "age", "race")
#'
#' full_terms <- c("partyidDon't know", "partyidOther party", "age",
#' "partyidNot str democrat", "age", "raceBlack", "age", "raceBlack")
#'
#' extract_primary_term(primaries, full_terms)
#' }

extract_primary_term <- function(primary_term_v, all_terms) {
  detected <- lapply(all_terms, detect_primary, primary_term_v)
  lapply(detected, function(pull) primary_term_v[pull])
}


#' Extract the subscripts from a given term
#'
#' @keywords internal
#'
#' @param primary A single primary term, e.g., \code{"partyid"}
#' @param full_term_v A vector of full terms, e.g.,
#'   \code{c("partyidDon't know", "partyidOther party"}. Can be of length 1.
#' @examples \dontrun{
#' extract_subscripts("partyid", "partyidDon't know")
#' extract_subscripts("partyid",
#'                    c("partyidDon't know", "partyidOther party",
#'                      "partyidNot str democrat"))
#' }

extract_subscripts <- function(primary, full_term_v) {
  out <- switch(as.character(length(primary)),
                "0" = "",
                "1" = gsub(primary, "", full_term_v),
                mapply_chr(function(x, y) gsub(x, "", y),
                           x = primary,
                           y = full_term_v)
  )
  out
}


#' Extract all subscripts
#'
#' @keywords internal
#'
#' @param primary_list A list of primary terms
#' @param full_term_list A list of full terms
#'
#' @return A list with the subscripts. If full term has no subscript,
#' returns \code{""}.
#'
#' @examples \dontrun{
#' p_list <- list("partyid",
#'                c("partyid", "age"),
#'                c("age", "race"),
#'                c("partyid", "age", "race"))
#'
#' ft_list <- list("partyidNot str republican",
#'                 c("partyidInd,near dem", "age"),
#'                 c("age", "raceBlack"),
#'                 c("partyidInd,near dem", "age", "raceBlack"))
#'
#' extract_all_subscripts(p_list, ft_list)
#' }

extract_all_subscripts <- function(primary_list, full_term_list) {
  Map(extract_subscripts, primary_list, full_term_list)
}


#' Extract right-hand side
#'
#' Extract a data frame with list columns for the primary terms and subscripts
#' from all terms in the model
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
#' extract_rhs(mod1)
#' #> # A tibble: 7 x 4
#' #>   term                             estimate primary   subscripts
#' #>   <chr>                               <dbl> <list>    <list>
#' #> 1 (Intercept)                     2.925732  <chr [0]> <chr [1]>
#' #> 2 Sepal.Width                     0.4500064 <chr [1]> <chr [1]>
#' #> 3 Speciesversicolor              -1.047170  <chr [1]> <chr [1]>
#' #> 4 Speciesvirginica               -2.618888  <chr [1]> <chr [1]>
#' #> 5 Petal.Length                    0.3677469 <chr [1]> <chr [1]>
#' #> 6 Speciesversicolor:Petal.Length  0.2920936 <chr [2]> <chr [2]>
#' #> 7 Speciesvirginica:Petal.Length   0.5225336 <chr [2]> <chr [2]>
#'
#' str(extract_rhs(mod1))
#' #> Classes ‘tbl_df’, ‘tbl’ and 'data.frame': 7 obs. of  4 variables:
#' #>  $ term      : chr  "(Intercept)" "Sepal.Width" "Speciesversicolor" "Speciesvirginica" ...
#' #> $ estimate  : num  2.926 0.45 -1.047 -2.619 0.368 ...
#' #> $ primary   :List of 7
#' #>  ..$ : chr
#' #>  ..$ : chr "Sepal.Width"
#' #>  ..$ : chr "Species"
#' #>  ..$ : chr "Species"
#' #>  ..$ : chr "Petal.Length"
#' #>  ..$ : chr  "Species" "Petal.Length"
#' #>  ..$ : chr  "Species" "Petal.Length"
#' #> $ subscripts:List of 7
#' #>  ..$ : chr ""
#' #>  ..$ : chr ""
#' #>  ..$ : chr "versicolor"
#' #>  ..$ : chr "virginica"
#' #>  ..$ : chr ""
#' #>  ..$ : Named chr  "versicolor:Petal.Length" "Speciesversicolor:"
#' #>  .. ..- attr(*, "names")= chr  "Species" "Petal.Length"
#' #>  ..$ : Named chr  "virginica:Petal.Length" "Speciesvirginica:"
#' #>  .. ..- attr(*, "names")= chr  "Species" "Petal.Length"
#' }

extract_rhs <- function(model) {
  # Extract RHS from formula
  formula_rhs <- labels(terms(formula(model)))

  # Extract unique (primary) terms from formula (no interactions)
  formula_rhs_terms <- formula_rhs[!grepl(":", formula_rhs)]

  # Extract coefficient names and values from model
  full_rhs <- broom::tidy(model, quick = TRUE)

  # Split interactions split into character vectors
  full_rhs$split <- strsplit(full_rhs$term, ":")

  full_rhs$primary <- extract_primary_term(formula_rhs_terms,
                                           full_rhs$term)

  full_rhs$subscripts <- extract_all_subscripts(full_rhs$primary,
                                                full_rhs$split)
  full_rhs
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


#' Intermediary function to wrap text in "\\beta_{}"
#'
#' @keywords internal

add_betas <- function(terms, nums) {
  paste0("\\beta_{", nums,"}",
         "(", terms, ")"
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

create_eq <- function(lhs, rhs, ital_vars, use_coefs, coef_digits, fix_signs) {
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
