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
  if (isTRUE(knitr::opts_knit$get("rmarkdown.pandoc.to") %in% "markdown_strict")) {
    # Just print raw LaTeX
    print(eq)
  } else {
    return(asis_output(eq))
  }
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

#' Preview an equation in a web browser
#'
#' Preview 'LaTeX' equations built with \code{\link{extract_eq}}.
#'
#' @param x 'LaTeX' equation built with \code{\link{extract_eq}}
#' @param ... not used
#'
#' @returns The path to the temporary html file that was created to preview the
#'   equation is returned invisibly.
#' @export
#'
#' @examples
#' mod1 <- lm(mpg ~ cyl + disp, mtcars)
#' eq1 <- extract_eq(mod1)
#' eq1 # Not that nice
#' preview_eq(eq1)
#' # or easier...
#' preview_eq(mod1)
preview_eq <- function(x, ...) {
  if (!rmarkdown::pandoc_available())
    stop("Pandoc is not available. Please install it to use this function.",
      call. = FALSE)
  
  if (!inherits(x, "equation"))
    x <- extract_eq(x)
  
  rmd <- tempfile(fileext = ".Rmd")
  cat(sprintf("---\ntitle: \"&nbsp;\"\n---\n$$\n%s\n$$\n", x), file = rmd)
  rmarkdown::render(rmd, output_format = rmarkdown::html_document(...),
    quiet = TRUE)
  
  file_out <- sub("\\.Rmd$", ".html", rmd)
  viewer <- getOption("viewer", default = getOption("browser", NULL))
  if (!is.function(viewer))
    viewer <- utils::browseURL
  viewer(file_out)
  invisible(file_out)
}
