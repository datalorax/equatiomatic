test_that("Labeling works", {
  m <- lm(mpg ~ cyl + disp, data = mtcars)
  expect_snapshot_output(extract_eq(m, label = "mpg_mod"))
})

test_that("Simple lm models work", {
  model_simple <- lm(mpg ~ cyl + disp, data = mtcars)

  mtcars$gear <- as.factor(mtcars$gear)
  model_indicators <- lm(mpg ~ cyl + gear, data = mtcars)

  # basic equation builds correctly
  expect_snapshot_output(extract_eq(model_simple))

  # categorical subscripts work
  expect_snapshot_output(extract_eq(model_indicators))

  # basic equation + coefs builds correctly
  expect_snapshot_output(extract_eq(model_simple, use_coefs = TRUE))
})

test_that("Interactions work", {
  simple_int <- lm(body_mass_g ~ bill_length_mm * species, penguins)
  simple_int2 <- lm(mpg ~ hp * wt, mtcars)

  # Basic interaction with subscripts
  expect_snapshot_output(extract_eq(simple_int))

  # Basic interaction with no subscripts
  expect_snapshot_output(extract_eq(simple_int2))
})

test_that("Custom Greek works", {
  model_simple <- lm(mpg ~ cyl + disp, data = mtcars)

  # custom Greek coefficients work
  expect_snapshot_output(
    extract_eq(model_simple, greek = "\\hat{\\beta}", raw_tex = TRUE)
  )

  # custom Greek intercept works
  expect_snapshot_output(
    extract_eq(model_simple,
      intercept = "\\zeta",
      greek = "\\beta",
      raw_tex = TRUE
    )
  )
})

test_that("Hat is escaped correctly", {
  mtcars$carb <- ordered(mtcars$carb)
  m <- lm(mpg ~ carb, mtcars)
  expect_snapshot_output(extract_eq(m))
})
