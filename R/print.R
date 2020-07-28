#' Print LaTeX equations
#'
#' Print LaTeX equations built with \code{\link{extract_eq}}.
#'
#' @export
#'
#' @param x LaTeX equation built with \code{\link{extract_eq}}
#' @param ... not used
#'

print.equation <- function(x, ...) {
  	cat("$$\n", x, "\n$$", sep = "")
}

