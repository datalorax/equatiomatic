#' Generic function for extracting the right-hand side from a model
#'
#' @keywords internal
#'
#' @param model A fitted model
#' @param \dots additional arguments passed to the specific extractor
#' @noRd

extract_rhs <- function(model, ...) {
  UseMethod("extract_rhs", model)
}

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
#' @noRd
#' @export
#' @examples
#' \dontrun{
#' library(palmerpenguins)
#' mod1 <- lm(body_mass_g ~ bill_length_mm + species * flipper_length_mm, penguins)
#'
#' extract_rhs(mod1)
#' # > # A tibble: 7 x 8
#' # >                                 term     estimate ...           primary  subscripts
#' # > 1                        (Intercept) -3341.615846 ...
#' # > 2                     bill_length_mm    59.304539 ...    bill_length_mm
#' # > 3                   speciesChinstrap   -27.292519 ...           species   Chinstrap
#' # > 4                      speciesGentoo -2215.913323 ...           species      Gentoo
#' # > 5                  flipper_length_mm    24.962788 ... flipper_length_mm
#' # > 6 speciesChinstrap:flipper_length_mm    -3.484628 ... flipper_length_mm Chinstrap,
#' # > 7    speciesGentoo:flipper_length_mm    11.025972 ... flipper_length_mm    Gentoo,
#'
#' str(extract_rhs(mod1))
#' # > Classes ‘lm’ and 'data.frame':	7 obs. of  8 variables:
#' # >  $ term      : chr  "(Intercept)" "bill_length_mm" "speciesChinstrap" "speciesGentoo" ...
#' # >  $ estimate  : num  -3341.6 59.3 -27.3 -2215.9 25 ...
#' # >  $ std.error : num  810.14 7.25 1394.17 1328.58 4.34 ...
#' # >  $ statistic : num  -4.1247 8.1795 -0.0196 -1.6679 5.7534 ...
#' # >  $ p.value   : num  4.69e-05 5.98e-15 9.84e-01 9.63e-02 1.97e-08 ...
#' # >  $ split     :List of 7
#' # >   ..$ : chr "(Intercept)"
#' # >   ..$ : chr "bill_length_mm"
#' # >   ..$ : chr "speciesChinstrap"
#' # >   ..$ : chr "speciesGentoo"
#' # >   ..$ : chr "flipper_length_mm"
#' # >   ..$ : chr  "speciesChinstrap" "flipper_length_mm"
#' # >   ..$ : chr  "speciesGentoo" "flipper_length_mm"
#' # >  $ primary   :List of 7
#' # >   ..$ : chr
#' # >   ..$ : chr "bill_length_mm"
#' # >   ..$ : chr "species"
#' # >   ..$ : chr "species"
#' # >   ..$ : chr "flipper_length_mm"
#' # >   ..$ : chr  "species" "flipper_length_mm"
#' # >   ..$ : chr  "species" "flipper_length_mm"
#' # >  $ subscripts:List of 7
#' # >   ..$ : chr ""
#' # >   ..$ : chr ""
#' # >   ..$ : chr "Chinstrap"
#' # >   ..$ : chr "Gentoo"
#' # >   ..$ : chr ""
#' # >   ..$ : Named chr  "Chinstrap" ""
#' # >   .. ..- attr(*, "names")= chr [1:2] "species" "flipper_length_mm"
#' # >   ..$ : Named chr  "Gentoo" ""
#' # >   .. ..- attr(*, "names")= chr [1:2] "species" "flipper_length_mm"
#' }
#'
extract_rhs.default <- function(model) {
  # Extract RHS from formula
  formula_rhs <- labels(terms(formula(model)))

  # Extract unique (primary) terms from formula (no interactions)
  formula_rhs_terms <- formula_rhs[!grepl(":", formula_rhs)]

  # Extract coefficient names and values from model
  full_rhs <- broom::tidy(model)

  # Split interactions split into character vectors
  full_rhs$split <- strsplit(full_rhs$term, ":")

  full_rhs$primary <- extract_primary_term(
    formula_rhs_terms,
    full_rhs$term
  )

  full_rhs$subscripts <- extract_all_subscripts(
    full_rhs$primary,
    full_rhs$split
  )
  class(full_rhs) <- c("data.frame", class(model))
  full_rhs
}

