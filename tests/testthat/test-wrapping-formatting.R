testthat::context("Wrapping and formatting")

test_that("Coefficient digits", {
  model_simple <- lm(mpg ~ cyl + disp, data = mtcars)

  tex <- extract_eq(model_simple, use_coefs = TRUE, coef_digits = 4)
  actual <- "\\text{mpg} = 34.661 - 1.5873(\\text{cyl}) - 0.0206(\\text{disp}) + \\epsilon"
  expect_equal(tex, equation_class(actual),
               label = "coefficient rounding works")
})
