context("Linear models")

test_that("Simple lm models work", {
  model_simple <- lm(mpg ~ cyl + disp, data = mtcars)

  mtcars$gear <- as.factor(mtcars$gear)
  model_indicators <- lm(mpg ~ cyl + gear, data = mtcars)

  tex <- extract_eq(model_simple)
  actual <- "\\operatorname{mpg} = \\alpha + \\beta_{1}(\\operatorname{cyl}) + \\beta_{2}(\\operatorname{disp}) + \\epsilon"
  expect_equal(tex, equation_class(actual),
               label = "basic equation builds correctly")

  tex <- extract_eq(model_simple, use_coefs = TRUE)
  actual <- "\\operatorname{mpg} = 34.66 - 1.59(\\operatorname{cyl}) - 0.02(\\operatorname{disp}) + \\epsilon"
  expect_equal(tex, equation_class(actual),
               label = "basic equation + coefs builds correctly")

  tex <- extract_eq(model_indicators)
  actual <- "\\operatorname{mpg} = \\alpha + \\beta_{1}(\\operatorname{cyl}) + \\beta_{2}(\\operatorname{gear}_{\\operatorname{4}}) + \\beta_{3}(\\operatorname{gear}_{\\operatorname{5}}) + \\epsilon"
  expect_equal(tex, equation_class(actual),
               label = "categorical subscripts work")

})


test_that("Interactions work", {
  simple_int <- lm(body_mass_g ~ bill_length_mm*species, palmerpenguins::penguins)

  tex <- extract_eq(simple_int)
  actual <- "\\operatorname{body\\_mass\\_g} = \\alpha + \\beta_{1}(\\operatorname{bill\\_length\\_mm}) + \\beta_{2}(\\operatorname{species}_{\\operatorname{Chinstrap}}) + \\beta_{3}(\\operatorname{species}_{\\operatorname{Gentoo}}) + \\beta_{4}(\\operatorname{bill\\_length\\_mm} \\times \\operatorname{species}_{\\operatorname{Chinstrap}}) + \\beta_{5}(\\operatorname{bill\\_length\\_mm} \\times \\operatorname{species}_{\\operatorname{Gentoo}}) + \\epsilon"
  expect_equal(tex, equation_class(actual),
               label = "Basic interaction with subscripts")

  simple_int2 <- lm(mpg ~ hp*wt, mtcars)
  tex2 <- extract_eq(simple_int2)
  actual2 <- "\\operatorname{mpg} = \\alpha + \\beta_{1}(\\operatorname{hp}) + \\beta_{2}(\\operatorname{wt}) + \\beta_{3}(\\operatorname{hp} \\times \\operatorname{wt}) + \\epsilon"
  expect_equal(tex2, equation_class(actual2),
               label = "Basic interaction with no subscripts")
})


test_that("Custom Greek works", {
  model_simple <- lm(mpg ~ cyl + disp, data = mtcars)

  tex <- extract_eq(model_simple, greek = "\\hat{\\beta}", raw_tex = TRUE)
  actual <- "\\operatorname{mpg} = \\alpha + \\hat{\\beta}_{1}(\\operatorname{cyl}) + \\hat{\\beta}_{2}(\\operatorname{disp}) + \\epsilon"
  expect_equal(tex, equation_class(actual),
               label = "custom Greek coefficients work")

  tex <- extract_eq(model_simple, intercept = "\\zeta", greek = "\\beta", raw_tex = TRUE)
  actual <- "\\operatorname{mpg} = \\zeta + \\beta_{1}(\\operatorname{cyl}) + \\beta_{2}(\\operatorname{disp}) + \\epsilon"
  expect_equal(tex, equation_class(actual),
               label = "custom Greek intercept works")
})
