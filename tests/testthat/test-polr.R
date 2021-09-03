test_that("colorizing works", {
  mass_ologit <- MASS::polr(rating ~ temp * contact,
                            data = ordinal::wine
  )
  
  greek_col <- c("#1B9E77", "#D95F02", "#7570B3", "#E7298A", "#66A61E", 
                 "#E6AB02", "#A6761D", "#666666")
  
  expect_snapshot_output(
    extract_eq(
      mass_ologit,
      wrap = TRUE, 
      terms_per_line = 2,
      var_colors = c(temp = "blue"),
      var_subscript_colors = c(contact = "orange"),
      greek_colors = greek_col,
      subscript_colors = rev(greek_col)
    )
  )
})

test_that("Renaming Variables works", {
  df <- data.frame(
    outcome = factor(rep(LETTERS[1:3], 100),
                     levels = LETTERS[1:3],
                     ordered = TRUE
    ),
    categorical = rep(letters[1:5], 20),
    continuous = rnorm(300, 100, 1)
  )
  
  m4 <- MASS::polr(
    outcome ~ categorical*continuous,
    Hess = TRUE,
    data = df,
    method = "probit"
  )
  expect_snapshot_output(
    extract_eq(
      m4,
      swap_var_names = c(
        "categorical" = "catty",
        "continuous" = "Cont Var"),
      swap_subscript_names = c(
        "a" = "alabama arkansas",
        "d" = "do do do"
      ),
      wrap = TRUE,
      terms_per_line = 2
    )
  )
})

test_that("Math extraction works", {
  df <- data.frame(
    outcome = factor(rep(LETTERS[1:3], 100),
                     levels = LETTERS[1:3],
                     ordered = TRUE
    ),
    continuous = rnorm(300, 100, 1)
  )
  model_logit <- MASS::polr(
    outcome ~ poly(continuous, 3) + log(continuous),
    Hess = TRUE,
    data = df, 
    method = "logistic"
  )
  model_probit <- MASS::polr(
    outcome ~ poly(continuous, 3) + log(continuous),
    Hess = TRUE,
    data = df,
    method = "probit"
  )
  
  expect_snapshot_output(extract_eq(model_logit))
  expect_snapshot_output(extract_eq(model_probit))
})

test_that("Collapsing polr factors works", {
  df <- data.frame(
    outcome = factor(rep(LETTERS[1:3], 100),
                     levels = LETTERS[1:3],
                     ordered = TRUE
    ),
    categorical = rep(letters[1:5], 20),
    continuous = rnorm(300, 100, 1)
  )
  model_logit <- MASS::polr(
    outcome ~ categorical*continuous,
    Hess = TRUE,
    data = df, 
    method = "logistic"
  )
  model_probit <- MASS::polr(
    outcome ~ categorical*continuous,
    Hess = TRUE,
    data = df,
    method = "probit"
  )
  
  # no collapsing
  expect_snapshot(extract_eq(model_logit))
  expect_snapshot(extract_eq(model_probit))
  
  # collapsing
  expect_snapshot(extract_eq(model_logit, index_factors = TRUE))
  expect_snapshot(extract_eq(model_probit, index_factors = TRUE))
})

test_that("Ordered logistic regression works", {
  set.seed(1234)
  df <- data.frame(
    outcome = factor(rep(LETTERS[1:3], 100),
      levels = LETTERS[1:3],
      ordered = TRUE
    ),
    continuous_1 = rnorm(300, 100, 1),
    continuous_2 = rnorm(300, 50, 5)
  )

  model_polr <- MASS::polr(outcome ~ ., data = df, Hess = TRUE, method = "logistic")
  model_polr_probit <- MASS::polr(outcome ~ ., data = df, Hess = TRUE, method = "probit")

  # ordered logit builds correctly
  expect_snapshot_output(extract_eq(model_polr, wrap = FALSE))

  # ordered logit builds correctly in wrapped environment
  expect_snapshot_output(
    extract_eq(model_polr, wrap = TRUE, terms_per_line = 2)
  )

  # ordered probit builds correctly
  expect_snapshot_output(
    extract_eq(model_polr_probit, wrap = FALSE)
  )

  # ordered probit builds correctly in wrapped environment
  expect_snapshot_output(
    extract_eq(model_polr_probit, wrap = TRUE, terms_per_line = 2)
  )

  # ordered logit + coefs builds correctly
  expect_snapshot_output(extract_eq(model_polr, use_coefs = TRUE))
})
