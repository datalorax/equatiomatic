################################################################
# Utility functions to programmatically combine terms by an operator.
# There is an overarching function that pushing to the correct function depending on

##########################
# combine_by
##########################

#' @title
#' Combine terms.
#'
#' @description
#' Allows developers to combine a set of terms (i.e. by a operator like
#' \code{"+"} or a function).
#'
#' @details
#' The function dispatches on the \code{.combiner} argument. For example, a
#' character will dispatch to \code{combine_by.character} and will place the
#' character between the operators.
#'
#' @keywords internal
#'
#' @param .x One or more `eq_term` or term-like objects.
#' @param .combiner A character or function. Used for dispatch and combining the
#'   terms. These may have different behavior. Please check the documentation
#'   for individual methods. \emph{Functions must return a `c_term` class!}
#'
#' @seealso When nested in another list, use \code{flatten_nested} to bring up one
#'   level.
#'
#' @return A list.
#'
#' @family term combiners
#' @family extensibility functions
#'
#' @export
combine_by <-
  function(
    .x,
    .combiner
  ) {
    UseMethod(generic = "combine_by", object = .combiner)
  }


#' @describeIn combine_by Default method for \code{combine_by()}. Returns an
#'   error.
combine_by.default <-
  function(
    .x,
    .combiner
  ) {
    stop(
      paste0("combine_by() has no method for class(es)", class(.x), collapse = " "),
      call. = FALSE
    )
  }

########## COMBINE BY OPERATOR

#' @describeIn combine_by Combines terms using a character operator between them (e.g. \code{"+"})
#' @export
combine_by.character <-
  function(
    .x,
    .combiner
  ) {
    # Create operator list
    op_lst <- as.list( rep(.combiner, length(.x) - 1) )

    # Generate ordered indices
    idx <- order( c( seq_along(.x), seq_along(op_lst) ) )

    # Order
    ordered_lst <- c(.x, op_lst)[idx]

    # Class and Attributes
    ## See the top of this script for info on why a class is given.
    class(ordered_lst) <- append("eq_combine", class(ordered_lst))
    attributes(ordered_lst)[["flatten"]] <- TRUE

    # Return
    ordered_lst
  }


########## COMBINE BY FUNCTION
#' @describeIn combine_by Combines terms using the provided function, returning a list of `c_term` objects.
#' @export
combine_by.function <-
  function(
    .x,
    .combiner
  ) {
    # Apply function to provided values
    c_lst <- lapply(.x, .combiner)

    # Check return type
    stopifnot(inherits(c_lst[[1]], "c_term"))

    # Class and Attributes
    ## See the top of this script for info on why a class is given.
    class(c_lst) <- append("eq_combine", class(c_lst))
    attributes(c_lst)[["flatten"]] <- TRUE

    # Return
    c_lst
  }

################################################################ END
