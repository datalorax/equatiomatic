#' Get a 'LaTeX' equation from a model or from 'LaTeX' code in a R Markdown or Quarto document
#'
#' @description
#' Extract or create a 'LaTeX' equation to describe a model, or directly from
#' 'LaTeX' code. All objects supported by [extract_eq()] are also supported by
#' the default method description. If labels (and units) are defined as
#' attributes to the data, they are automatically used in the equation in place
#' of the variable names.
#' @param object An object with a model whose the equation is constructed. If a
#'   **character** object is provided, it is concatenated into a single
#'   character string and the **equation** class, otherwise it is not
#'   transformed (it is supposed to be a valid 'LaTeX' equation). Remember that
#'   backslashes must be doubled in regular R strings, or use the `r"(...)"`
#'   notation, which may be more comfortable here, see examples.
#' @param ... Further parameters passed to [extract_eq()].
#'
#' @return An object of class `c("equation", "character")`.
#' @export
#'
#' @details
#' There are slight differences between `equation()`, `eq_()` and `eq__()`:
#' * `equation()` returns a string with 'LaTeX' code and prints 'LaTeX' code at
#'    the R console.
#' * `eq_()` returns the 'LaTeX' code surrounded by a dollar sign `$...$` and is
#'    suitable to build inline equations in R Markdown/Quarto documents by using
#'    inline R code. It prints the rendered inline equation in the RStudio
#'    Viewer or in the browser. So it is advised to rapidly preview the
#'    resulting equation.
#' * `eq__()` returns the 'LaTeX' code _not_ surrounded by dollar signs in a
#'    single character string. It also prints the rendered inline equation in
#'    the RStudio Viewer or in the browser.
#'    It should be used in an R inline chunk inside a `$$...$$`
#'    construct in a Markdown text. The result is a display equation that can
#'    also be cross referenced in Quarto in the usual way if you label it, e.g.,
#'    you use `$$...$$ {#eq-label}`.
#'
#' @examples
#' iris_lm <- lm(data = iris, Petal.Length ~ Sepal.Length + Species)
#' summary(iris_lm)
#' equation(iris_lm)
#' # Providing directly the LaTeX code of the equation (variance of a sample)
#' equation("S^2_y = \\sum_{i=1}^{n-1} \\frac{(y_i - \\bar{Y})^2}{n}")
#' # Easier to write like this (avoiding the double backslashes):
#' eq1 <- equation(r"(S^2_y = \sum_{i=1}^{n-1} \frac{(y_i - \bar{Y})^2}{n})")
#' # Print raw text:
#' eq1
#' # Get a preview of the equation
#' eq__(eq1)
#' # The same function can be used inside a `$$...$$ {#eq-label}` construct in
#' # R Markdown or Quarto to calcule a display equation that is also recognized
#' # by the cross referencing system of Quarto.
#' # Get a string suitable for inclusion inline in R Markdown with `r eq__(eq1)`
#' # (inside Markdown text and without the dollar signs around it)
#' # For inline equations in a Markdown text, you are better to use `r eq_(eq1)`
#' eq_(eq1)
equation <- function(object, ...) {
  UseMethod("equation")
}

#' @rdname equation
#' @export
#' @method equation default
#' @param auto.labs If `TRUE` (by default), use labels (and units) automatically
#'   from data or `origdata=`.
#' @param origdata The original data set this model was fitted to. By default it
#'   is `NULL` and no label is used.
#' @param labs Labels to change the names of elements in the `term` column of
#'   the table. By default it is `NULL` and no term is changed.
#' @param swap_var_names Change the variable names for these values, regardless
#'   of the values in `auto.labs=` or `labs=` that are ignored if this argument
#'   is used. Provide a named character string with name being the variables and
#'   strings the new names. You can use `^` or `_` to indicate next character,
#'   or next integer should be super- or subscript in the equation.
equation.default <- function(object, auto.labs = TRUE, origdata = NULL,
    labs = NULL, swap_var_names = NULL, ...) {
  # Extract labels off data or origdata
  if (missing(swap_var_names)) {
    if (isTRUE(auto.labs)) {
      labs <- try(.labels2(x = object, origdata = origdata, labs = labs),
        silent = TRUE)
      if (inherits(labs, "try-error")) {
        #warning("Cannot extract labels from the object")
        labs <- NULL
      }
    } else {
      labs <- .labels2(x = NULL, labs = labs)
    }
    if (!is.null(labs)) {
      res <- extract_eq(model = object, swap_var_names =  labs, ...)
    } else {
      res <- extract_eq(model = object, ...)
    }
  } else {# swap_var_names provided
    res <- extract_eq(model = object, swap_var_names =  swap_var_names, ...)
  }
  
  # In case we use ^ or _, we mean "put next character in super or subscript"
  # but equatiomatic tries hard to preserve the character in LaTeX
  # -> make the correction now
  # Restore ^ for superscript
  res <- gsub("\\texttt{\\^{}}", "^", res, fixed = TRUE)
  res <- gsub("\\texttt{^}", "^", res, fixed = TRUE)
  # Transform the result from ~ into _ (LaTeX subscript)
  res <- gsub("\\_", "_", res, fixed = TRUE)
  # Make sure all digits (and leading minus sign are super- or subscript)
  res <- gsub("([\\^_])(-?[0-9]+)", "\\1{\\2}", res)
  
  # If it appears there is a beta_1 term, but no beta_0 or beta_2 terms, just-
  # rename it beta
  if (grepl("\\beta_{1}", res, fixed = TRUE) &&
      !grepl("\\beta_{0}", res, fixed = TRUE) &&
      !grepl("\\beta_{2}", res, fixed = TRUE)) {
    res <- gsub("\\beta_{1}", "\\beta_{}", res, fixed = TRUE)
  }
  
  res
}

