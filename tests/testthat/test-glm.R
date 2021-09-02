test_that("colorizing works", {
  lr <- glm(sex ~ species * bill_length_mm,
            data = penguins,
            family = binomial(link = "logit")
  )
  
  pr <- glm(sex ~ species * bill_length_mm,
            data = penguins,
            family = binomial(link = "probit")
  )
  
  expect_snapshot_output(
    extract_eq(
      lr, 
      var_colors = c(
        sex = "#0073ff",
        species = "green"
      ),
      var_subscript_colors = c(species = "orange"),
      greek_colors = rainbow(6),
      subscript_colors = "blue",
      wrap = TRUE
    )
  )
  
  expect_snapshot_output(
    extract_eq(
      lr, 
      var_colors = c(
        sex = "#0073ff",
        species = "green"
      ),
      var_subscript_colors = c(species = "orange"),
      greek_colors = rainbow(6),
      subscript_colors = "blue",
      wrap = TRUE,
      show_distribution = TRUE
    )
  )
  
  expect_snapshot_output(
    extract_eq(
      pr, 
      var_colors = c(
        sex = "#0073ff",
        species = "green"
      ),
      var_subscript_colors = c(species = "orange"),
      greek_colors = rainbow(6),
      subscript_colors = "blue",
      wrap = TRUE
    )
  )
  
  expect_snapshot_output(
    extract_eq(
      pr, 
      var_colors = c(
        sex = "#0073ff",
        species = "green"
      ),
      var_subscript_colors = c(species = "orange"),
      greek_colors = rainbow(6),
      subscript_colors = "blue",
      wrap = TRUE,
      show_distribution = TRUE
    )
  )
})

test_that("Renaming Variables works", {
  set.seed(1234)
  df <- data.frame(
    outcome = sample(0:1, 100, replace = TRUE),
    categorical = rep(letters[1:5], 20),
    continuous_1 = rnorm(100, 100, 1),
    continuous_2 = rnorm(100, 50, 5)
  )
  
  m2 <- glm(outcome ~ categorical*continuous_1*continuous_2,
            data = df,
            family = binomial(link = "logit")
  )
  
  expect_snapshot_output(
    extract_eq(
      m2,
      swap_var_names = c(
        "categorical" = "cat",
        "continuous_1" = "Continuous Variable [1]"),
      swap_subscript_names = c(
        "a" = "aaaaaaaaa",
        "d" = "dddd"
      ),
      wrap = TRUE,
      terms_per_line = 2
    )
  )
})

test_that("Math extraction works", {
  set.seed(1234)
  df <- data.frame(
    outcome = sample(0:1, 100, replace = TRUE),
    continuous_1 = rnorm(100, 100, 1),
    continuous_2 = rnorm(100, 50, 5)
  )
  
  model_logit <- glm(outcome ~ log(continuous_1) + exp(continuous_2) +
                       poly(continuous_2, 3),
                     data = df,
                     family = binomial(link = "logit")
  )
  model_probit <- glm(outcome ~ log(continuous_1) + exp(continuous_2) +
                        poly(continuous_2, 3),
                      data = df,
                      family = binomial(link = "probit")
  )
  expect_snapshot_output(extract_eq(model_logit))
  expect_snapshot_output(extract_eq(model_probit))
})

test_that("Collapsing glm factors works", {
  set.seed(1234)
  df <- data.frame(
    outcome = sample(0:1, 100, replace = TRUE),
    categorical = rep(letters[1:5], 20),
    continuous_1 = rnorm(100, 100, 1),
    continuous_2 = rnorm(100, 50, 5)
  )
  
  model_logit <- glm(outcome ~ categorical*continuous_1*continuous_2,
                     data = df,
                     family = binomial(link = "logit")
  )
  model_probit <- glm(outcome ~ categorical*continuous_1*continuous_2,
                     data = df,
                     family = binomial(link = "probit")
  )
  
  # no collapsing
  expect_snapshot(extract_eq(model_logit))
  expect_snapshot(extract_eq(model_probit))
  
  # collapsing
  expect_snapshot(extract_eq(model_logit, index_factors = TRUE))
  expect_snapshot(extract_eq(model_probit, index_factors = TRUE))
})


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
