###################################################################### BEGIN
# This file contains generics and defaults defined in equatiomatic. Extensions
# of these generics are contained in their class files or in the model files.
# DO NOT include extensions here. The exception are base classes (e.g. data.frame)

##########################
# convert2terms
##########################

#' @title
#' 'LaTeX' code for R models
#'
#' @description
#' \Sexpr[results=rd, stage=render]{rlang:::lifecycle("maturing")}
#'
#' @details
#' Extract the variable names from a model to produce a 'LaTeX' equation, which is
#' output to the screen. Supports any model supported by
#' [broom::tidy][broom::tidy].
#'
#' Implementations for different models may have additional arguments. Please
#' see model-specific documentation for a description of those arguments.
#'
#' @param .model A fitted model.
#' @param .ital_vars A logical. Setting to \code{TRUE} will use standard latex
#'   parsing for text (italicized). Default is \code{FALSE}.
#' @param .wrap A logical. When set to \code{TRUE}, will wrap equations where
#'   possible. Default is \code{FALSE}.
#' @param .terms_per_line An integer. The number of allowable terms per line.
#'   Used only when \code{.wrap = TRUE}. Default is \code{4}.
#' @param .operator_location One of \code{c("start", "end")}. Determines if a
#'   wrapped operator will end a line or start on the next one. Default is
#'   \dQuote{end}.
#' @param .align_env One of \code{c("aligned", "aligned*", "align", "align*")}.
#'   TeX environment to wrap around equation. Default is \dQuote{aligned}.
#' @param .use_coefs A logical. Toggle use of model coefficients (estimates) or
#'   mathematical representations. Default is \code{FALSE}.
#' @param .coef_digits An integer. The number of decimal places to round to when
#'   displaying model coefficients (estimates). Default is \code{2}.
#' @param .fix_signs A logical. If \code{FALSE}, coefficient estimates that are
#'   negative are preceded with a "+" (e.g. `5(x) + -3(z)`). If \code{TRUE}, the
#'   "+ -" is replaced with a "-" (e.g. `5(x) - 3(z)`). Default is \code{FALSE}.
#' @param .font_size The font size of the equation. Defaults to default of
#'   the output format. Takes any of the standard LaTeX arguments (see
#'   [here](https://www.overleaf.com/learn/latex/Font_sizes,_families,_and_styles#Font_styles)).
#' @param ... Additional arguments used by model implementations.
#'
#' @return A character of class \dQuote{equation}.
#'
#' @family extraction functions
#'
#' @export
extract_eq <-
  function(
    .model,
    .ital_vars = FALSE,
    .wrap = FALSE,
    .terms_per_line = 4,
    .operator_location = "end",
    .align_env = "aligned",
    .use_coefs = FALSE,
    .coef_digits = 2,
    .fix_signs = TRUE,
    .font_size
  ) {
    UseMethod("extract_eq", model)
  }


#' @describeIn extract_eq Throws and error if a method isn't found.
extract_eq.default <-
  function(
    .model,
    .ital_vars = FALSE,
    .wrap = FALSE,
    .terms_per_line = 4,
    .operator_location = "end",
    .align_env = "aligned",
    .use_coefs = FALSE,
    .coef_digits = 2,
    .fix_signs = TRUE,
    .font_size
  ) {
    stop(
      paste(
        "A extract_eq() method for classes",
        paste( class(.x), collapse = ", "),
        "has not been developed.",
        sep=" "
      ),
      call. = FALSE
    )
  }


##########################
# convert2terms
##########################
#' @title
#' Convert to `eq_term`
#'
#' @description
#' Converts a compatible classed object or subclass to an `eq_term` or list of
#' `eq_term`.
#'
#' @keywords internal
#'
#' @param .x A convertible object (e.g. a [broom:tidy()] `tbl_df`).
#' @param .include A character vector of additional columns (etc.) to include as
#'   properties of the `eq_term` class. If missing, will include all columns
#'   (etc.) as properties.
#' @param ... Other arguments that may be used by downstream functions.
#'
#' @return A `eq_term` classed list or list of `eq_term` classed lists.
#'
#' @seealso \link{as.eq_term} wraps this function.
#'
#' @family extensibility functions
#' @family convert2terms functions
#'
#' @examples
#' df <- data.frame(
#'     term = c("ar1", "ma1", "drift"),
#'     estimate = c(0.02, 0.1, 0.3)
#' )
#'
#' convert2terms(df)
#'
#' @export
convert2terms <-
  function(
    .x,
    .include,
    ...
  ) {
    UseMethod("convert2terms")
  }

#' @describeIn convert2terms Throws an error if a method isn't found.
convert2terms.default <-
  function(
    .x,
    ...
  ) {
    # Provide a warning
    stop(
      paste(
        "A eq_terms conversion method for",
        paste( class(.x), collapse = ", "),
        "has not been developed.",
        sep=" "
      ),
      call. = FALSE
    )
  }

