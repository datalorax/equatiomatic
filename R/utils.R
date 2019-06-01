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

#' @describeIn mapply_chr Return a character vector
mapply_chr <- function(...) {
	out <- mapply(...)
	stopifnot(is.character(out))
	out
}

#' @inheritParams mapply_chr
#' @describeIn mapply_chr Return a logical vector
mapply_lgl <- function(...) {
	out <- mapply(...)
	stopifnot(is.logical(out))
	out
}

#' @inheritParams mapply_chr
#' @describeIn mapply_chr Return an integer vector
mapply_int <- function(...) {
	out <- mapply(...)
	stopifnot(is.integer(out))
	out
}

#' @inheritParams mapply_chr
#' @describeIn mapply_chr Return a double vector
mapply_dbl <- function(...) {
	out <- mapply(...)
	stopifnot(is.double(out))
	out
}