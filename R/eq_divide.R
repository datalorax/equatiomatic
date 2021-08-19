################################################################## BEGIN CLASS
##########################
# Interfaces
# eq_divide()
##########################

# Subclasses of `eq_divide` should include the following:
# 1. convert2latex.__subclass__()
#    that converts the subclass to a latex-friendly string
# 2. as.character.__subclass__() method
#    that wraps convert2latex.__subclass__()

##########################
# Class Definition
# eq_divide()
##########################
# This is a class script.
# It contains a single class, its methods, and utility functions.

########## Full Constructor / Helper
# No low-level constructor or validator included.

#' @title
#' Divide `eq_term` objects in Latex equation.
#'
#' @description
#' Returns a list of class `eq_divide` which parses similar to `eq_term`.
#'
#' @details
#' One of several helper functions to provide for consistent parsing to Latex.
#'
#' @keywords internal
#'
#' @param .numerator A character or `eq_term` object.
#' @param .denominator A character or `eq_term` object.
#'
#' @return A list classed as `eq_division`.
#'
#' @family term combiners
#' @family extensibility functions
#'
#' @examples
#' eq_divide(myeqterm, "5")
#'
#' @export
eq_divide <-
  function(
    .numerator,
    .denominator
  ) {
    # Structure
    structure(
      list(
        numerator = .numerator,
        denominator = .denominator
      ),
      class = c("eq_divide", "term_obj"),
      flatten = FALSE
    )
  }


##########################
# Methods
##########################

################
# Equatiomatic (see defaults.R)
################

########## convert2latex & wrapper (as.eq_term)
#' @title
#' Convert `eq_divide` object to Latex
#'
#' @description
#' Converts a `eq_divide` classed object latex-friendly character string.
#'
#' @keywords internal
#'
#' @inherit convert2latex.eq_term
#'
#' @return A latex-friendly character (string) representation of the term.
#'
#' @family convert2latex functions
#'
#' @method convert2latex eq_divide
#' @export
convert2latex.eq_divide <-
  function(
    .x,
    .use_coef = FALSE,
    .coef_digits = 2,
    .use_coef_sign = TRUE,
    .inverse_sign = FALSE,
    ...
  ) {
    paste(
      "\frac{",
      eq_convert2latex(.x$numerator, ...),
      "}{",
      eq_convert2latex(.x$denominator, ...),
      "}",
      sep = ""
    )
  }


################
# Base R
################

########## as.character

#' @rdname convert2latex.eq_divide
#' @method as.character eq_divide
#' @export
as.character.eq_divide <-
  function(
    .x,
    ...
  ) {
    convert2latex(.x = .x, ...)
  }

################
# External Packages
################
# Use function names as they come from the source package.
# Use ... to pass through properties.

# None


##########################
# Utility Functions
##########################
# These functions are used on this class and are not
# expected to be used elsewhere or with method dispatch.

# None

################################################################## END CLASS