#' @describeIn convert2terms Converts `data.frame` to a list of `eq_term`.
#' @method convert2terms data.frame
#' @export
convert2terms.data.frame <-
  function(
    .x,
    .include,
    ...
  ) {
    # Expect at least term and estimate
    # Other broom::tidy columns are ignored

    # Check Parameters
    required_params <- c("term", "estimate")

    ## Check for minimum columns from broom::tidy
    if( !all( required_params %in% names(.x) ) ) {
      stop(
        "Argument `.x` does not contain the columns `term` and `estimate`. These are required, at a minimum, to convert a `tbl_df` to a list of `eq_term` objects.",
        call. = FALSE
      )
    }

    # Coercion
    if(missing(.include)) { .include <- names(.x) }
    else { .include <- unique( c(required_params, .include) ) }

    # Main Function
    # Convert dataframe to list of records
    .x <- do.call("mapply", c(list, .x, SIMPLIFY = FALSE, USE.NAMES=TRUE))

    # Convert to eq_terms and return
    lapply(
      .x,
      function(
        rcd
      ) {
        # NOTE: pulls .include from 1 env up.
        # Relies on the fact that an eq_term can be created without the required
        # arguments.
        init_term <- eq_term()
        init_term[.include] <- rcd[.include]

        # Return
        init_term
      }
    )
  }


#' @rdname convert2terms
as.eq_term <-
  function(
    .x,
    .include,
    ...
  ) {
    convert2terms(.x, .include, ...)
  }

##########################
# convert2latex
##########################

#' @title
#' Convert to Latex
#'
#' @description
#' Converts a compatible classed object or subclass to a latex-friendly
#' character string.
#'
#' @details
#' Since class-specific methods of this generic may have a wide variety of
#' arguments, these methods will have separate documentation pages. For example,
#' \link{convert2latex.eq_term()} is a separate document Use
#' `?convert2latex.<class name>` or the \emph{See Also} section below.
#'
#' @keywords internal
#'
#' @param .x A convertible object (e.g. an `eq_term` object).
#' @param ... Other arguments that may be used by downstream functions.
#'
#' @return A latex-friendly character (string) representation of the term.
#'
#'
#' @family extensibility functions
#' @family convert2latex functions
#'
#' @examples
#' my_term <- eq_term(
#'     term = "sma", estimate = 0.25, variable = "\\phi",
#'     subscript = 2, superscript = "(i)"
#' )
#'
#' convert2latex(.x = my_term)
#'
#' @export
convert2latex <-
  function(
    .x,
    ...
  ) {
    UseMethod("convert2latex")
  }

#' @describeIn convert2latex Returns as.character(.x) and serves a warning.
#' @export
convert2latex.default <-
  function(
    .x,
    ...
  ) {
    # Provide a warning
    warning(
      paste(
        "A latex conversion method for",
        paste("class(", paste0(class(.x), collapse = ", "), ")"),
        "has not been developed.",
        sep=" "
      )
    )

    # Return character
    as.character(.x)
  }


##########################
# wrap_eq
##########################
#' @title
#' Wraps terms.
#'
#' @description
#' Consolidation of wrapping logic.
#'
#' @keywords internal
#'
#' @param .x An equatiomatic term object (e.g. eq_equation or eq_line).
#' @param .chrs A list of characters. List of converted terms that will be modified and returned.
#' @param .terms_per_line An integer. The number of allowable terms per line.
#'   Used only when \code{.wrap = TRUE}. Default is \code{4}.
#' @param .operator_location One of \code{c("start", "end")}. Determines if a
#'   wrapped operator will end a line or start on the next one. Default is
#'   \dQuote{end}.
#' @param ... Other arguments that may be used by downstream functions.
#'
#' @return A `eq_term` classed list or list of `eq_term` classed lists.
#'
#' @family extensibility functions
#' @family equatiomatic utility functions
#'
#'
#' @export
wrap_eq <-
  function(
    .x,
    .chrs,
    .terms_per_line,
    .operator_location,
    ...
  ) {
    UseMethod("wrap_eq")
  }

#' @describeIn wrap Default wrapping logic.
wrap_eq.default <-
  function(
    .x,
    .chrs,
    .terms_per_line,
    .operator_location,
    ...
  ) {
    # Apply terms_per_line
    ## eq_line is always wrapped by default and excluded from count.
    eq_lines <- vapply(.x$terms, function(obj){ inherits(obj, "eq_line")}, logical(1) )
    wrapable <- .wrapable & !eq_lines

    wrapable <- cumsum(.x$wrapable) %% .terms_per_line

    wrap_loc <- which( (wrapable == 0 & .x$wrapable) | eq_lines )

    # Wrap by operator location
    ## Operator at start
    if (.operator_location == "start") {
      # Add new line before the wrapable operator
      .chrs[wrap_loc] <-
        paste0(
          rep("\\\\\n&\\quad", length(wrap_loc)),
          chrs[wrap_loc],
          sep = " "
        )
    }
    ## Operate at end / default
    else {
      # Add new line after the wrapable operator
      .chrs[wrap_loc] <-
        paste0(
          chrs[wrap_loc],
          rep("\\ + \\\\\n&\\quad ", length(wrap_loc)),
          sep = ""
        )
    }

    # Return
    .chrs
  }

##########################
# align_eq
##########################
#' @title
#' Applies align environment.
#'
#' @description
#' Consolidation of align environment logic.
#'
#' @keywords internal
#'
#' @param .chrs A list of characters. List of converted terms that will be modified and returned.
#' @param .align_env One of \code{c("aligned", "aligned*", "align", "align*")}.
#'   TeX environment to wrap around equation.
#' @param ... Other arguments that may be used by downstream functions.
#'
#' @return A `eq_term` classed list or list of `eq_term` classed lists.
#'
#' @family extensibility functions
#' @family equatiomatic utility functions
#'
#'
#' @export
align_eq <-
  function(
    .chrs,
    .align_env,
    ...
  ) {
    UseMethod("align_eq")
  }

#' @describeIn wrap Default wrapping logic.
align_eq.default <-
  function(
    .chrs,
    .align_env,
    ...
  ) {
    # TODO
    # Return
    .chrs
  }


###################################################################### END
