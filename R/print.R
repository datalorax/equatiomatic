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
#' @importFrom texPreview tex_preview
#' @noRd
#'
knit_print.equation <- function(x,...,tex_packages = "\\renewcommand*\\familydefault{\\rmdefault}"){
  eq <- format(x)
  if(isTRUE(knitr::opts_knit$get("rmarkdown.pandoc.to") == "gfm")){
    knit_print(tex_preview(eq, usrPackages = tex_packages))
  }else{
    return(knitr::asis_output(eq))
  }
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
  paste0(c("$$\n", x, "\n$$"), collapse = "")
}
