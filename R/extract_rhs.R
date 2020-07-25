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
#' mod1 <- lm(Sepal.Length ~ Sepal.Width + Species * Petal.Length, iris)
#'
#' extract_rhs(mod1)
#' #> # A tibble: 7 x 4
#' #>   term                             estimate primary   subscripts
#' #>   <chr>                               <dbl> <list>    <list>
#' #> 1 (Intercept)                     2.925732  <chr [0]> <chr [1]>
#' #> 2 Sepal.Width                     0.4500064 <chr [1]> <chr [1]>
#' #> 3 Speciesversicolor              -1.047170  <chr [1]> <chr [1]>
#' #> 4 Speciesvirginica               -2.618888  <chr [1]> <chr [1]>
#' #> 5 Petal.Length                    0.3677469 <chr [1]> <chr [1]>
#' #> 6 Speciesversicolor:Petal.Length  0.2920936 <chr [2]> <chr [2]>
#' #> 7 Speciesvirginica:Petal.Length   0.5225336 <chr [2]> <chr [2]>
#'
#' str(extract_rhs(mod1))
#' #> Classes ‘tbl_df’, ‘tbl’ and 'data.frame': 7 obs. of  4 variables:
#' #>  $ term      : chr  "(Intercept)" "Sepal.Width" "Speciesversicolor" "Speciesvirginica" ...
#' #> $ estimate  : num  2.926 0.45 -1.047 -2.619 0.368 ...
#' #> $ primary   :List of 7
#' #>  ..$ : chr
#' #>  ..$ : chr "Sepal.Width"
#' #>  ..$ : chr "Species"
#' #>  ..$ : chr "Species"
#' #>  ..$ : chr "Petal.Length"
#' #>  ..$ : chr  "Species" "Petal.Length"
#' #>  ..$ : chr  "Species" "Petal.Length"
#' #> $ subscripts:List of 7
#' #>  ..$ : chr ""
#' #>  ..$ : chr ""
#' #>  ..$ : chr "versicolor"
#' #>  ..$ : chr "virginica"
#' #>  ..$ : chr ""
#' #>  ..$ : Named chr  "versicolor:Petal.Length" "Speciesversicolor:"
#' #>  .. ..- attr(*, "names")= chr  "Species" "Petal.Length"
#' #>  ..$ : Named chr  "virginica:Petal.Length" "Speciesvirginica:"
#' #>  .. ..- attr(*, "names")= chr  "Species" "Petal.Length"
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
    grepl(indiv_term, full_term)
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
                "1" = gsub(primary, "", full_term_v),
                mapply_chr(function(x, y) gsub(x, "", y),
                           x = primary,
                           y = full_term_v)
  )
  out
}
