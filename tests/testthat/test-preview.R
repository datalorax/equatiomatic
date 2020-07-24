context("Previewing")

test_that("Previewing works", {
  # skip_on_cran()

  model_simple <- lm(mpg ~ cyl + disp, data = mtcars)

  actual <- "\\text{mpg} = \\alpha + \\beta_{1}(\\text{cyl}) + \\beta_{2}(\\text{disp}) + \\epsilon"

  previewed <- preview(extract_eq(model_simple), returnType = "tex")

  expect_equal(length(previewed), 3,
               label = "preview returns a 3-element vector")

  expect_equal(previewed[2], actual,
               label = "preview generates the correct TeX")
})

test_that("Previewing stops if texPreview is not installed", {
  model_simple <- lm(mpg ~ cyl + disp, data = mtcars)

  with_mock(
    "equatiomatic::is_texPreview_installed" = function() FALSE,
    expect_error(preview(extract_eq(model_simple), returnType = "tex"),
                 label = "preview stops if texPreview isn't installed")
  )
})
