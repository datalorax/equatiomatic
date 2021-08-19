################################################################## BEGIN CLASS
##########################
# Interfaces
# eq_term()
##########################

# Subclasses of `eq_term` should include the following:
# 1. convert2latex.__subclass__()
#    that converts the subclass to a latex-friendly string
# 2. as.character.__subclass__() method
#    that wraps convert2latex.__subclass__()

##########################
# Class Definition
# eq_term()
##########################
# This is a class script.
# It contains a single class, its methods, and utility functions.

########## Basic Constructor
# A constructor is an inflexible class builder that performs few checks.
# Only type and structure checks should happen here.
# Use with caution and only when you know the values are correct!

#' @title
#' Base constructor for `eq_term` class
#'
#' @description
#' Constructs an `eq_term` object with minimal checks.
#'
#' @details
#' As a base constructor for `eq_term` class, this function only performs type checks, should
#' only be used by developers, and when the you know the types are correct. For
#' a fully-fledged constructors with coercion and validation see [eq_term()].
#'
#' @keywords internal
#'
#' @param .term A character representing the term name.
#' @param .estimate A number. Swaps with 'variable'.
#' @param .variable A \code{eq_variable}. Swaps with 'estimate'.
#' @param .suffix A \code{eq_variable}.
#'
#' @return A list classed as `eq_term`.
#'
#' @seealso \link{eq_term} for a full constructor (including coercion and
#'   validation), \link{validate_eq_term} for a more complex validation
#'
#' @family eq_term constructors
new_eq_term <-
  function(
    .term = NA_character_,
    .estimate = NA_real_,
    .variable = new_eq_variable(),
    .suffix = new_eq_variable(),
    .custom_parsing = function(x) { x }
  ){
    # Type checks
    stopifnot(is.character(.term))
    stopifnot(is.numeric(.estimate))

    stopifnot(inherits(.variable, 'eq_variable'))
    stopifnot(inherits(.suffix, 'eq_variable'))

    # Structure
    structure(
      list(
        term = .term,
        estimate = .estimate,
        variable = .variable,
        suffix = .suffix
      ),
      class = c("eq_term", "term_obj"),
      flatten = FALSE
    )
  }

######### Validator
# A validation function that performs more complicated checks.
# Provided for extensibility and if additional check are needed later on.

#' @title
#' Validation function for `eq_term` class
#'
#' @description
#' Performs more complex checks when `eq_term` is constructed with the full constructor.
#'
#' @keywords internal
#'
#'
#' @param .eq_term An unvalidated `eq_term`.
#'
#' @return A validated `eq_term`.
#'
#' @seealso \link{eq_term} for a full constructor (including coercion and
#'   validation), \link{new_eq_term} for a low-level constructor
#'
#' @family eq_term constructors
#'
validate_eq_term <-
  function(
    .eq_term
  ){
    # TBD
    # May want to add checks for escaping, etc.

    # Example
    # if (!all(!is.na(values) & values > 0)) {
    #   stop(
    #     "All `x` values must be non-missing and greater than zero",
    #     call. = FALSE
    #   )
    # }

    # Return
    .eq_term
  }


########## Full Constructor / Helper
# A "helper" function or full constructor performs coercion.
# and tries to "help out" in getting the correct structure.

#' @title
#' Constructor for `eq_term` class
#'
#' @description
#' Returns a list of class `eq_term` and provides for coercion and validation.
#'
#' @details
#' The `eq_term` class provides the structure for a discrete mathematical unit.
#' Editing and passing mathematical terms as discrete units allows developers to
#' focus on combining these terms, rather than on structuring objects.
#'
#' The primary objective of the class is to render itself, consistently, into
#' Latex.
#'
#' @keywords internal
#'
#' @param .term A character representing the term name.
#' @param .estimate A number. Swaps with `variable`.
#' @param .variable A \code{eq_variable}. Represents the main variable when not using a coefficient. Swaps with `estimate`.
#' @param .suffix A \code{eq_variable}. Unlike `.variable` will always be
#'   present immediately after the `.estimate` or `.variable`.
#'
#' @return A list classed as `eq_term`.
#'
#' @seealso \link{new_eq_term} for a low-level constructor.
#'
#' @family term constructors
#' @family eq_term constructors
#' @family eq_term modifiers
#' @family extensibility functions
#'
#' @examples
#' eq_term(term = "sma", estimate = 0.25)
#'
#' @export
eq_term <-
  function(
    .term = NA_character_,
    .estimate = NA_real_,
    .variable = new_eq_variable(),
    .suffix = new_eq_variable()
  ){
    # Coercion
    term <- as.character(.term)
    estimate <- as.numeric(.estimate)


    # Basic Construction
    unvalidated_eq_term <-
      new_eq_term(
        .term = term,
        .estimate = estimate,
        .variable = .variable,
        .suffix = .suffix
      )

    # Validation & Return
    validate_eq_term(unvalidated_eq_term)
  }


##########################
# Methods
##########################

################
# Equatiomatic (see defaults.R)
################

########## convert2latex & wrapper (as.eq_term)
#' @title
#' Convert `eq_term` object to Latex
#'
#' @description
#' Converts a `eq_term` classed object latex-friendly character string.
#'
#' @keywords internal
#'
#' @inherit convert2latex
#' @param .use_coef A logical. Switch usage of the `estimate` or `variable`
#'   representation. Default: FALSE.
#' @param .coef_digits A numeric used to round the term `estimate`. Default: 2.
#' @param .use_coef_sign A logical. If FALSE, will treat all signs on `estimate` as positive. Default: TRUE.
#' @param .inverse_sign A logical. If TRUE, will inverse the sign on `estimate`. Default: FALSE.
#' @param ... Other parameters that may need passed to downstream functions.
#'
#' @return A latex-friendly character (string) representation of the term.
#'
#' @family convert2latex functions
#'
#' @method convert2latex eq_term
#' @export
convert2latex.eq_term <-
  function(
    .x,
    .use_coef = FALSE,
    .coef_digits = 2,
    .use_coef_sign = TRUE,
    .inverse_sign = FALSE,
    ...
  ) {
    # Generate elements
    # Will return NULL if condition not met.

    #coef <-
    #  if(use_coef) { sprintf("%+f", round(x$coefficient, coef_digits)) }

    # This all feels like a bit much for this function.
    # There's also the issue of using signs on larger items, like division.
    # May not pass through the sign at any point in the combiner.
    # In some cases (like a backshift operator), there will never be a coef
    # Instead of building a whole new case, added a check on the coef if it is
    # NA then use the variable instead via NULL on coef.
    coef <-
      if(.use_coef && !is.na(.x$estimate)) {
        inverse_it <- if(.inverse_sign) { -1 } else { 1 }
        format_str <-
          paste(
            "%", if(.use_coef_sign) { "+" } ,
            ".", .coef_digits,
            "f",
            sep = ""
          )


        sprintf( format_str, round( .x$estimate * inverse_it, .coef_digits ) )
      }

    var <- if(!.use_coef) { convert2latex(.x$variable) }

    suffix <- convert2latex(.x$suffix)

    # Add subscripts and superscripts
    ## This will choose the estimate, then the variable. First non-null
    value <- c(coef, var)

    # Return
    paste(
      value,
      suffix,
      sep = " "
    )
  }


################
# Base R
################

########## as.character

#' @rdname convert2latex.eq_term
#' @method as.character eq_term
#' @export
as.character.eq_term <-
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

# Originally, set_property(), set_variable_property(), apply_property(), and
# apply_variable_property() were here. At some point they became too large to
# include in this file and were moved to their own files.


################################################################## END CLASS
