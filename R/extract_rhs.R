#' Extract right-hand side
#'
#' Extract a data frame with list columns for the primary terms and subscripts
#' from all terms in the model
#'
#' @keywords internal
#'
#' @param model A fitted model
#'
#' @return A list with one element per future equation term. Term components
#'   like subscripts are nested inside each list element. List elements with two
#'   or more terms are interactions.
#'
#' @examples \dontrun{
#' library(palmerpenguins)
#' mod1 <- lm(body_mass_g ~ bill_length_mm + species * flipper_length_mm, penguins)
#'
#' extract_rhs(mod1)
#' #> # A tibble: 7 x 8
#' #>                                 term     estimate ...           primary  subscripts
#' #> 1                        (Intercept) -3341.615846 ...
#' #> 2                     bill_length_mm    59.304539 ...    bill_length_mm
#' #> 3                   speciesChinstrap   -27.292519 ...           species   Chinstrap
#' #> 4                      speciesGentoo -2215.913323 ...           species      Gentoo
#' #> 5                  flipper_length_mm    24.962788 ... flipper_length_mm
#' #> 6 speciesChinstrap:flipper_length_mm    -3.484628 ... flipper_length_mm Chinstrap,
#' #> 7    speciesGentoo:flipper_length_mm    11.025972 ... flipper_length_mm    Gentoo,
#'
#' str(extract_rhs(mod1))
#' #> Classes ‘lm’ and 'data.frame':	7 obs. of  8 variables:
#' #>  $ term      : chr  "(Intercept)" "bill_length_mm" "speciesChinstrap" "speciesGentoo" ...
#' #>  $ estimate  : num  -3341.6 59.3 -27.3 -2215.9 25 ...
#' #>  $ std.error : num  810.14 7.25 1394.17 1328.58 4.34 ...
#' #>  $ statistic : num  -4.1247 8.1795 -0.0196 -1.6679 5.7534 ...
#' #>  $ p.value   : num  4.69e-05 5.98e-15 9.84e-01 9.63e-02 1.97e-08 ...
#' #>  $ split     :List of 7
#' #>   ..$ : chr "(Intercept)"
#' #>   ..$ : chr "bill_length_mm"
#' #>   ..$ : chr "speciesChinstrap"
#' #>   ..$ : chr "speciesGentoo"
#' #>   ..$ : chr "flipper_length_mm"
#' #>   ..$ : chr  "speciesChinstrap" "flipper_length_mm"
#' #>   ..$ : chr  "speciesGentoo" "flipper_length_mm"
#' #>  $ primary   :List of 7
#' #>   ..$ : chr
#' #>   ..$ : chr "bill_length_mm"
#' #>   ..$ : chr "species"
#' #>   ..$ : chr "species"
#' #>   ..$ : chr "flipper_length_mm"
#' #>   ..$ : chr  "species" "flipper_length_mm"
#' #>   ..$ : chr  "species" "flipper_length_mm"
#' #>  $ subscripts:List of 7
#' #>   ..$ : chr ""
#' #>   ..$ : chr ""
#' #>   ..$ : chr "Chinstrap"
#' #>   ..$ : chr "Gentoo"
#' #>   ..$ : chr ""
#' #>   ..$ : Named chr  "Chinstrap" ""
#' #>   .. ..- attr(*, "names")= chr [1:2] "species" "flipper_length_mm"
#' #>   ..$ : Named chr  "Gentoo" ""
#' #>   .. ..- attr(*, "names")= chr [1:2] "species" "flipper_length_mm"
#' }
#'

extract_rhs <- function(model) {
  # Extract RHS from formula
  formula_rhs <- labels(terms(formula(model)))

  # Extract unique (primary) terms from formula (no interactions)
  formula_rhs_terms <- formula_rhs[!grepl(":", formula_rhs)]

  # Extract coefficient names and values from model
  full_rhs <- broom::tidy(model)

  # Split interactions split into character vectors
  full_rhs$split <- strsplit(full_rhs$term, ":")

  full_rhs$primary <- extract_primary_term(formula_rhs_terms,
                                           full_rhs$term)

  full_rhs$subscripts <- extract_all_subscripts(full_rhs$primary,
                                                full_rhs$split)
  class(full_rhs) <- c("data.frame", class(model))
  full_rhs
}


#' Extract the primary terms from all terms
#'
#' @inheritParams detect_primary
#'
#' @keywords internal
#'
#' @param all_terms A list of all the equation terms on the right hand side,
#'   usually the result of \code{broom::tidy(model, quick = TRUE)$term}.
#' @examples \dontrun{
#' primaries <- c("partyid", "age", "race")
#'
#' full_terms <- c("partyidDon't know", "partyidOther party", "age",
#' "partyidNot str democrat", "age", "raceBlack", "age", "raceBlack")
#'
#' extract_primary_term(primaries, full_terms)
#' }

