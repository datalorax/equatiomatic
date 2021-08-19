################################################################## BEGIN CLASS
##########################
# Interfaces
# eq_variable()
##########################

# Subclasses of `eq_variable` should include the following:
# 1. convert2latex.__subclass__()
#    that converts the subclass to a latex-friendly string
# 2. as.character.__subclass__() method
#    that wraps convert2latex.__subclass__()


##########################
# Class Definition
# eq_variable()
##########################
# This is a class script.
# It contains a single class, its methods, and utility functions.

########## Basic Constructor
# A constructor is an inflexible class builder that performs few checks.
# Only type and structure checks should happen here.
# Use with caution and only when you know the values are correct!

#' @title
#' Base constructor for `eq_variable` class
#'
#' @description
#' Constructs an `eq_variable` object with minimal checks.
#'
#' @details
#' As a base constructor for `eq_variable` class, this function only performs type checks, should
#' only be used by developers, and when the you know the types are correct. For
#' a fully-fledged constructors with coercion and validation see [eq_variable()].
#'
#' @keywords internal
#'
#' @param .x A character representing the variable name.
#' @param .subscript A character.
#' @param .superscript A character.
#' @param .italic A logical.
#'
#' @return A list classed as `eq_term`.
#'
#' @seealso \link{eq_term} for a full constructor (including coercion and
#'   validation), \link{validate_eq_term} for a more complex validation
#'
#' @family eq_variable constructors
new_eq_variable <-
  function(
    .x = NA_character_,
    .subscript = NA_character_,
    .superscript = NA_character_,
    .italic = TRUE
  ) {
    # Type checks
    stopifnot(is.character(.x))
    stopifnot(is.character(.subscript))
    stopifnot(is.character(.superscript))
    stopifnot(is.logical(.italic) & !is.na(.italic))

    # Structure
    structure(
      list(
        name = .x,
        subscript = .subscript,
        superscript = .superscript,
        italic = .italic
      ),
      class = c("eq_variable", "term_obj"),
      flatten = FALSE
    )
  }

######### Validator
# A validation function that performs more complicated checks.
# Provided for extensibility and if additional check are needed later on.

#' @title
#' Validation function for `eq_variable` class
#'
#' @description
#' Performs more complex checks when `eq_variable` is constructed with the full constructor.
#'
#' @keywords internal
#'
#'
#' @param .eq_variable An unvalidated `eq_variable`.
#'
#' @return A validated `eq_variable`.
#'
#' @seealso \link{eq_variable} for a full constructor (including coercion and
#'   validation), \link{new_eq_variable} for a low-level constructor
#'
#' @family eq_variable constructors
#'
validate_eq_variable <-
  function(
    .eq_variable
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
    .eq_variable
  }

########## Full Constructor / Helper
# A "helper" function or full constructor performs coercion.
# and tries to "help out" in getting the correct structure.

#' @title
#' Constructor for `eq_variable` class
#'
#' @description
#' Returns a list of class `eq_variable` and provides for coercion and validation.
#'
#' @details
#' The `eq_variable` class provides the structure a single variable. Usually
#' used in conjunction with `eq_term`, the behavior of variables is defined in
#' this class (e.g. superscripts). Editing and passing mathematical terms as
#' discrete units allows developers to focus on combining these terms, rather
#' than on structuring objects.
#'
#' The primary objective of the class is to render itself, consistently, into
#' Latex.
#'
#' @keywords internal
#'
#' @param .x A character representing the variable name..
#' @param .subscript A latex-friendly number, character, or \code{eq_term}.
#' @param .superscript A latex-friendly number, character, or \code{eq_term}.
#' @param .italic A logical. Determines if the variable is italicized. Default is `TRUE`.
#'
#' @return A list classed as `eq_term`.
#'
#' @seealso \link{new_eq_variable} for a low-level constructor.
#'
#' @family eq_variable constructors
#' @family eq_variable modifiers
#' @family extensibility functions
#'
#' @examples
#' eq_variable(
#'     name = "\\beta", subscript = 2, superscript = "(i)"
#' )
#'
#' @export
eq_variable <-
  function(
    .x = NA_character_,
    .subscript = NA_character_,
    .superscript = NA_character_,
    .italic = TRUE
  ){
    # Basic Construction & Coercion
    unvalidated_eq_variable <-
      new_eq_variable(
        .x = as.character(.x),
        .subscript = as.character(.subscript),
        .superscript = as.character(.superscript),
        .italic = as.logical(.italic)
      )

    # Validation & Return
    validate_eq_variable(unvalidated_eq_variable)
  }

##########################
# Methods
##########################


################
# Equatiomatic (see defaults.R)
################

########## convert2latex & wrapper (as.eq_variable)
#' @title
#' Convert `eq_variable` object to Latex
#'
#' @description
#' Converts a `eq_variable` classed object latex-friendly character string.
#'
#' @keywords internal
#'
#' @inherit convert2latex.eq_term
#'
#' @return A latex-friendly character (string) representation of the variable.
#'
#' @family convert2latex functions
#'
#' @method convert2latex eq_variable
#' @export
convert2latex.eq_variable <-
  function(
    .x,
    ...
  ) {

    # Return null if it is a blank variable
    if (is.na(.x$name)) {
      return(NULL)
    }

    # Generate elements
    # Will return NULL if condition not met.
    var <-
      if (.x$italic) {
        # Default is italic
        .x$name
      } else {
        # operatorname remove italics
        paste("\\operatorname{", .x$name, "}", sep="")
      }

    subscript <-
      if(!is.na(.x$subscript)) { paste("_{", .x$subscript, "}", sep = "") }

    superscript <-
      if(!is.na(.x$superscript)) { paste("^{", .x$superscript, "}", sep = "") }

    # Return
    paste(
      var,
      subscript,
      superscript,
      sep = ""
    )
  }

################
# Base R
################

########## as.character

#' @rdname convert2latex.eq_variable
#' @method as.character eq_variable
#' @export
as.character.eq_variable <-
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

################################################################## END CLASS
