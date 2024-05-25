#' Print 'LaTeX' equations
#' 
#' Print 'LaTeX' equations built with \code{\link{extract_eq}}.
#'
#' @method print equation
#' @export
#'
#' @param x 'LaTeX' equation built with \code{\link{extract_eq}}
#' @param ... not used
#' @return The unmodified object 'x' is returned invisibly. The function is
#'   used for its side effect of printing the equation.

print.equation <- function(x, ...) {
  cat(format(x), sep = "")
  invisible(x)
}

#' Print 'LaTeX' equations in R Markdown environments
#'
#' Print 'LaTeX' equations built with \code{\link{extract_eq}} nicely in R Markdown environments.
#'
#' @method knit_print equation
#' @export
#'
#' @param x 'LaTeX' equation built with \code{\link{extract_eq}}
#' @param ... not used
#' @param tex_packages A string with LaTeX code to include in the header,
#'   usually to include LaTeX packages in the output.
#' 
#' @return A string with the equation formatted according to R Markdown's output
#'   format (different output for HTML, PDF, docx, gfm, markdown_strict). The
#'   format is detected automatically, so, you do not have to worry about it.
#'
#' @importFrom knitr knit_print asis_output
#'
knit_print.equation <- function(x, ..., tex_packages = "\\renewcommand*\\familydefault{\\rmdefault}") {
  eq <- format(x)
  if (isTRUE(knitr::opts_knit$get("rmarkdown.pandoc.to") %in% c("gfm", "markdown_strict"))) {
    if (!is_texPreview_installed()) {
      message(
        paste(
          "Please install \"{texPreview}\" with",
          "`install.packages(\"texPreview\")` for equations to render with",
          "GitHub flavored markdown. Defaulting to raw TeX code."), 
        call. = FALSE)
      print(eq)
    } else {
      knit_print(texPreview::tex_preview(eq, usrPackages = tex_packages))
      if (knitr::opts_knit$get("rmarkdown.pandoc.to") == "markdown_strict") {
        knit_print(texPreview::tex_preview(eq,
          usrPackages = tex_packages,
          returnType = "html",
          density = 300
        ))
      }
    }
  } else {
    return(asis_output(eq))
  }
}

#' @keywords internal
#' @noRd
is_texPreview_installed <- function() {
  requireNamespace("texPreview", quietly = TRUE)
}


#' Format 'LaTeX' equations
#'
#' Format 'LaTeX' equations built with \code{\link{extract_eq}}.
#'
#' @export
#' @method format equation
#'
#' @param x 'LaTeX' equation built with \code{\link{extract_eq}}
#' @param ... not used
#' @param latex Logical, whether the output is LaTeX or not. The default
#'   value uses [knitr::is_latex_output()] to determine the current output format.
#' @return A character string with the equation formatted either as proper
#'   LaTeX code, or as a display equation tag (surrounded by `$$...$$`) for R
#'   Markdown or Quarto documents.
#'
format.equation <- function(x, ..., latex = knitr::is_latex_output()) {
  if (isTRUE(latex)) {
    header <- paste0(attr(x, "latex_define_colors"), collapse = "\n")
    eq <- paste0(c("\n\n\\begin{equation}\n", x, "\n\\end{equation}"))
    paste0(c(header, eq))
  } else {
    paste0(c("$$\n", x, "\n$$\n"), collapse = "")
  }
}
