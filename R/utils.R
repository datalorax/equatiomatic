
detect_categorical <- function(formula_rhs, full_rhs) {
  vapply(formula_rhs, function(.x) {
    sum(grepl(.x, full_rhs)) > 1
  },
  logical(1))
}

add_dummy_subscripts <- function(cat_vars, full_rhs, use_text = FALSE) {
  vars <- lapply(cat_vars, function(x) full_rhs[grepl(x, full_rhs)])
  levs <- Map(function(.x, .y) gsub(.x, "", .y),
              .x = cat_vars,
              .y = vars)
  if (use_text) {
    cats <- Map(function(var_name, lev) paste0(wrap_text(var_name), "_{", wrap_text(lev), "}"),
                var_name = names(levs),
                lev      = levs)
  } else {
    cats <- Map(function(var_name, lev) paste0(var_name, "_{", lev, "}"),
                var_name = names(levs),
                lev      = levs)
  }

  cats
}

wrap_text <- function(x) {
  paste0("\\text{", x, "}")
}