#' @noRd
#' @export
extract_rhs.lmerMod <- function(model, return_variances) {
  # Extract RHS from formula
  formula_rhs <- labels(terms(formula(model)))

  # Extract unique (primary) terms from formula (no interactions)
  formula_rhs_terms <- formula_rhs[!grepl(":", formula_rhs)]
  formula_rhs_terms <- gsub("^`?(.+)`$?", "\\1", formula_rhs_terms)

  # Extract coefficient names and values from model
  if(return_variances) {
    full_rhs <- broom.mixed::tidy(model, scales = c("vcov", NA))
    
    # Make the names like they are sdcor, so it doesn't break other code
    full_rhs$term <- gsub("var__", "sd__", full_rhs$term)
    full_rhs$term <- gsub("cov__", "cor__", full_rhs$term)
  } else {
    full_rhs <- broom.mixed::tidy(model)  
  }
  
  full_rhs$term <- vapply(full_rhs$term, order_interaction,
    FUN.VALUE = character(1)
  )
  full_rhs$group <- recode_groups(full_rhs)

  full_rhs$original_order <- seq_len(nrow(full_rhs))
  full_rhs$term <- gsub("^`?(.+)`$?", "\\1", full_rhs$term)

  # Split interactions split into character vectors
  full_rhs$split <- strsplit(full_rhs$term, ":")
  
  
  full_rhs$primary <- lapply(full_rhs$term, function(x) "")
  full_rhs$primary[full_rhs$effect == "fixed"] <- extract_primary_term(
    formula_rhs_terms,
    full_rhs$term[full_rhs$effect == "fixed"]
  )

  # make sure split and primary are in the same order
  full_rhs$primary[full_rhs$effect == "fixed"] <- Map(
    function(prim, splt) {
      ord <- vapply(prim, function(x) grep(x, splt), FUN.VALUE = integer(1))
      names(sort(ord))
    },
    full_rhs$primary[full_rhs$effect == "fixed"],
    full_rhs$split[full_rhs$effect == "fixed"]
  )

  full_rhs$subscripts <- lapply(full_rhs$term, function(x) "")
  full_rhs$subscripts[full_rhs$effect == "fixed"] <- extract_all_subscripts(
    full_rhs$primary[full_rhs$effect == "fixed"],
    full_rhs$split[full_rhs$effect == "fixed"]
  )
  
  group_coefs <- detect_group_coef(model, full_rhs)
  all_terms <- unique(unlist(full_rhs$primary[full_rhs$effect == "fixed"]))
  l1_terms <- setdiff(all_terms, names(group_coefs))
  l1_terms <- setNames(rep("l1", length(l1_terms)), l1_terms)
  
  var_levs <- c(l1_terms, group_coefs)
  
  full_rhs$pred_level <- lapply(full_rhs$primary, function(x) {
    var_levs[names(var_levs) %in% x]
  })

  full_rhs$pred_level[full_rhs$effect == "fixed"] <- Map(
    function(predlev, splt) {
      ord <- vapply(names(predlev), function(x) grep(x, splt), FUN.VALUE = integer(1))
      ord <- names(sort(ord))
      predlev[ord]
    },
    full_rhs$pred_level[full_rhs$effect == "fixed"],
    full_rhs$split[full_rhs$effect == "fixed"]
  )

  full_rhs$l1 <- vapply(full_rhs$pred_level, function(x) {
    length(x) > 0 & all(x == "l1")
  }, FUN.VALUE = logical(1))
  full_rhs$l1 <- ifelse(full_rhs$term == "(Intercept)",
    TRUE,
    full_rhs$l1
  )

  full_rhs$crosslevel <- detect_crosslevel(
    full_rhs$primary,
    full_rhs$pred_level
  )


  class(full_rhs) <- c("data.frame", class(model))
  full_rhs
}

