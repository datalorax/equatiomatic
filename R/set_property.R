################################################################
# Utility functions to add or modify properties of an `eq_term` object.


########## SET Property
# Parent

#' @title
#' Add or set an `eq_term` object property.
#'
#' @description
#' Allows developers to add or edit term properties individually or in a
#' filtered set.
#'
#' @details
#' There are several helper functions that save the developer from having to
#' enter the `.property` argument. These are documented here, but note that the
#' `.property` argument is not necessary for them (e.g.
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
#' @param .property A character or vector of character. Name(s) of property(ies) to
#'   be modified. If a vector, must be the same length as `.new`.
#' @param .new A numeric, character, or `eq_term` or vector of them. The
#'   value(s) that is(are) going to replace the current value(s) in the
#'   property(s). If a vector, must be the same length as `.property`;
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
#' set_property(
#'     .x = my_term,
#'     .property = 'variable',
#'     .new = '\\beta'
#' )
#'
#' @export
set_property <-
  function (
    .x,
    .property,
    .new,
    .boolean_mask
  ) {
    # Check Parameters
    ## List objects passed in (e.g. eq_variable objects) will cause mapply to iterate.
    if ( !is.vector(.new) ) { .new <- list(.new) }

    ## .new and .property must be the same length
    if( (length(.property) > 1) && (length(.property) != length(.new)) ) {
      stop(
        "Arguments `.property` and `.new` must be the same length",
        call. = FALSE
      )
    }

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

    # Coercion
    ## List objects passed in will cause mapply to iterate.
    if(inherits(.x, "eq_term")) { .x <- list(.x) }
    if(inherits(.new, "eq_variable")) {.new <- list(.new) }

    ## Missing boolean
    if(missing(.boolean_mask)) { .boolean_mask <- rep(TRUE, length(.x)) }

    ## Make sure property is a character
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
            prop,
            new_value,
            filter
          ) {
            # Perform filter and set
            if(filter) {
              term[[prop]] <- new_value
            }

            # Return value
            return(term)
          },
          .x,
          property,
          .new,
          .boolean_mask,
          SIMPLIFY = FALSE
        )
    }

    ## Return
    .x
  }


# Children

#' @describeIn set_property Set the `variable` property.
#' @export
set_variable <-
  function(
    .x,
    .new,
    .boolean_mask
  ) {
    # Coercion and Checks happen in parent function
    # Run parent function
    set_property(.x, "variable", .new, .boolean_mask)
  }

#' @describeIn set_property Set the `suffix` property.
#' @export
set_suffix <-
  function(
    .x,
    .new,
    .boolean_mask
  ) {
    # Coercion and Checks happen in parent function
    # Run parent function
    set_property(.x, "suffix", .new, .boolean_mask)
  }

################################################################
