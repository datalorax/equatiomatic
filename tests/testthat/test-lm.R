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


test_that("Interactions work", {
  simple_int <- lm(Sepal.Length ~ Sepal.Width*Species, iris)

  tex <- extract_eq(simple_int)
  actual <- "\\text{Sepal.Length} = \\alpha + \\beta_{1}(\\text{Sepal.Width}) + \\beta_{2}(\\text{Species}_{\\text{versicolor}}) + \\beta_{3}(\\text{Species}_{\\text{virginica}}) + \\beta_{4}(\\text{Sepal.Width} \\times \\text{Species}_{\\text{versicolor}}) + \\beta_{5}(\\text{Sepal.Width} \\times \\text{Species}_{\\text{virginica}}) + \\epsilon"
  expect_equal(tex, equation_class(actual),
               label = "Basic interaction with subscripts")

  simple_int2 <- lm(mpg ~ hp*wt, mtcars)
  tex2 <- extract_eq(simple_int2)
  actual2 <- "\\text{mpg} = \\alpha + \\beta_{1}(\\text{hp}) + \\beta_{2}(\\text{wt}) + \\beta_{3}(\\text{hp} \\times \\text{wt}) + \\epsilon"
  expect_equal(tex2, equation_class(actual2),
               label = "Basic interaction with no subscripts")



})
