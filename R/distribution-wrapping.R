#' Utility function to wrap things as normally distributed
#' @keywords internal
#' @param mean The LaTeX code that should go into the mean part
#' @param sigma The LaTeX code that should go into the variance part.
#'   Defaults to sigma squared
#' @noRd
wrap_normal_dist <- function(mean, sigma = "\\sigma^2") {
  paste0("N \\left(", mean, ", ", sigma, " \\right)")
}

#' @noRd
wrap_binomial_dist <- function(p, n = 1) {
  paste0("\\operatorname{Binomial}(n = ", n, ", ", p, " = \\widehat{P})")
}

#' @noRd
create_logit <- function() {
  "\\log\\left[\\frac{\\hat{P}}{1 - \\hat{P}} \\right]"
}

#' @noRd
create_poisson_dist <- function() {
  paste0("\\operatorname{Poisson}(\\lambda_i)")
}



#### Helpers for distributions

#' For glmer models, check which family was used
#' @noRd
which_family <- function(model) {
  model@resp$family$family
}

#' @noRd
which_link <- function(model) {
  model@resp$family$link
}

#' Check if a glmer model uses an offset
#' @noRd
is_exposure_modeled <- function(model) {
  all(model@resp$offset != 0)
}



### Full distribution wrapping
binomial_logit_l1 <- function(model, lhs, l1, ital_vars) {
  outcome <- escape_tex(all.vars(formula(model))[1])
  out_v <- model@frame[[outcome]]
  if (is.factor(out_v)) {
    ss <- escape_tex(levels(out_v)[2])
  } else {
    ss <- 1
  }
  
  p <- paste0(
    "\\operatorname{prob}",
    add_tex_subscripts(
      paste0(
        add_tex_ital_v(outcome, ital_vars), " = ",
        ifelse(grepl("\\d", ss), ss, add_tex_ital_v(ss, ital_vars))
      )
    )
  )
  
  out <- paste0(lhs, " \\sim ", wrap_binomial_dist(p),
                " \\\\\n    ", create_logit(), " &=", l1)
}

poisson_log_l1 <- function(lhs, l1) {
  paste0(lhs, " \\sim ", create_poisson_dist(),
         " \\\\\n    ", "\\log(\\lambda_i)", " &=", l1)
}
