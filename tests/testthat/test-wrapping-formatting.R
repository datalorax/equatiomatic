context("Wrapping and formatting")

test_that("Coefficient digits work correctly", {
  model_simple <- lm(mpg ~ cyl + disp, data = mtcars)

  tex <- extract_eq(model_simple, use_coefs = TRUE, coef_digits = 4)
  actual <- "\\operatorname{mpg} = 34.661 - 1.5873(\\operatorname{cyl}) - 0.0206(\\operatorname{disp}) + \\epsilon"
  expect_equal(tex, equation_class(actual),
               label = "coefficient rounding works")

  tex <- extract_eq(model_simple, use_coefs = TRUE, fix_signs = FALSE)
  actual <- "\\operatorname{mpg} = 34.66 + -1.59(\\operatorname{cyl}) + -0.02(\\operatorname{disp}) + \\epsilon"
  expect_equal(tex, equation_class(actual),
               label = "signs are doubled when fix_signs = FALSE")
})

test_that("Wrapping works correctly", {
  model_big <- lm(mpg ~ ., data = mtcars)

  tex_4_terms <- extract_eq(model_big, wrap = TRUE, terms_per_line = 4)
  tex_4_terms_actual <- "\\begin{aligned}
\\operatorname{mpg} &= \\alpha + \\beta_{1}(\\operatorname{cyl}) + \\beta_{2}(\\operatorname{disp}) + \\beta_{3}(\\operatorname{hp})\\ + \\\\
&\\quad \\beta_{4}(\\operatorname{drat}) + \\beta_{5}(\\operatorname{wt}) + \\beta_{6}(\\operatorname{qsec}) + \\beta_{7}(\\operatorname{vs})\\ + \\\\
&\\quad \\beta_{8}(\\operatorname{am}) + \\beta_{9}(\\operatorname{gear}) + \\beta_{10}(\\operatorname{carb}) + \\epsilon
\\end{aligned}"
  expect_equal(tex_4_terms, equation_class(tex_4_terms_actual),
               label = "wrapping with 4 terms works")

  tex_2_terms <- extract_eq(model_big, wrap = TRUE, terms_per_line = 2)
  tex_2_terms_actual <- "\\begin{aligned}
\\operatorname{mpg} &= \\alpha + \\beta_{1}(\\operatorname{cyl})\\ + \\\\
&\\quad \\beta_{2}(\\operatorname{disp}) + \\beta_{3}(\\operatorname{hp})\\ + \\\\
&\\quad \\beta_{4}(\\operatorname{drat}) + \\beta_{5}(\\operatorname{wt})\\ + \\\\
&\\quad \\beta_{6}(\\operatorname{qsec}) + \\beta_{7}(\\operatorname{vs})\\ + \\\\
&\\quad \\beta_{8}(\\operatorname{am}) + \\beta_{9}(\\operatorname{gear})\\ + \\\\
&\\quad \\beta_{10}(\\operatorname{carb}) + \\epsilon
\\end{aligned}"
  expect_equal(tex_2_terms, equation_class(tex_2_terms_actual),
               label = "wrapping with 2 terms works")

  tex_end <- capture.output(extract_eq(model_big, wrap = TRUE,
                                       operator_location = "end"))
  expect_match(tex_end[3], "\\+ \\\\\\\\$",
               label = "wrapped equation line ends with +")
  expect_match(tex_end[4], "\\+ \\\\\\\\$",
               label = "other wrapped equation line ends with +")


  tex_start <- capture.output(extract_eq(model_big, wrap = TRUE,
                                         operator_location = "start"))
  expect_match(tex_start[3], "\\)\\\\\\\\$",
               label = "wrapped equation line doesn't end with +")
  expect_match(tex_start[4], "&\\\\quad \\+ ",
               label = "wrapped equation line starts with +")
  expect_match(tex_start[5], "&\\\\quad \\+ ",
               label = "other wrapped equation line starts with +")


  tex_align <- capture.output(extract_eq(model_big, wrap = TRUE,
                                         align_env = "align"))
  expect_equal(tex_align[2], "\\begin{align}",
               label = "different align environment used")
})
