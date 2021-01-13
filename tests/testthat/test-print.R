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

test_that("Equation is knit_print-ed correctly", {
  model_simple <- lm(mpg ~ cyl + disp, data = mtcars)

  knit_print_tex <- knitr::knit_print(extract_eq(model_simple))
  actual <- "$$\n\\operatorname{mpg} = \\alpha + \\beta_{1}(\\operatorname{cyl}) + \\beta_{2}(\\operatorname{disp}) + \\epsilon\n$$"


  expect_equal(as.character(knit_print_tex),
               actual,
               label = "second line is the formula")
  expect_s3_class(knit_print_tex,
               "knit_asis")
})
