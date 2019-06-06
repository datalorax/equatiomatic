#' Generic function for extracting the left hand side from a model
#'
#' @keywords internal
#'
#' @param model A fitted model
#' @param \dots additional arguments passed to the specific extractor

 extract_lhs <- function (model, ...) {
   UseMethod("extract_lhs", model)
 }


#' Extract left-hand side of an lm object
#'
#' Extract a string of the outcome/dependent/y variable of a model
#'
#' @keywords internal
#'
#' @inheritParams extract_eq
#'
#' @return A character string

extract_lhs.lm <- function(model, ital_vars) {

  lhs <- all.vars(formula(model))[1]

  add_tex_ital_v(lhs, ital_vars)
}


#' Extract left-hand side of a glm object
#'
#' Extract a string of the outcome/dependent/y variable with the appropriate
#' link function.
#'
#' @keywords internal
#'
#' @inheritParams extract_eq
#'
#' @return A character string

extract_lhs.glm <- function(model, ital_vars) {

  lhs_lm <- extract_lhs.lm(model, ital_vars)

  modify_lhs_for_link(model, lhs_lm)
}


#' modifies lhs of equations that include a link function
#' @keywords internal
modify_lhs_for_link <- function(model, lhs) {
  if (!(model$family$link %in% link_function_df$link_name)) { # is this logical operator not ideal?
    message("This link function is not presently supported; using an identity
              function instead") # this is implicit; it's just using the lhs as-is
  } else {
    matched_row_bool <- link_function_df$link_name %in% model$family$link
    filtered_link_formula <- link_function_df[matched_row_bool, "link_formula"]
    gsub("y", lhs, filtered_link_formula, fixed = TRUE)
  }
}


# link-functions.R

link_name <- c("logit",
               'inverse',
               # '1/mu^2', # inverse gaussian; removed until we're certain
               'log',
               'identity') # this isn't necessary as extract_eq() does this by default

# not sure how to address this one: quasi(link = "identity", variance = "constant")

link_formula <- c("log\\left[ \\frac { P( y ) }{ 1 - P( y ) }  \\right]",
                  "\\frac { 1 }{ P( y ) }",
                  # "\\frac { 1 }{ 1/{ y }^{ 2 } } ", # inverse gaussian - correct?
                  "\\log ( { y )} ",
                  "y") # are the parentheses italicized here?

link_function_df <- data.frame(link_name, link_formula,
                               stringsAsFactors = FALSE)

# how to find the link function and distribution family
# counts <- c(18,17,15,20,10,20,25,13,12)
# outcome <- gl(3,1,9)
# treatment <- gl(3,3)
# print(d.AD <- data.frame(treatment, outcome, counts))
# glm.D93 <- glm(counts ~ outcome + treatment, family = poisson())
#
# glm.D93$family$link
# glm.D93$family$family
