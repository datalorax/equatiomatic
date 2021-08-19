################################################################## BEGIN CLASS
##########################
# Interfaces
# eq_line()
##########################

# Subclasses of `eq_line` should include the following:
# 1. convert2latex.__subclass__()
#    that converts the subclass to a latex-friendly string
# 2. as.character.__subclass__() method
#    that wraps convert2latex.__subclass__()

##########################
# Class Definition
# eq_line()
##########################
# This is a class script.
# It contains a single class, its methods, and utility functions.

########## Full Constructor / Helper
# No low-level constructor or validator included.

#' @title
#' Encapsulate a line in an equation.
#'
#' @description
#' An encapsulated line that wraps separate of other lines in an equation.
#'
#' @details
#' One of several helper functions to provide for consistent parsing to Latex.
#' `eq_line` allows developers to encapsulate terms that should remain on their
#' own line and wrap together.
#'
#' Null objects provided in \code{...} will be removed along with the preceding
#' element.
#'
#' @keywords internal
#'
#' @param ... One or more R objects convertible to a character.
#' @param .wrapable_operators A character vector. Represents the character
#'   objects where the line can be wrapped. Default is \code{c("=", "+", "-")}.
#'
#' @return A list classed as `eq_line`.
#'
#' @family term constructors
#' @family extensibility functions
#'
#' @examples
#' eq_line(c_term("y0"), "=", myterm1, "+", myterm2)
#'
#' @export
eq_line <-
  function(
    ...,
    .wrapable_operators = c("=", "+", "-")
  ) {
    # Capture dots
    dots <- list(...)

    # Flatten
    dots <- flatten_nested(dots)

    # Note term objects or non-wrapable operators
    wrap_pattern <-
      paste0(
        rep("\\", length(.wrapable_operators)),
        .wrapable_operators,
        collapse = "|"
      )

    wrapable_objs <-
      vapply(
        dots,
        function(x) {
          if (is.character(x)) {
            grepl(wrap_pattern, x)
          } else {
            FALSE
          }
        },
        logical(1)
      )

    # Deal with null items
    ## Removes null item and the preceding item.
    ## TODO: There may be a better method to deal with this.
    null_dots <- vapply(dots, is.null, logical(1))
    null_dots[which(null_dots, TRUE) - 1] <- TRUE

    dots <- dots[!null_dots]
    wrapable_objs <- wrapable_objs[!null_dots]

    # Structure
    structure(
      list (
        terms = dots,
        wrapable = wrapable_objs
      ),
      class = c("eq_line", "term_obj"),
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
#' Convert `eq_line` object to Latex
#'
#' @description
#' Converts a `eq_line` classed object latex-friendly character string.
#'
#' @keywords internal
#'
#' @inherit convert2latex.eq_term
#' @param .wrap A logical. Whether or not to wrap terms in the line. Default is
#'   disabled (FALSE).
#' @param .operator_location One of \code{c("start", "end")}. When terms are
#'   split across multiple lines, they are split at mathematical operators like
#'   `+`.When \dQuote{start}, each line will begin with an operator. When
#'   \dQuote{end} each line will end with a trailing operator. Default is
#'   \dQuote{end}.
#' @param .terms_per_line An integer. How many terms in a line before wrapping,
#'   if wrapping is enabled. Will be rounded down if not an integer. Default is 4.
#'
#' @return A latex-friendly character (string) representation of the term.
#'
#' @family convert2latex functions
#'
#' @export
convert2latex.eq_line <-
  function(
    .x,
    .use_coef = FALSE,
    .coef_digits = 2,
    .use_coef_sign = TRUE,
    .inverse_sign = FALSE,
    .wrap = FALSE,
    .operator_location = "end",
    .terms_per_line = 4,
    ...
  ) {
    # Type Checks
    # TODO: Add type checks

    # Convert to characters
    chrs <-
      suppressWarnings(
        lapply(
          .x$terms,
          convert2latex,
          .use_coef = .use_coef,
          .coef_digits = .coef_digits,
          .use_coef_sign = .use_coef_sign,
          .inverse_sign = .inverse_sign
        )
      )

    # Wrapping
    if(.wrap) {
      chrs <-
        wrap_eq(
          .x = .x,
          .chrs = chrs,
          .terms_per_line = .terms_per_line,
          .operator_location = .operator_location
        )
    }

    # Alignment
    # Alignment is only applied to a full equation, not a line.

    # Return
    paste0(chrs, collapse = " ")
  }


################
# Base R
################

########## as.character

#' @rdname convert2latex.eq_line
#' @method as.character eq_line
#' @export
as.character.eq_line <-
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
