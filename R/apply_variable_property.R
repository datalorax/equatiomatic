################################################################
# Utility functions to apply a function to properties of an `eq_variable` object.
# held in an `eq_term` object.

########## APPLY Function to Variable Property
# Parent

#' @title
#' Apply a function to a property of an `eq_variable` held in an `eq_term` object .
#'
#' @description
#' Allows developers to edit term properties individually or in a filtered set
#' by applying a function to the current value.
#'
#' @details
#' There are several helper functions that save the developer from having to
#' enter the `.variable_property` argument. They are documented here, but note that the
#' `.variable_property` argument is not necessary for them (e.g.
#' \link{apply_variable_superscript}).
#'
#' When `.x` is a list of `eq_term` objects, the `.boolean_mask` argument will
#' filter the list and apply the changes to a subset of the list items in `.x`.
#' Furthermore, the filter will not change the order of the items in the list.
#'
#' @keywords internal
#'
#' @param .x An `eq_term` object or list of `eq_term` objects.
#' @param .term_property A character or vector of characters. Name(s) of the
#'   properties in the `eq_term` object that hold the `eq_variable` object(s) to
#'   be modified.
#' @param .variable_property A character or vector of character. Name(s) of
#'   property(ies) in the `eq_variable` object to be modified. If a vector, must
#'   be the same length as `.new`.
#' @param .f A function. The function applied to the current value in the
#'   property.
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
#' apply_variable_property(
#'     .x = my_term,
#'     .term_property = 'variable',
#'     .variable_property = 'name',
#'     .f = function(x) { tolower(x)}
#' )
#'
#' @export
apply_variable_property <-
  function (
    .x,
    .term_property,
    .variable_property,
    .f,
    .boolean_mask
  ) {
    # Check Parameters
    ## Boolean Mask exists
    if( !missing(.boolean_mask) ) {
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
    }

    ## Function should be a function
    if(!is.function(.f)){
      stop(
        "Argument `.f` must be a function.",
        call. = FALSE
      )
    }

    # Coercion
    if(inherits(.x, "eq_term")) { .x <- list(.x) }
    if(missing(.boolean_mask)) { .boolean_mask <- rep(TRUE, length(.x)) }

    .variable_property <- as.character(.variable_property)

    # Check if term property exists and add to filter
    prop_exists <- vapply(.x, function(z){ any( names(z) %in% .term_property ) }, logical(1))
    .boolean_mask <- .boolean_mask & prop_exists

    # Main Function
    ## Apply
    for(term_property in .term_property) {
      .x <-
        mapply(
          function(
            term,
            term_prop,
            variable_prop,
            filter
          ) {
            # Perform filter and set
            if(filter) {
              term[[term_prop]][[variable_prop]] <- .f(term[[term_prop]][[variable_prop]])
            }

            # Return
            term
          },
          .x,
          term_property,
          .variable_property,
          .boolean_mask,
          SIMPLIFY = FALSE
        )
    }

    ## Return
    .x
  }

# Children

#' @describeIn apply_variable_property Apply function to the `superscript` property.
#' @export
apply_variable_superscript <-
  function(
    .x,
    .term_property,
    .f,
    .boolean_mask
  ) {
    # Send to parent function
    apply_variable_property(.x, .term_property, "superscript", .f, .boolean_mask)
  }
