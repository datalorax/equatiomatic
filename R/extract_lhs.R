#' Generic function for extracting the left hand side from a model
#'
#' @keywords internal
#'
#' @param model A fitted model
#' @param \dots additional arguments passed to the specific extractor
#' @noRd

extract_lhs <- function(model, ...) {
  UseMethod("extract_lhs", model)
}

#' Extract left-hand side of an lm object
#'
#' Extract a string of the outcome/dependent/y variable of a model
#'
#' @export
#' @keywords internal
#'
#' @inheritParams extract_eq
#'
#' @return A character string
#' @noRd

extract_lhs.lm <- function(model, ital_vars,
                           show_distribution,
                           use_coefs, ...) {
  lhs <- rownames(attr(model$terms, "factors"))[1]

  lhs_escaped <- escape_tex(lhs)
  if (use_coefs){
  lhs_escaped <- add_hat(lhs)}
  add_tex_ital_v(lhs_escaped, ital_vars)
}

#' Extract left-hand side of an lme4::lmer object
#'
#' Extract a string of the outcome/dependent/y variable of a model
#'
#' @export
#' @keywords internal
#'
#' @inheritParams extract_eq
#'
#' @return A character string
#' @noRd
extract_lhs.lmerMod <- function(model, ital_vars, ...) {
  lhs <- all.vars(formula(model))[1]

  lhs_escaped <- escape_tex(lhs)
  paste0(add_tex_ital_v(lhs_escaped, ital_vars), "_{i}")
}

#' Extract left-hand side of a glm object
#'
#' Extract a string of the outcome/dependent/y variable with the appropriate
#' link function.
#'
#' @export
#' @keywords internal
#'
#' @inheritParams extract_eq
#'
#' @return A character string
#' @noRd

