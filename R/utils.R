#' Strict versions of \code{base::\link[base]{mapply}}
#'
#' Return a vector of the corresponding type
#'
#' @keywords internal
#'
#' @param \dots arguments passed to \code{base::\link[base]{mapply}}
#'
#' @return A vector of the corresponding type, \code{chr} = character,
#'   \code{dbl} = double, \code{lgl} = logical, and \code{int} = logical
#'
mapply_chr <- function(...) {
	out <- mapply(...)
	stopifnot(is.character(out))
	out
}

mapply_lgl <- function(...) {
	out <- mapply(...)
	stopifnot(is.logical(out))
	out
}

mapply_int <- function(...) {
	out <- mapply(...)
	stopifnot(is.integer(out))
	out
}

mapply_dbl <- function(...) {
	out <- mapply(...)
	stopifnot(is.double(out))
	out
}
