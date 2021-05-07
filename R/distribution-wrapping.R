#' Utility function to wrap things as normally distributed
#' @keywords internal
#' @param mean The LaTeX code that should go into the mean part
#' @param sigma The LaTeX code that should go into the variance part.
#'   Defaults to sigma squared
#' @noRd
wrap_normal_dist <- function(mean, sigma = "\\sigma^2") {
  paste0("N \\left(", mean, ", ", sigma, " \\right)")
}

wrap_binomial_dist <- function(p, n = 1) {
  paste0("\\operatorname{Binomial}(n = ", n, ", ", p, " = \\widehat{P})")
}

create_logit <- function() {
  "\\log\\left[\\frac{\\hat{P}}{1 - \\hat{P}} \\right]"
}

create_poisson_dist <- function() {
  paste0("\\operatorname{Poisson}(\\lambda_i)")
}





#### Helpers for distributions

#' For glmer models, check which family was used
which_family <- function(model) {
  model@resp$family$family
}

which_link <- function(model) {
  model@resp$family$link
}

#' Check if a glmer model uses an offset
is_exposure_modeled <- function(model) {
  all(model@resp$offset != 0)
}
