#' Simulated data for time-series regression
#'
#' Output from \code{set.seed(123); ts_reg_list <- list(x1 = rnorm(1000), x2 = rnorm(1000), ts_rnorm = rnorm(1000))}.
#'
#' @format A tibble with 1000 rows and 8 variables:
#' \describe{
#'   \item{x1}{Random normal simulated data.}
#'   \item{x2}{Random normal simulated data.}
#'   \item{ts_rnorm}{Random normal simulated data.}
#' }
"ts_reg_list"
