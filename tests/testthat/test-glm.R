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
  actual <- "\\log\\left[ \\frac { P( \\text{outcome} = \\text{1} ) }{ 1 - P( \\text{outcome} = \\text{1} ) } \\right] = \\alpha + \\beta_{1}(\\text{categorical}_{\\text{b}}) + \\beta_{2}(\\text{categorical}_{\\text{c}}) + \\beta_{3}(\\text{continuous\\_1}) + \\beta_{4}(\\text{continuous\\_2}) + \\epsilon"

  expect_equal(tex, equation_class(actual),
               label = "basic equation builds correctly")
})

test_that("Unsupported GLMs create a message", {
  model_gaussian <- glm(mpg ~ cyl + disp, data = mtcars, family = gaussian())
  model_gaussian$family$link <- "nothing"

  expect_message(extract_eq(model_gaussian))
})
