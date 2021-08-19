################################################################## BEGIN CLASS
##########################
# Interfaces
# c_term()
##########################

# Subclasses of `c_term` should include the following:
# 1. convert2latex.__subclass__()
#    that converts the subclass to a latex-friendly string
# 2. as.character.__subclass__() method
#    that wraps convert2latex.__subclass__()

##########################
# Class Definition
# c_term()
##########################
# This is a class script.
# It contains a single class, its methods, and utility functions.

########## Full Constructor / Helper
# No low-level constructor or validator included.

#' @title
#' Constructor for a custom term object.
#'
#' @description
#' Returns a list of class `c_term` which parses similar to `eq_term`.
#'
#' @details
#' When a utility function hasn't been built or would be too niche, developers
#' can use a character vector (including `eq_term` objects) to build a term-like
#' object. `eq_term` and term-like objects will use standard
#' \code{convert2latex()} options when parsing. Ohters will be converted to a
#' character.
#'
#' @keywords internal
#'
#' @param ... One or more R objects convertible to a character.
#'
#' @return A list classed as `eq_term`.
#'
#' @seealso \link{eq_term} for a full `eq_term` object constructor.
#'
#' @family term constructors
#' @family c_term constructors
#' @family extensibility functions
#'
#' @examples
#' c_term("\\sim \\mathcal{N}(", my_term, "\\,\\sigma^{2})")
#'
#' @export
c_term <-
  function(
    ...
  ){
    # Get values from dots as vector
    dots <- unname( list(...) )

    # Remove nulls from the list
    dots[vapply(dots, is.null, logical(1))] <- NULL

    # Structure
    structure(
      dots,
      class = c("c_term", "term_obj"),
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
#' Convert custom `eq_term` (a `c_term`) object to Latex
#'
#' @description
#' Converts a `c_term` classed object latex-friendly character string.
#'
#' @details
#' `eq_term` and term-like objects will use standard \code{convert2latex()}
#' options when parsing. Ohters will be converted to a character.
#'
#' @keywords internal
#'
#' @inherit convert2latex.eq_term
#'
#' @return A latex-friendly character (string) representation of the term.
#'
#' @family convert2latex functions
#'
#' @method convert2latex c_term
#' @export
convert2latex.c_term <-
  function(
    .x,
    .use_coef = FALSE,
    .coef_digits = 2,
    .use_coef_sign = TRUE,
    .inverse_sign = FALSE,
    ...
  ) {

    # Convert to characters
    chrs <-
      suppressWarnings(
        lapply(
          .x,
          convert2latex,
          .use_coef = .use_coef,
          .coef_digits = .coef_digits,
          .use_coef_sign = .use_coef_sign,
          .inverse_sign = .inverse_sign
        )
      )

    # Return
    paste0(chrs, collapse="")
  }


################
# Base R
################

########## as.character

#' @rdname convert2latex.c_term
#' @method as.character c_term
#' @export
as.character.c_term <-
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
