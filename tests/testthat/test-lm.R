context("Linear models")

test_that("Simple lm models work", {
  model_simple <- lm(mpg ~ cyl + disp, data = mtcars)

  mtcars$gear <- as.factor(mtcars$gear)
  model_indicators <- lm(mpg ~ cyl + gear, data = mtcars)

  tex <- extract_eq(model_simple)
  actual <- "\\text{mpg} = \\alpha + \\beta_{1}(\\text{cyl}) + \\beta_{2}(\\text{disp}) + \\epsilon"
  expect_equal(tex, equation_class(actual),
               label = "basic equation builds correctly")

  tex <- extract_eq(model_simple, use_coefs = TRUE)
  actual <- "\\text{mpg} = 34.66 - 1.59(\\text{cyl}) - 0.02(\\text{disp}) + \\epsilon"
  expect_equal(tex, equation_class(actual),
               label = "basic equation + coefs builds correctly")

  tex <- extract_eq(model_indicators)
  actual <- "\\text{mpg} = \\alpha + \\beta_{1}(\\text{cyl}) + \\beta_{2}(\\text{gear}_{\\text{4}}) + \\beta_{3}(\\text{gear}_{\\text{5}}) + \\epsilon"
  expect_equal(tex, equation_class(actual),
               label = "categorical subscripts work")

})
