#' Print LaTeX equations
#'
#' Print LaTeX equations built with \code{\link{extract_eq}}.
#'
#' @export
#'
#' @param eq LaTeX equation built with \code{\link{extract_eq}}
#' @param ... not used
#'

print.equation <- function(eq, ...) {
  cat("$$\n", paste0(eq, collapse = " \\\\ "), "\n$$")
}

