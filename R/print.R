#' Print LaTeX equations
#'
#' Print LaTeX equations built with \code{\link{extract_eq}}.
#'
#' @export
#'
#' @param eq LaTeX equation built with \code{\link{extract_eq}}
#'

print.equation <- function(eq) {
  cat("$$\n", eq, "\n$$")
}