#' @noRd
#' @export
extract_rhs.glmerMod <- function(model, ...) {
  extract_rhs.lmerMod(model, ...)
}

#' Extract right-hand side of an forecast::Arima object
#'
#' Extract a dataframe of S/MA components
#'
#' @keywords internal
#'
#' @inheritParams extract_eq
#'
#' @return A dataframe
#' @noRd
extract_rhs.forecast_ARIMA <- function(model, ...) {
  # RHS of ARIMA is the Moving Average side
  # Consists of a Non-Seasonal MA (p), Seasonal MA (P), Seasonal Differencing.

  # This is more than needed, but we"re being explicit for readability.
  # Orders structure in Arima model: c(p, q, P, Q, m, d, D)
  ords <- model$arma
  names(ords) <- c("p", "q", "P", "Q", "m", "d", "D")

  # Following the rest of the package.
  # Pull the full model with broom::tidy
  full_mdl <- broom::tidy(model)

  # Filter down to only the MA terms and seasonal drift
  full_rhs <- full_mdl[grepl("^s?ma", full_mdl$term), ]

  # Add a Primary column and set it to the backshift operator.
  full_rhs$primary <- "B"

  # Get the superscript for the backshift operator.
  ## This is equal to the number on the term for MA
  ## and the number on the term * the seasonal frequency for SMA.
  ## Powers of 1 are replaced with an empty string.
  rhs_super <- as.numeric(gsub("^s?ma", "", full_rhs$term))
  rhs_super[grepl("^sma", full_rhs$term)] <- rhs_super[grepl("^sma", full_rhs$term)] * ords["m"]

  rhs_super <- as.character(rhs_super)

  full_rhs$superscript <- rhs_super

  # The RHS (MA side) has no differencing.
  # Previous versions of this function were erroneous
  # in that it included a seasonal difference on this side.

  # Reduce any "1" superscripts to not show the superscript
  full_rhs[full_rhs$superscript == "1", "superscript"] <- ""

  # Set subscripts so that create_term works later
  full_rhs$subscripts <- ""

  # Set the class
  class(full_rhs) <- c(class(model), "data.frame")

  # Explicit return
  return(full_rhs)
}


order_interaction <- function(interaction_term) {
  if (grepl("^cor__", interaction_term)) {
    ran_part <- gsub("(.+\\.).+", "\\1", interaction_term)
    interaction_term <- gsub(ran_part, "", interaction_term, fixed = TRUE)
  } else if (grepl("^sd__", interaction_term)) {
    ran_part <- "sd__"
    interaction_term <- gsub(paste0("^", ran_part), "", interaction_term)
  }
  terms <- strsplit(interaction_term, ":")[[1]]
  terms_ordered <- sort(terms)
  out <- paste0(terms_ordered, collapse = ":")

  if (exists("ran_part")) {
    # check/handle if there's an interaction in the random part
    # sd or cor
    type <- gsub("(^.+__).+", "\\1", ran_part)

    # remove type and period at end
    ran <- gsub(type, "", ran_part)
    ran <- gsub("\\.$", "", ran)

    # handle interaction (if present)
    ran <- strsplit(ran, ":")[[1]]
    ran <- paste0(sort(ran), collapse = ":")

    # paste it all back together
    if (grepl("^cor", ran_part)) {
      out <- paste0(type, ran, ".", out)
    } else {
      out <- paste0(type, ran, out)
    }
  }
  out
}

