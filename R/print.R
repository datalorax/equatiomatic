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
  if(length(x) > 1) {
  	cat("$$\n", paste0(x, collapse = " \\\\ "), "\n$$", sep = "")
  }
  else {
  	cat("$$\n", x, "\n$$", sep = "")
  }
}

