test_that("interaction-only predictors appear in lm equations", {
  data <- expand.grid(age = 1:5, smoking = 0:1)
  data$y <- 1 + data$age * (2 + data$smoking) + sin(data$age)
  interaction <- "\\operatorname{age} \\times \\operatorname{smoking}"

  models <- list(
    lm(y ~ age + smoking:age - 1, data = data),
    lm(y ~ age + smoking:age, data = data)
  )
  for (model in models) {
    expect_match(as.character(extract_eq(model)), interaction, fixed = TRUE)
  }

  interaction_only <- lm(y ~ smoking:age - 1, data = data)
  expect_match(
    as.character(extract_eq(interaction_only)),
    "\\operatorname{smoking} \\times \\operatorname{age}",
    fixed = TRUE
  )
})

test_that("interaction-only factors retain their levels in lm equations", {
  data <- expand.grid(age = 1:5, smoker = factor(c("no", "smokeryes")))
  data$y <- 1 + data$age * as.integer(data$smoker) + sin(data$age)
  model <- lm(y ~ age + smoker:age - 1, data = data)

  expect_match(
    as.character(extract_eq(model)),
    "\\operatorname{age} \\times \\operatorname{smoker}_{\\operatorname{smokeryes}}",
    fixed = TRUE
  )
})