recode_groups <- function(rhs) {
  rhs_splt <- split(rhs, rhs$group)
  rhs_splt <- rhs_splt[!grepl("Residual", names(rhs_splt))]

  names_collapsed <- collapse_groups(names(rhs_splt))

  intercept_vary <- vapply(rhs_splt, function(x) {
    any(grepl("sd__(Intercept)", x$term, fixed = TRUE))
  }, FUN.VALUE = logical(1))

  check <- split(intercept_vary, names_collapsed)

  # collapse these groups
  collapse <- vapply(check, all, FUN.VALUE = logical(1))

  collapse_term <- function(term, v) {
    ifelse(grepl(term, v), collapse_groups(v), v)
  }

  out <- rhs$group
  for (i in seq_along(collapse[!collapse])) {
    out <- collapse_term(names(collapse[!collapse])[i], out)
  }
  out
}

collapse_groups <- function(group) {
  gsub("(.+)\\.\\d\\d?$", "\\1", group)
}

order_split <- function(split, pred_level) {
  if (length(pred_level) == 0) {
    return(pred_level)
  }
  var_order <- vapply(names(pred_level), function(x) {
    exact <- split %in% x
    detect <- grepl(x, split)

    # take exact if it's there, if not take detect
    if (any(exact)) {
      out <- exact
    } else {
      out <- detect
    }

    seq_along(out)[out]
  }, FUN.VALUE = integer(1))

  split[var_order]
}

#' Pull just the random variables
#' @param rhs output from \code{extract_rhs}
#' @keywords internal
#' @noRd
extract_random_vars <- function(rhs) {
  order <- rhs[rhs$group != "Residual", ]
  order <- sort(tapply(order$original_order, order$group, min))

  vc <- rhs[rhs$group != "Residual" & rhs$effect == "ran_pars", ]
  splt <- split(vc, vc$group)[names(order)]

  lapply(splt, function(x) {
    vars <- x[!grepl("cor__", x$term), ]
    gsub("sd__(.+)", "\\1", vars$term)
  })
}


detect_crosslevel <- function(primary, pred_level) {
  mapply_lgl(function(prim, predlev) {
    if (length(prim) > 1) {
      if (length(prim) != length(predlev)) {
        TRUE
      } else if (length(unique(predlev)) != 1) {
        TRUE
      } else {
        FALSE
      }
    } else {
      FALSE
    }
  },
  prim = primary,
  predlev = pred_level
  )
}

#### Consider refactoring the below too
detect_covar_level <- function(predictor, group) {
  nm <- names(group)
  v <- paste(predictor, group[, 1], sep = " _|_ ")
  unique_v <- unique(v)
  test <- gsub(".+\\s\\_\\|\\_\\s(.+)", "\\1", unique_v)

  if (all(!duplicated(test))) {
    return(nm)
  }
}

detect_X_level <- function(X, group) {
  lapply(X, detect_covar_level, group)
}

collapse_list <- function(x, y) {
  null_x <- vapply(x, function(x) {
    if (any(is.null(x))) {
      return(is.null(x))
    } else {
      return(is.na(x))
    }
  }, FUN.VALUE = logical(1))

  null_y <- vapply(y, function(x) {
    if (any(is.null(x))) {
      return(is.null(x))
    } else {
      return(is.na(x))
    }
  }, FUN.VALUE = logical(1))

  y[null_x & !null_y] <- y[null_x & !null_y]
  y[!null_x & null_y] <- x[!null_x & null_y]
  y[!null_x & !null_y] <- x[!null_x & !null_y]

  unlist(lapply(y, function(x) ifelse(is.null(x), NA_character_, x)))
}

detect_group_coef <- function(model, rhs) {
  outcome <- all.vars(formula(model))[1]
  d <- model@frame

  random_lev_names <- names(extract_random_vars(rhs))
  random_levs <- unlist(strsplit(random_lev_names, ":"))
  random_levs <- gsub("^\\(|\\)$", "", random_levs)
  random_levs <- unique(collapse_groups(random_levs))

  random_lev_ids <- d[random_levs]
  ranef_order <- vapply(random_lev_ids, function(x) {
    length(unique(x))
  }, FUN.VALUE = numeric(1))
  ranef_order <- rev(sort(ranef_order))
  random_lev_ids <- random_lev_ids[, names(ranef_order), drop = FALSE]

  X <- d[!(names(d) %in% c(random_levs, outcome))]

  lev_assign <- vector("list", length(random_levs))
  for (i in seq_along(random_lev_ids)) {
    lev_assign[[i]] <- detect_X_level(X, random_lev_ids[, i, drop = FALSE])
  }

  levs <- Reduce(collapse_list, rev(lev_assign))

  # reassign acutal names (in cases where ranef contains ":")
  out <- random_lev_names[match(levs, random_levs)]
  names(out) <- names(levs)

  unlist(out[!is.na(out)])
}







