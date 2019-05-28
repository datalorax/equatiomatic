
detect_categorical <- function(formula_rhs, full_rhs) {
  unique_vars <- full_rhs[!grepl(":", full_rhs)]
  vapply(formula_rhs, function(.x) {
    sum(grepl(.x, unique_vars)) > 1
  },
  logical(1))
}

add_dummy_subscripts <- function(cat_var_names, full_rhs, use_text = FALSE) {
  if(length(cat_var_names) == 0) {
    return(full_rhs)
  }
  vars <- lapply(cat_var_names, function(x) full_rhs[grepl(x, full_rhs)])

  splt <- lapply(full_rhs, function(x) strsplit(x, ":"))

  cats <- Map(subscript, splt, cat_var_names)
  cats <- unlist(cats)

  if (use_text) {
    splt2 <- lapply(cats, function(x) strsplit(x, " "))
    splt2 <- lapply(splt2, function(x) {
      lapply(x, wrap_text)
    })
    cats <- unlist(splt2, recursive = FALSE)
    cats <- lapply(cats, paste, collapse = " ")
    # cats <- Map(function(var_name, lev) paste0(wrap_text(var_name), "_{", wrap_text(lev), "}"),
    #             var_name = names(levs),
    #             lev      = levs)
  } #else {
  #   cats <- Map(function(var_name, lev) paste0(var_name, "_{", lev, "}"),
  #               var_name = names(levs),
  #               lev      = levs)
  # }

  cats
}

wrap_text <- function(x) {
  pst <- paste0("\\text{", x, "}")
  ifelse(x != "\times", pst, x)
}

subscript <- function(each_splt, cat_var_names) {
  lapply(each_splt, function(x) {
    vapply(cat_var_names, function(y) {
      subscript_levs(y, x)
    },
    character(1))
  })
}

subscript_levs <- function(cat_var_name, x) {
  subscripted <- gsub(paste0(cat_var_name, "(.+)"),
                      paste0(cat_var_name,"_{\\1}"),
                      x)
  if(length(x) > 1) {
    subscripted <- paste(subscripted, collapse = " \\times ")
  }
  subscripted
}