#' @rdname equation
#' @export
#' @method equation character
equation.character <- function(object, ...) {
  eq <- paste(object, collapse = "\n")
  class(eq) <- c("equation", "character")
  eq
}

#' @rdname equation
#' @export
eq__ <- function(object, ...) {
  eq <-  equation(object, ...)
  class(eq) <- c("inline_equation", "character")
  eq
}

#' @rdname equation
#' @export
eq_ <- function(object, ...) {
  eq <-  equation(object, ...)
  eq <- paste0("$", paste(eq, collapse = "\n"), "$")
  class(eq) <- c("inline_equation", "character")
  eq
}

#' @rdname equation
#' @export
#' @method print inline_equation
#' @param x An **inline_equation** object generated by `eq_()` or `eq__()`.
print.inline_equation <- function(x, ...) {
  if (grepl("^\\$.+\\$$", x)) {
    eq <- substring(x, 2L, nchar(x) - 1L)
  } else {
    eq <- x
  }
  eq <- structure(gsub("\n", " ", eq), class = c("equation", "character"))
  preview_eq(eq)
  invisible(x)
}

.labels <- function(x, units = TRUE, ...) {
  
  .get_label_with_units <- function(x, units = TRUE) {
    lab <- attr(x, "label")
    if (is.null(lab))
      return("")

    if (isTRUE(units)) {
      un <- attr(x, "units")
      if (!is.null(un))
        lab <- paste0(lab, " [", un, "]")
    }
    lab
  }
  
  labels <- sapply(x, .get_label_with_units, units = units)
  
  if (any(labels != "")) {
    # Use a \n before labels and the units
    if (isTRUE(units))
      labels <- sub(" +\\[([^]]+)\\]$", "\n [\\1]", labels)
    # set names if empty
    labels[labels == ""] <- names(x)[labels == ""]
    # Specific case for I() using in a formula
    for (i in seq_along(labels)) {
      # check if I() includes an exponent.
      if (grepl("^I\\(.*\\^.*\\)$", names(labels)[i])) {
        # extract the exponent of I()
        vec <- sub("^I\\(.*(\\^.*)\\).*", "\\1", names(labels)[i])
        
        if(isTRUE(units)) {
          # vec[i] <- sub(" \\n", paste0(sous_chaine, "\\\n"), vec[i])
          labels[i] <- gsub("(.*)(\\n \\[)(.*)(\\])",
            paste0("\\1", vec, "\\2", "\\3", vec,"\\4"), labels[i])
        } else {
          labels[i] <- paste0(labels[i], vec)
        }
      }
    }
    labels[grepl("^I\\(([^\\^]*)\\)$", names(labels))] <- names(labels)[
      grepl("^I\\(([^\\^]*)\\)$", names(labels))]
  }
  
  if (all(labels == ""))
    labels <- NULL
  
  labels
}

.labels2 <- function(x, origdata = NULL, labs = NULL) {
  
  if (is.null(origdata)) {
    labs_auto <- .labels(x$model)
  } else {
    labs_auto <- .labels(origdata)
  }
  
  if (!is.null(labs)) {
    if (!is.character(labs))
      stop("labs is not character vector")
    if (is.null(names(labs)))
      stop("labs must be named character vector")
    if (any(names(labs) %in% ""))
      stop("all element must be named")
    labs_res <- c(labs, labs_auto[!names(labs_auto) %in% names(labs)])
  } else {
    labs_res <- labs_auto
  }
  
  labs_res
}