#' Extract the primary terms from all terms
#'
#' @inheritParams detect_primary
#'
#' @keywords internal
#'
#' @param all_terms A list of all the equation terms on the right hand side,
#'   usually the result of \code{broom::tidy(model, quick = TRUE)$term}.
#' @examples
#' \dontrun{
#' primaries <- c("partyid", "age", "race")
#'
#' full_terms <- c(
#'   "partyidDon't know", "partyidOther party", "age",
#'   "partyidNot str democrat", "age", "raceBlack", "age", "raceBlack"
#' )
#'
#' extract_primary_term(primaries, full_terms)
#' }
#' @noRd

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
#' @examples
#' \dontrun{
#' detect_primary("partyidStrong republican", c("partyid", "age", "race"))
#' detect_primary("age", c("partyid", "age", "race"))
#' detect_primary("raceBlack", c("partyid", "age", "race"))
#' }
#' @noRd

detect_primary <- function(full_term, primary_term_v) {
  if (full_term %in% primary_term_v) {
    primary_term_v %in% full_term
  } else {
    vapply(
      primary_term_v, function(indiv_term) {
        grepl(indiv_term, full_term, fixed = TRUE)
      },
      logical(1)
    )
  }
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
#' @examples
#' \dontrun{
#' p_list <- list(
#'   "partyid",
#'   c("partyid", "age"),
#'   c("age", "race"),
#'   c("partyid", "age", "race")
#' )
#'
#' ft_list <- list(
#'   "partyidNot str republican",
#'   c("partyidInd,near dem", "age"),
#'   c("age", "raceBlack"),
#'   c("partyidInd,near dem", "age", "raceBlack")
#' )
#'
#' extract_all_subscripts(p_list, ft_list)
#' }
#' @noRd

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
#' @examples
#' \dontrun{
#' extract_subscripts("partyid", "partyidDon't know")
#' extract_subscripts(
#'   "partyid",
#'   c(
#'     "partyidDon't know", "partyidOther party",
#'     "partyidNot str democrat"
#'   )
#' )
#' }
#' @noRd

extract_subscripts <- function(primary, full_term_v) {
  out <- switch(as.character(length(primary)),
    "0" = "",
    "1" = gsub(primary, "", full_term_v, fixed = TRUE),
    mapply_chr(function(x, y) gsub(x, "", y, fixed = TRUE),
      x = primary,
      y = full_term_v
    )
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
#' @noRd

wrap_rhs <- function(model, tex, ...) {
  UseMethod("wrap_rhs", model)
}

#' @export
#' @keywords internal
#' @noRd
wrap_rhs.default <- function(model, tex, ...) {
  return(tex)
}

#' @export
#' @keywords internal
#' @noRd
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
#' @noRd
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
#' @noRd
wrap_rhs.clm <- function(model, tex, ...) {
  if (model$info$link == "probit") {
    rhs <- probitify(tex)
  } else {
    rhs <- tex
  }

  return(rhs)
}

#' @keywords internal
#' @noRd
probitify <- function(tex) {
  # Replace existing beginning-of-line \quad space with `\\qquad\` to account for \Phi
  tex <- gsub("&\\\\quad", "&\\\\qquad\\\\", tex)

  # It would be cool to use \left[ and \right] someday, but they don't work when
  # the equation is split across multiple lines (see
  # https://tex.stackexchange.com/q/21290/11851)
  paste0("\\Phi[", tex, "]")
}