extract_primary_term <- function(primary_term_v, all_terms) {
  detected <- lapply(all_terms, detect_primary, primary_term_v)
  lapply(detected, function(pull) primary_term_v[pull])
}

#' Detect if a given term is part of a vector of full terms
#'
#' @keywords internal
#'
#' @param full_term The full name of a single term, e.g.,
#'   \code{"partyidOther party"}
#' @param primary_term_v A vector of primary terms, e.g., \code{"partyid"}.
#'   Usually the result of \code{formula_rhs[!grepl(":", formula_rhs)]}
#'
#' @return A logical vector the same length of \code{primary_term_v} indicating
#'   whether the \code{full_term} is part of the given \code{primary_term_v}
#'   element
#'
#' @examples \dontrun{
#' detect_primary("partyidStrong republican", c("partyid", "age", "race"))
#' detect_primary("age", c("partyid", "age", "race"))
#' detect_primary("raceBlack", c("partyid", "age", "race"))
#' }

detect_primary <- function(full_term, primary_term_v) {
  vapply(primary_term_v, function(indiv_term) {
    grepl(indiv_term, full_term, fixed = TRUE)
  },
  logical(1)
  )
}


#' Extract all subscripts
#'
#' @keywords internal
#'
#' @param primary_list A list of primary terms
#' @param full_term_list A list of full terms
#'
#' @return A list with the subscripts. If full term has no subscript,
#' returns \code{""}.
#'
#' @examples \dontrun{
#' p_list <- list("partyid",
#'                c("partyid", "age"),
#'                c("age", "race"),
#'                c("partyid", "age", "race"))
#'
#' ft_list <- list("partyidNot str republican",
#'                 c("partyidInd,near dem", "age"),
#'                 c("age", "raceBlack"),
#'                 c("partyidInd,near dem", "age", "raceBlack"))
#'
#' extract_all_subscripts(p_list, ft_list)
#' }

extract_all_subscripts <- function(primary_list, full_term_list) {
  Map(extract_subscripts, primary_list, full_term_list)
}


#' Extract the subscripts from a given term
#'
#' @keywords internal
#'
#' @param primary A single primary term, e.g., \code{"partyid"}
#' @param full_term_v A vector of full terms, e.g.,
#'   \code{c("partyidDon't know", "partyidOther party"}. Can be of length 1.
#' @examples \dontrun{
#' extract_subscripts("partyid", "partyidDon't know")
#' extract_subscripts("partyid",
#'                    c("partyidDon't know", "partyidOther party",
#'                      "partyidNot str democrat"))
#' }

extract_subscripts <- function(primary, full_term_v) {
  out <- switch(as.character(length(primary)),
                "0" = "",
                "1" = gsub(primary, "", full_term_v, fixed = TRUE),
                mapply_chr(function(x, y) gsub(x, "", y, fixed = TRUE),
                           x = primary,
                           y = full_term_v)
  )
  out
}

#' Generic function for wrapping the RHS of a model equation in something, like
#' how the RHS of probit is wrapped in φ()
#'
#' @keywords internal
#'
#' @param model A fitted model
#' @param tex The TeX version of the RHS of the model (as character), built as
#'   \code{rhs_combined} or \code{eq_raw$rhs} in \code{extract_eq()}
#' @param \dots additional arguments passed to the specific extractor

wrap_rhs <- function(model, tex, ...) {
  UseMethod("wrap_rhs", model)
}

#' @export
#' @keywords internal
wrap_rhs.default <- function(model, tex, ...) {
  return(tex)
}

#' @export
#' @keywords internal
wrap_rhs.glm <- function(model, tex, ...) {
  if (model$family$link == "probit") {
    rhs <- probitify(tex)
  } else {
    rhs <- tex
  }

  return(rhs)
}

#' @export
#' @keywords internal
wrap_rhs.polr <- function(model, tex, ...) {
  if (model$method == "probit") {
    rhs <- probitify(tex)
  } else {
    rhs <- tex
  }

  return(rhs)
}

#' @export
#' @keywords internal
wrap_rhs.clm <- function(model, tex, ...) {
  if (model$info$link == "probit") {
    rhs <- probitify(tex)
  } else {
    rhs <- tex
  }

  return(rhs)
}

#' @keywords internal
probitify <- function(tex) {
  # Replace existing beginning-of-line \quad space with `\\qquad\` to account for \Phi
  tex <- gsub("&\\\\quad", "&\\\\qquad\\\\", tex)

  # It would be cool to use \left[ and \right] someday, but they don't work when
  # the equation is split across multiple lines (see
  # https://tex.stackexchange.com/q/21290/11851)
  paste0("\\Phi[", tex, "]")
}