extract_lhs.glm <- function(model, ital_vars, show_distribution, use_coefs, ...) {
  if (show_distribution) {
    if (model$family$family == "binomial"){
      return(extract_lhs2_binomial(model, ital_vars, use_coefs))
    } else {
      message("This distribution is not presently supported; the distribution assumption
      will not be displayed")
      lhs <- all.vars(formula(model))[1]
      full_lhs <- paste("E(", add_tex_ital_v(lhs, ital_vars), ")")
      if (use_coefs){
        full_lhs <- add_hat(full_lhs)
      }
      full_lhs <- modify_lhs_for_link(model, full_lhs)
      class(full_lhs) <- c("character", class(model))
      return(full_lhs)
      }
  }
  if (model$family$family == "binomial"){
    return(extract_lhs_binomial(model, ital_vars, use_coefs))
    } else {
      lhs <- all.vars(formula(model))[1]
      full_lhs <- paste("E(", add_tex_ital(lhs, ital_vars), ")")
      if (use_coefs){
        full_lhs <- add_hat(full_lhs)
      }
      full_lhs <- modify_lhs_for_link(model, full_lhs)
      class(full_lhs) <- c("character", class(model))
      return(full_lhs)
    }
}

#' @return A character string
#' @keywords internal
#' @noRd

extract_lhs_binomial <- function(model, ital_vars, use_coefs){
  lhs <- all.vars(formula(model))[1]

  # This returns a 1x1 data.frame
  ss <- model$data[which(model$y == 1)[1], lhs]

  # Convert to single character
  ss <- as.character(unlist(ss))

  lhs_escaped <- escape_tex(lhs)
  ss_escaped <- escape_tex(ss)

  if (is.na(ss)) {
    full_lhs <- paste("P(", add_tex_ital_v(lhs_escaped, ital_vars), ")")
  } else {
    full_lhs <- paste("P(", add_tex_ital_v(lhs_escaped, ital_vars),
                      "=",
                      add_tex_ital_v(ss_escaped, ital_vars), ")")
  }
  if (use_coefs){
    full_lhs <- add_hat(full_lhs)
  }

  full_lhs <- modify_lhs_for_link(model, full_lhs)
  class(full_lhs) <- c("character", class(model))
  full_lhs
}

#' @keywords internal
#' @noRd
extract_lhs2_binomial <- function(model, ital_vars, ...){
  outcome <- all.vars(formula(model))[1]
  n <- unique(model$model$`(weights)`)
  if (is.null(n)) {
    n <- nrow(model$data)
  }
  if (length(n) > 1) {
    warning(paste("Unsure of how to handle a vector of weights in creation",
                  "of the distrubtion portion of the equation. Please inspect",
                  "carefully and modify by hand if neccessary.")
    )
  }

  # This returns a 1x1 data.frame
  ss <- model$data[which(model$y == 1)[1], outcome]

  # Convert to single character
  ss <- as.character(unlist(ss))

  outcome_escaped <- escape_tex(outcome)
  ss_escaped <- escape_tex(ss)

  lhs <- add_tex_ital_v(outcome_escaped, ital_vars)
  p <- paste0("\\operatorname{prob}",
              add_tex_subscripts(
                paste0(
                add_tex_ital_v(outcome_escaped, ital_vars), " = ",
                  add_tex_ital_v(ss_escaped, ital_vars)
                  )))

  rhs <- paste0("Bernoulli\\left(", p,
                 "= \\hat{P}",
                "\\right)")

  topline <- paste(lhs, "&\\sim", rhs)

  second_line <- modify_lhs_for_link(model, "\\hat{P}")

  full_lhs <- paste(topline, "\\\\\n", second_line, "\n")
  full_lhs
}


#' Extract left-hand side of a polr object
#'
#' Extract a string of the outcome/dependent/y variable with the appropriate
#' link function.
#'
#' @export
#' @keywords internal
#'
#' @inheritParams extract_eq
#'
#' @return A character string
#' @noRd

extract_lhs.polr <- function(model, ital_vars, ...) {
  tidied <- broom::tidy(model)
  lhs <- tidied$term[tidied$coef.type == "scale"]
  lhs_escaped <- mapply_chr(escape_tex, lhs)

  lhs <- lapply(strsplit(lhs_escaped, "\\|"), add_tex_ital_v, ital_vars)
  lhs <- lapply(lhs, paste, collapse = " \\geq ")
  lhs <- lapply(lhs, function(.x) paste0("P( ", .x , " )"))
  full_lhs <- lapply(lhs, function(.x) modify_lhs_for_link(model, .x))

  class(full_lhs) <- c("list", class(model))
  full_lhs
}


#' Extract left-hand side of a clm object
#'
#' Extract a string of the outcome/dependent/y variable with the appropriate
#' link function.
#'
#' @export
#' @keywords internal
#'
#' @inheritParams extract_eq
#'
#' @return A character string
#' @noRd

extract_lhs.clm <- function(model, ital_vars, ...) {
  tidied <- broom::tidy(model)
  lhs <- tidied$term[tidied$coef.type == "intercept"]
  lhs_escaped <- mapply_chr(escape_tex, lhs)

  lhs <- lapply(strsplit(lhs_escaped, "\\|"), add_tex_ital_v, ital_vars)
  lhs <- lapply(lhs, paste, collapse = " \\geq ")
  lhs <- lapply(lhs, function(.x) paste("P(", .x , ")"))
  full_lhs <- lapply(lhs, function(.x) modify_lhs_for_link(model, .x))

  class(full_lhs) <- c("list", class(model))
  full_lhs
}


#' modifies lhs of equations that include a link function
#' @keywords internal
#' @noRd
modify_lhs_for_link <- function(model, ...) {
  UseMethod("modify_lhs_for_link", model)
}

#' @export
#' @keywords internal
#' @noRd
modify_lhs_for_link.glm <- function(model, lhs) {
  if (!(any(grepl(model$family$link, link_function_df$link_name)))) {
    message("This link function is not presently supported; using an identity
              function instead")
    model$family$link <- "identity"
  }
  matched_row_bool <- grepl(model$family$link, link_function_df$link_name)
  if (sum(matched_row_bool)>1){
    matched_row_bool[1] <- FALSE
  }
  filtered_link_formula <- link_function_df[matched_row_bool, "link_formula"]
  gsub("y", lhs, filtered_link_formula, fixed = TRUE)
}

#' @export
#' @keywords internal
#' @noRd
modify_lhs_for_link.polr <- function(model, lhs) {
  matched_row_bool <- grepl(model$method, link_function_df$link_name)
  filtered_link_formula <- link_function_df[matched_row_bool, "link_formula"]

  gsub("y", lhs, filtered_link_formula, fixed = TRUE)
}

#' @export
#' @keywords internal
#' @noRd
modify_lhs_for_link.clm <- function(model, lhs) {
  if (!(any(grepl(model$info$link, link_function_df$link_name)))) {
    message("This link function is not presently supported; using an identity
              function instead")
    model$info$link <- "identity"
  }
  matched_row_bool <- grepl(model$info$link, link_function_df$link_name)
  if (sum(matched_row_bool) > 1){
    matched_row_bool[1] <- FALSE
  }
  filtered_link_formula <- link_function_df[matched_row_bool, "link_formula"]
  gsub("y", lhs, filtered_link_formula, fixed = TRUE)
}


# link-functions.R

link_name <- c("logit, logistic",
               "probit",
               'inverse',
               # '1/mu^2', # inverse gaussian; removed until we're certain
               'log',
               'identity') # this isn't necessary as extract_eq() does this by default

# not sure how to address this one: quasi(link = "identity", variance = "constant")

link_formula <- c("\\log\\left[ \\frac { y }{ 1 - y } \\right]",
                  "y",
                  "\\frac { 1 }{ y }",
                  # "\\frac { 1 }{ 1/{ y }^{ 2 } } ", # inverse gaussian - correct?
                  "\\log ({ y }) ",
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


#' Extract left-hand side of an forecast::Arima object
#'
#' Extract a dataframe of S/AR components
#'
#' @keywords internal
#'
#' @param model A forecast::Arima object
#'
#' @return A dataframe
#' @noRd
extract_lhs.forecast_ARIMA <- function(model, ...){
  # LHS of ARIMA is the Auto Regressive side
  # Consists of Non-Seasonal AR (p), Seasonal AR (P), Non-Seasonal Differencing (d), Seasonal Differencing(D), Constant Terms.
  # Constants are dealt with here if they go here and in LM if they go there.
  
  # This is more than needed, but we"re being explicit for readability.
  # Orders stucture in Arima model:
  # c(p, q, P, Q, m, d, D)
  ords <- model$arma
  names(ords) <- c("p","q","P","Q","m","d","D")
  
  # Following the rest of the package.
  # Pull the full model with broom::tidy
  full_mdl <- broom::tidy(model)
  
  # Filter down to only the AR and SAR coefficients.
  full_lhs <- full_mdl[grepl("^s?ar", full_mdl$term), ]
  
  # Add a Primary column and set it to the backshift operator.
  full_lhs["primary"] <- rep("B", nrow(full_lhs))
  
  # Get the superscript for the backshift operator.
  ## This is equal to the number on the term for AR
  ## and the number on the term * the seasonal frequency for SAR.
  ## Powers of 1 are replaced with an empty string.
  lhs_super <- as.numeric(gsub("^s?ar", "", full_lhs$term))
  lhs_super[grepl("^sar", full_lhs$term)] <- lhs_super[grepl("^sar", full_lhs$term)] * ords["m"]
  
  lhs_super <- as.character(lhs_super)
  
  full_lhs["superscript"] <- lhs_super
  
  # The LHS has differencing and seasonal differencing.
  ## Setup the dataframe
  diff_df <- data.frame(term = c("zz_differencing", "zz_seas_Differencing"),
                        estimate = rep(NA, 2),
                        std.error = rep(NA, 2),
                        primary = c("(1 - B)", paste0("(1 - B", "^{", ords["m"],"})")),
                        superscript = c(ords["d"], ords["D"]))
  
  ## Remove what isn"t needed
  diff_df <- diff_df[ords[c("d","D")] > 0,]
  
  # Add the differencing lines to the end of the S/AR lines.
  full_lhs <- rbind(full_lhs, diff_df)
  
  # Reduce any "1" superscripts to blank
  full_lhs[full_lhs$superscript == "1", "superscript"] <- ""
  
  # Deal with potential constant terms
  # This will only come up if it is not a regression model
  regression <- helper_arima_is_regression(model)
  if(!regression){
    # It is not a regression model
    c_df <- full_mdl[full_mdl$term %in% c("intercept", "drift", "mean"), ]
    
    c_df[c_df$term %in% c("intercept", "mean"),"primary"] <- ""
    c_df[c_df$term == "drift","primary"] <- "t"
    c_df$superscript <- ""
    
    full_lhs <- rbind(full_lhs, c_df)
  }
  
  # Set subscripts so that create_term works later
  full_lhs$subscripts <- ""
  
  # Set the class
  class(full_lhs) <- c("data.frame", class(model))
  
  # Explicit return
  return(full_lhs)
}
