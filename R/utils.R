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
#' @noRd
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

distinct <- function(df, col) {
  df[!duplicated(df[col]), ]
}

colorize <- function(col, x) {
  if(is.null(col)) {
    return(x)
  }
  paste0("{\\color{", col, "}{", x, "}}")
}

is_html_colorcode <- function(cols) {
  grepl("^#", cols)
}

strip_html_hash <- function(cols) {
  is_hex <- is_html_colorcode(cols)
  cols[is_hex] <- gsub("^#(.+)", "\\1", cols[is_hex])
  cols
}

define_latex_html_colors <- function(cols) {
  nms <- strip_html_hash(cols)
  nms <- nms[is_html_colorcode(cols)]
  vapply(nms, function(x) {
    paste0("\\definecolor{", x, "}{HTML}{", x, "}")
  }, FUN.VALUE = character(1))
}

