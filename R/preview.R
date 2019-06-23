#' Preview LaTeX equations
#'
#' Preview LaTeX equations built with \code{\link{extract_eq}}.
#'
#' @param eq LaTeX equation built with \code{\link{extract_eq}}
#' @param \dots additional arguments passed to \code{\link[texPreview]{tex_preview}}
#'
#' @export
#'
#' @examples \dontrun{
#' # Basic preview
#' mod1 <- lm(mpg ~ cyl + disp, mtcars)
#' preview(extract_eq(mod1))
#'
#' # Pass arguments to tex_preview()
#' preview(extract_eq(mod1), density = 600)
#'
#' # Use with magrittr pipes
#' mod1 %>%
#'   preview(density = 600)
#' }

preview <- function(eq, ...) {
  UseMethod("preview")
}

#' @keywords internal
is_texPreview_installed <- function() {
  requireNamespace("texPreview", quietly = TRUE)
}

#' @export
preview.equation <- function(eq, ...) {
  if (!is_texPreview_installed()) {
    stop("Package \"{texPreview}\" needed for preview functionality. Please install with `install.packages(\"texPreview\")`", call. = FALSE)
  }

  texPreview::tex_preview(paste0("$$\n", eq, "\n$$"), ...)
}
