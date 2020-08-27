#' Print 'LaTeX' equations
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
knit_print.equation <- function(x,...){
  knitr::asis_output(format(x))
}

#' format 'LaTeX' equations
#'
#' format 'LaTeX' equations built with \code{\link{extract_eq}}.
#'
#' @export
#'
#' @param x 'LaTeX' equation built with \code{\link{extract_eq}}
#' @param ... not used
#'
format.equation <- function(x, ...) {
  paste0(c("$$\n", x, "\n$$"), collapse = "")
}
