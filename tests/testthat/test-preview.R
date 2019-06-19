context("Previewing")

test_that("Previewing works", {
  # skip_on_cran()

  model_simple <- lm(mpg ~ cyl + disp, data = mtcars)

  actual <- "\\text{mpg} = \\alpha + \\beta_{1}(\\text{cyl}) + \\beta_{2}(\\text{disp}) + \\epsilon"

  previewed <- preview(extract_eq(model_simple),
                       returnType = "tex", ignore.stdout = TRUE)

  expect_equal(length(previewed), 3,
               label = "preview returns a 3-element vector")

  expect_equal(previewed[2], actual,
               label = "preview generates the correct TeX")
})

test_that("Previewing stops if texPreview is not installed", {
  # Maybe use withr::with_libpaths()
  # Temporary pointless test so that this isn't empty
  expect_equal(2 * 2, 4)
})
