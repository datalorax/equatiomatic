# glms
test_that("Logistic regression works", {
  set.seed(1234)
  df <- data.frame(
    outcome = sample(0:1, 300, replace = TRUE),
    categorical = rep(letters[1:3], 100),
    continuous_1 = rnorm(300, 100, 1),
    continuous_2 = rnorm(300, 50, 5)
  )

  model_logit <- glm(outcome ~ .,
    data = df,
    family = binomial(link = "logit")
  )

  # basic equation builds correctly
  expect_snapshot_output(extract_eq(model_logit))
})

test_that("Probit regression works", {
  set.seed(1234)
  df <- data.frame(
    outcome = sample(0:1, 300, replace = TRUE),
    categorical = rep(letters[1:3], 100),
    continuous_1 = rnorm(300, 100, 1),
    continuous_2 = rnorm(300, 50, 5)
  )

  model_probit <- glm(outcome ~ .,
    data = df,
    family = binomial(link = "probit")
  )

  # basic equation builds correctly
  expect_snapshot_output(extract_eq(model_probit))

  # Everything works when there are no categorical variables
  # equation sans categorical variables builds correctly
  model_gaussian <- glm(mpg ~ cyl + disp, data = mtcars, family = gaussian())
  expect_snapshot_output(extract_eq(model_gaussian))
})

test_that("Unsupported GLMs create a message", {
  model_gaussian <- glm(mpg ~ cyl + disp, data = mtcars, family = gaussian())
  model_gaussian$family$link <- "nothing"

  expect_message(extract_eq(model_gaussian))
})

test_that("Distribution-based equations work", {
  set.seed(1234)
  df <- data.frame(
    outcome = sample(0:1, 300, replace = TRUE),
    categorical = rep(letters[1:3], 100),
    continuous_1 = rnorm(300, 100, 1),
    continuous_2 = rnorm(300, 50, 5)
  )

  model_logit <- glm(outcome ~ .,
    data = df,
    family = binomial(link = "logit")
  )

  model_probit <- glm(outcome ~ .,
    data = df,
    family = binomial(link = "probit")
  )

  expect_snapshot_output(extract_eq(model_logit, show_distribution = TRUE))
  expect_snapshot_output(extract_eq(model_probit, show_distribution = TRUE))

  # Everything works when there are no categorical variables
  # equation sans categorical variables builds correctly
  model_gaussian <- glm(mpg ~ cyl + disp, data = mtcars, family = gaussian())
  expect_snapshot_output(extract_eq(model_gaussian, show_distribution = TRUE))
})

test_that("Weights work", {
  set.seed(1234)
  df <- data.frame(
    outcome = sample(0:1, 300, replace = TRUE),
    categorical = rep(letters[1:3], 100),
    continuous_1 = rnorm(300, 100, 1),
    continuous_2 = rnorm(300, 50, 5),
    weight = rep(c(1, 2), 150)
  )

  model_logit <- glm(outcome ~ .,
    data = df, weights = weight,
    family = binomial(link = "logit")
  )

  expect_warning(extract_eq(model_logit, show_distribution = TRUE))
})

test_that("non-binomial regression works", {
  set.seed(1234)
  df <- data.frame(
    outcome = sample(0:15, 300, replace = TRUE),
    categorical = rep(letters[1:3], 100),
    continuous_1 = rnorm(300, 100, 1),
    continuous_2 = rnorm(300, 50, 5)
  )

  model_log <- glm(outcome ~ .,
    data = df,
    family = poisson(link = "log")
  )

  # basic log equation builds correctly
  expect_snapshot_output(extract_eq(model_log))

  expect_message(extract_eq(model_log, show_distribution = TRUE))

  model_id <- glm(outcome ~ .,
    data = df,
    family = gaussian(link = "identity")
  )
  expect_snapshot_output(extract_eq(model_log))

  # basic equation with offset builds correctly
  model_offset <- glm(outcome ~ . + offset(rep(1, 300)),
    data = df,
    family = poisson(link = "log")
  )
  expect_snapshot_output(extract_eq(model_offset))
})
