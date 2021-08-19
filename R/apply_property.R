################################################################
# Utility functions to apply a function to properties of an `eq_term` object.

########## APPLY Function to property
# Parent

#' @title
#' Apply a function an `eq_term` object property.
#'
#' @description
#' Allows developers to edit term properties individually or in a filtered set
#' by applying a function to the current value.
#'
#' @details
#' There are several helper functions that save the developer from having to
#' enter the `.property` argument. They are documented here, but note that the
#' `.property` argument is not necessary for them (e.g.
#' \link{apply_estimate}).
#'
#' When `.x` is a list of `eq_term` objects, the `.boolean_mask` argument will
#' filter the list and apply the changes to a subset of the list items in `.x`.
#' Furthermore, the filter will not change the order of the items in the list.
#'
#' @keywords internal
#'
#' @param .x An `eq_term` object or list of `eq_term` objects.
#' @param .property A character or vector of character. Name(s) of property(ies) to
#'   be modified. If a vector, must be the same length as `.new`.
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
#' my_term <- eq_term(
#'     term = "sma", estimate = 0.25, variable = "\\phi",
#'     subscript = 2, superscript = "(i)"
#' )
#'
#' apply_property(
#'     .x = my_term,
#'     .property = 'estimate',
#'     .f = function(x) { x * -1 }
#' )
#'
#' @export
apply_property <-
  function (
    .x,
    .property,
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
    .property <- as.character(.property)

    # Check if property exists and add to filter
    prop_exists <- vapply(.x, function(z){ any( names(z) %in% .property ) }, logical(1))
    .boolean_mask <- .boolean_mask & prop_exists

    # Main Function
    ## Apply
    for(property in .property) {
      .x <-
        mapply(
          function(
            term,
            list_element,
            filter
          ) {
            # Perform filter and set
            if(filter) {
              term[[list_element]] <- .f(term[[list_element]])
            }

            # Return value
            return(term)
          },
          .x,
          property,
          .boolean_mask,
          SIMPLIFY = FALSE
        )
    }

    ## Return
    .x

  }

# Children

#' @describeIn apply_property Apply function to the `estimate` property.
#' @export
apply_estimate <-
  function(
    .x,
    .f,
    .boolean_mask
  ) {
    # Send to parent function
    apply_property(.x, "estimate", .f, .boolean_mask)
  }
