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
