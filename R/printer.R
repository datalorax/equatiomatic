# Create complete equation, wrapped if needed
eq_wrap <- function(eq, width = Inf){

  if(is.infinite(width))
    return(eq)

  eq <- gsub('=','&=',eq)

  eq_wrapped <- strwrap(eq, width = width, prefix = "  & ", initial = "")

  paste(eq_wrapped, collapse = " \\\\\n")

}

#' Print equation
#'
#' Print method for tex class
#'
#' @param x LaTeX equation built with \code{build_tex}
#' @param \dots arguments that control equation wrap width and equation environment
#'  see details
#' @details arguments that can be passed in the \dots
#'
#' width: Controls the width of the equation, if this is set the the equation is aligned
#'
#' template: the type of environment that the equation is wrapped in, e.g. $, $$ , align, equation
#'
#'@export
#'@rdname print.tex
#'@aliases print
print.tex <- function(x,...){

  template <- NULL
  width <- NULL

  dots <- list(...)

  if(is.null(dots$template))
    dots$template <- '$$'

  if(is.null(dots$width))
    dots$width <- Inf

  list2env(dots,envir = environment())

  x <- eq_wrap(x,width)

  dbookend <- sprintf('%s\n%%s\n%s',template,template)
  bookend <- sprintf('\\begin{%s}\n%%s\n\\end{%s}',template,template)
  core <- sprintf('  %s',x)

  if(grepl('\\$',template)){
    ret <- sprintf(dbookend,core)
  }else{
    ret <- sprintf(bookend,core)
  }

  cat(ret)
}

#' Preview equation
#'
#' Use [texPreview::tex_preview][texPreview::tex_preview] to preview the final
#' equation.
#'
#' @param x LaTeX equation built with \code{build_tex}
#' @param \dots arguments passed to [texPreview::tex_preview][texPreview::tex_preview]
#' @details To use this method \code{texPreview} must be installed.
#' @rdname preview
#' @export
preview <- function(x,...){
  UseMethod('preview')
}

#' @export
#' @rdname preview
preview.tex <- function(x,...) {
  if (!requireNamespace("texPreview", quietly = TRUE)) {
    stop("Package \"{texPreview}\" needed for preview functionality. Please install with `install.packages(\"texPreview\")`",
         call. = FALSE)
  }
  return(texPreview::tex_preview(sprintf('$$\n %s \n$$',x)))
}
