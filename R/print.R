#' Print 'LaTeX' equations
#' 
#' lifecycle::badge("stable")`
#' 
#' Print 'LaTeX' equations built with \code{\link{extract_eq}}.
#'
#' @export
#'
#' @param x 'LaTeX' equation built with \code{\link{extract_eq}}
#' @param ... not used
#'

print.equation <- function(x, ...) {
  cat(format(x), sep = "")
}

#' Print 'LaTeX' equations in Rmarkdown environments
#'
#' Print 'LaTeX' equations built with \code{\link{extract_eq}} nicely in Rmarkdown environments.
#'
#' @keywords internal
#' @export
#'
#' @param x 'LaTeX' equation built with \code{\link{extract_eq}}
#' @param ... not used
#'
#' @method knit_print equation
#'
#' @importFrom knitr knit_print asis_output
#' @noRd
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


#' format 'LaTeX' equations
#'
#' format 'LaTeX' equations built with \code{\link{extract_eq}}.
#'
#' @export
#'
#' @param x 'LaTeX' equation built with \code{\link{extract_eq}}
#' @param ... not used
#' @noRd
format.equation <- function(x, ...) {
  if (is_latex_output()) {
    header <- paste0(attr(x, "latex_define_colors"), collapse = "\n")
    eq <- paste0(c("\n\n\\begin{equation}\n", x, "\n\\end{equation}"))
    paste0(c(header, eq))
  } else {
    paste0(c("$$\n", x, "\n$$\n"), collapse = "")
  }
}
