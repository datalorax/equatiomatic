context("GLMs")

test_that("Logistic regression works", {
  set.seed(1234)
  df <- data.frame(outcome = sample(0:1, 300, replace = TRUE),
                   categorical = rep(letters[1:3], 100),
                   continuous_1 = rnorm(300, 100, 1),
                   continuous_2 = rnorm(300, 50, 5))

  model_logit <- glm(outcome ~ ., data = df,
                     family = binomial(link = "logit"))

  tex <- extract_eq(model_logit)
  actual <- "\\log\\left[ \\frac { P( \\operatorname{outcome} = \\operatorname{1} ) }{ 1 - P( \\operatorname{outcome} = \\operatorname{1} ) } \\right] = \\alpha + \\beta_{1}(\\operatorname{categorical}_{\\operatorname{b}}) + \\beta_{2}(\\operatorname{categorical}_{\\operatorname{c}}) + \\beta_{3}(\\operatorname{continuous\\_1}) + \\beta_{4}(\\operatorname{continuous\\_2}) + \\epsilon"

  expect_equal(tex, equation_class(actual),
               label = "basic equation builds correctly")
})

test_that("Probit regression works", {
  set.seed(1234)
  df <- data.frame(outcome = sample(0:1, 300, replace = TRUE),
                   categorical = rep(letters[1:3], 100),
                   continuous_1 = rnorm(300, 100, 1),
                   continuous_2 = rnorm(300, 50, 5))

  model_probit <- glm(outcome ~ ., data = df,
                      family = binomial(link = "probit"))

  tex <- extract_eq(model_probit)
  actual <- "P(\\operatorname{outcome} = \\operatorname{1}) = \\Phi[\\alpha + \\beta_{1}(\\operatorname{categorical}_{\\operatorname{b}}) + \\beta_{2}(\\operatorname{categorical}_{\\operatorname{c}}) + \\beta_{3}(\\operatorname{continuous\\_1}) + \\beta_{4}(\\operatorname{continuous\\_2}) + \\epsilon]"

  expect_equal(tex, equation_class(actual),
               label = "basic equation builds correctly")
})

test_that("Unsupported GLMs create a message", {
  model_gaussian <- glm(mpg ~ cyl + disp, data = mtcars, family = gaussian())
  model_gaussian$family$link <- "nothing"

  expect_message(extract_eq(model_gaussian))
})
