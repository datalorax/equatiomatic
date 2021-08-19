#' @title
#' Flatten Nested List of Terms
#'
#' @description
#' Flattens eligible objects one level up.
#'
#' @details
#' Will flatten elements of the provided list where the object has the
#' \code{attribute} \code{flatten} set to \code{TRUE}.
#'
#' @keywords internal
#'
#' @param .x A list.
#'
#' @family extensibility functions
#'
#' @return A list.
#' @export
flatten_nested <-
  function(
    .x
  ){
    # Which objects contain attribute: flatten = TRUE
    lsts <-
      which(
        vapply(
          .x,
          function(jbo) {
            # Return FALSE if attribute is missing
            # Regular boolean logic runs into issues having to compare on & to
            # elements without the attribute.
            if ( is.null(attributes(jbo)[["flatten"]]) ) {
              FALSE
            }
            else {
              attributes(jbo)[["flatten"]]
            }
          },
          logical(1)
        ),
        TRUE
      )

    # Exit early if there are none
    if (length(lsts) == 0) {
      return(.x)
    }

    # Length of lists
    lens <- vapply(.x[lsts], length, numeric(1))

    # Loop and append
    # We could have added a variable initialized to zero and then adjusted with
    # each loop. The difference here is a variable copy every loop vs a single
    # condition check.
    new <- append(.x, .x[[lsts[1]]], after = lsts[1])[-lsts[1]]

    # Exit early if there is only 1 element
    if(length(lsts) < 2) {
      return(new)
    }

    # Run similar operation
    for (idx in 2:length(lsts)) {
      placement <- lsts[idx] + lens[(idx - 1)] - 1

      new <- append(new, .x[[lsts[idx]]], after = placement)[-placement]
    }

    # Return
    new
  }
