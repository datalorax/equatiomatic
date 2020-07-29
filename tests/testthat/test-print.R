context("Printing")

test_that("Equation is printed correctly", {
  model_simple <- lm(mpg ~ cyl + disp, data = mtcars)

  tex <- extract_eq(model_simple)
  actual <- "\\operatorname{mpg} = \\alpha + \\beta_{1}(\\operatorname{cyl}) + \\beta_{2}(\\operatorname{disp}) + \\epsilon"

  printed_tex <- capture.output(tex)

  expect_equal(printed_tex[1], "$$",
               label = "first line is $$")
  expect_equal(printed_tex[2], actual,
               label = "second line is the formula")
})
