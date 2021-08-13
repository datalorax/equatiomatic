test_that("Renaming Variables works", {
  df <- data.frame(
    outcome = factor(rep(LETTERS[1:3], 100),
                     levels = LETTERS[1:3],
                     ordered = TRUE
    ),
    categorical = rep(letters[1:5], 20),
    continuous = rnorm(300, 100, 1)
  )
  expect_warning(
    m3 <- ordinal::clm(outcome ~ categorical*continuous,
                       data = df, 
                       link = "logit"
    )
  )
  expect_snapshot_output(
    extract_eq(
      m3,
      swap_var_names = c("categorical" = "cat"),
      swap_subscript_names = c(
        "a" = "Hey look! A new subscript",
        "d" = "Don't look at me though"
      ),
      wrap = TRUE,
      terms_per_line = 2
    )
  )
})

test_that("Collapsing clm factors works", {
  df <- data.frame(
    outcome = factor(rep(LETTERS[1:3], 100),
                     levels = LETTERS[1:3],
                     ordered = TRUE
    ),
    categorical = rep(letters[1:5], 20),
    continuous = rnorm(300, 100, 1)
  )
  expect_warning(
    model_logit <- ordinal::clm(outcome ~ categorical*continuous,
                                data = df, link = "logit"
    )
  )
  expect_warning(
    model_probit <- ordinal::clm(outcome ~ categorical*continuous,
                                 data = df, link = "probit"
    )
  )
  
  # no collapsing
  expect_snapshot(extract_eq(model_logit))
  expect_snapshot(extract_eq(model_probit))
  
  # collapsing
  expect_snapshot(extract_eq(model_logit, index_factors = TRUE))
  expect_snapshot(extract_eq(model_probit, index_factors = TRUE))
})

test_that("Ordered models with clm work", {
  set.seed(1234)
  df <- data.frame(
    outcome = factor(rep(LETTERS[1:3], 100),
      levels = LETTERS[1:3],
      ordered = TRUE
    ),
    continuous_1 = rnorm(300, 1, 1),
    continuous_2 = rnorm(300, 5, 5)
  )

  model_logit <- ordinal::clm(outcome ~ continuous_1 + continuous_2,
    data = df, link = "logit"
  )
  model_probit <- ordinal::clm(outcome ~ continuous_1 + continuous_2,
    data = df, link = "probit"
  )

  expect_snapshot_output(extract_eq(model_logit, wrap = FALSE))
  expect_snapshot_output(extract_eq(model_logit, wrap = TRUE, terms_per_line = 2))
  expect_snapshot_output(extract_eq(model_probit, wrap = FALSE))
  expect_snapshot_output(extract_eq(model_probit, wrap = TRUE, terms_per_line = 2))

  # Coefficients instead of letters
  expect_snapshot_output(extract_eq(model_logit, use_coefs = TRUE))
})

test_that("Unsupported CLMs create a message", {
  set.seed(1234)
  df <- data.frame(
    outcome = factor(rep(LETTERS[1:3], 100),
      levels = LETTERS[1:3],
      ordered = TRUE
    ),
    continuous_1 = rnorm(300, 1, 1),
    continuous_2 = rnorm(300, 5, 5)
  )

  model <- ordinal::clm(outcome ~ continuous_1 + continuous_2,
    data = df, link = "cauchit"
  )

  expect_message(extract_eq(model))
})
