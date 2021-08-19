################################################################
# Utility functions to add or modify properties of an `eq_variable` object.
# held in an `eq_term` object.

########## SET Variable property
# Parent

#' @title
#' Add or set a property of an `eq_variable` held in an `eq_term` object .
#'
#' @description
#' Allows developers to add or edit term properties individually or in a
#' filtered set.
#'
#' @details
#' There are several helper functions that save the developer from having to
#' enter the `.variable_property` argument. These are documented here, but note that the
#' `.variable_property` argument is not necessary for them (e.g.
#' \link{set_variable}).
#'
#' When `.x` is a list of `eq_term` objects, the `.boolean_mask` argument will
#' filter the list and apply the changes to a subset of the list items in `.x`.
#' Furthermore, the filter will not change the order of the items in the list.
#'
#' \bold{Note:} Since this function can be used to \emph{add a property} there
#' is no check that the property actually exists. It will be created if it
#' doesn't exist. Make sure to check your spelling.
#'
#' @keywords internal
#'
#' @param .x An `eq_term` object or list of `eq_term` objects.
#' @param .term_property A character or vector of characters. Name(s) of the
#'   properties in the `eq_term` object that hold the `eq_variable` objects to
#'   be modified.
#' @param .variable_property A character or vector of character. Name(s) of
#'   property(ies) in the `eq_variable` object to be modified. If a vector, must
#'   be the same length as `.new`.
#' @param .new A numeric, character, or `eq_term` or vector of them. The
#'   value(s) that is(are) going to replace the current value(s) in the
#'   property(ies). If a vector, must be the same length as `.property`;
#' @param .boolean_mask Optional. A vector of logicals (booleans) the same
#'   length at `.x`. Filters `.x` if it is a list.
#'
#' @return An `eq_term` object.
#'
#' @family eq_term modifiers
#'
#' @examples
#' my_term <- eq_term(term = "sma", estimate = 0.25)
#'
#' set_variable_property(
#'     .x = my_term,
#'     .term_property = 'variable'
#'     .variable_property = 'name',
#'     .new = '\\beta'
#' )
#'
#' @export
set_variable_property <-
  function (
    .x,
    .term_property,
    .variable_property,
    .new,
    .boolean_mask
  ) {
    # Check Parameters and coercion
    ## List objects need to be nested so as to be treated like a single object.
    if ( !is.vector(.new) ) { .new <- list(.new) }

    ## Boolean Mask
    if( !missing(.boolean_mask) ) {
      # Exists
      # and it isn't boolean (logical)
      if ( !is.logical(.boolean_mask) ) {
        stop(
          "Arguments `.boolean_mask` is not a vector of logicals (booleans).",
          call. = FALSE
        )
      }

      # and isn't the same length as .x
      if ( length(.x) != length(.boolean_mask) ) {
        stop(
          "Arguments `.boolean_mask` and `.x` are not the same length.",
          call. = FALSE
        )
      }
    } else {
      # Does not exist
      .boolean_mask <- rep(TRUE, length(.x))
    }


    # Coercion
    ## If .x is not a list of objects, but rather a single object, it needs to
    ## be treated as a unit.
    if(inherits(.x, "eq_term")) { .x <- list(.x) }

    ## Make sure property is a character
    .term_property <- as.character(.term_property)
    .variable_property <- as.character(.variable_property)

    # Check if property exists and add to filter
    .boolean_mask <- .boolean_mask & vapply(.x, function(z){ any( names(z) %in% .term_property ) }, logical(1))

    # Main Function
    ## Convert .new into an appropriately named list
    .new <- as.list(.new)

    ## Length ov .variable_property determines overall behavior
    if (length(.variable_property) == 1) {
      # Recycle .new if length = 1
      if( length(.new) == 1) { .new <- rep(.new, sum(.boolean_mask)) }

      # Rep and split across boolean_mask
      names(.new) <- rep(.variable_property, sum(.boolean_mask))
      .new <- split(.new, seq_along(.new))

      # Recycle term_property if only length 1
      names(.new) <- if(length(.term_property) == 1) rep(.term_property, length(.new)) else .term_property

      # Split again across boolean_mask and name
      .new <- split(.new, seq_along(.new))
      names(.new) <- names(.x[.boolean_mask])
    } else {
      # Recycle .new if length = 1
      if( length(.new) == 1) { .new <- rep(.new, length(.term_property)) }

      # Rep and split across term_property
      names(.new) <- rep(.variable_property, length(.term_property) )
      .new <- split(.new, floor(seq_along(.new)/length(.variable_property)))

      # Assign names from term_property
      names(.new) <- .term_property

      # Rep, split, and name across boolean_mask
      .new <- rep(.new, sum(.boolean_mask))
      .new <- split(.new, floor(seq_along(.new)/sum(.boolean_mask)))
      names(.new) <- names(.x[.boolean_mask])
    }

    ## Modify list
    .x <- modifyList(.x, .new)

    ## Return
    .x
  }


# Children

#' @describeIn set_variable_property Set the `name` property.
#' @export
set_variable_name <-
  function(
    .x,
    .term_property,
    .new,
    .boolean_mask
  ) {
    # Coercion and Checks happen in parent function
    # Run parent function
    set_variable_property(.x, .term_property, "name", .new, .boolean_mask)
  }

#' @describeIn set_variable_property Set the `subscript` property.
#' @export
set_variable_subscript <-
  function(
    .x,
    .term_property,
    .new,
    .boolean_mask
  ) {
    # Coercion and Checks happen in parent function
    # Run parent function
    set_variable_property(.x, .term_property, "subscript", .new, .boolean_mask)
  }

#' @describeIn set_variable_property Set the `superscript` property.
#' @export
set_variable_superscript <-
  function(
    .x,
    .term_property,
    .new,
    .boolean_mask
  ) {
    # Coercion and Checks happen in parent function
    # Run parent function
    set_variable_property(.x, .term_property, "superscript", .new, .boolean_mask)
  }

#' @describeIn set_variable_property Set the `italic` property.
#' @export
set_variable_italic <-
  function(
    .x,
    .term_property,
    .new,
    .boolean_mask
  ) {
    # Coercion and Checks happen in parent function
    # Run parent function
    set_variable_property(.x, .term_property, "italic", .new, .boolean_mask)
  }

