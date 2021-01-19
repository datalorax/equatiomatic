#' Simple simulated time series data
#'
#' Output from \code{set.seed(42); simple_ts <- ts(rnorm(1000),freq = 4)}.
#' This is included primarily for unit testing.
#'
#' @format A tibble with 1000 rows and 8 variables:
#' \describe{
#'   \item{Qtr1}{First quarter simulated values.}
#'   \item{Qtr2}{Second quarter simulated values.}
#'   \item{Qtr3}{Third quarter simulated values.}
#'   \item{Qtr4}{Fourth quarter simulated values.}
#' }
"simple_ts"
