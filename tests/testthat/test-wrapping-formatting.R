test_that("Coefficient digits work correctly", {
  model_simple <- lm(mpg ~ cyl + disp, data = mtcars)
  
  # coefficient rounding works
  expect_snapshot_output(
    extract_eq(model_simple, use_coefs = TRUE, coef_digits = 4)
  )
  
  # signs are doubled when fix_signs = FALSE
  expect_snapshot_output(
    extract_eq(model_simple, use_coefs = TRUE, fix_signs = FALSE)
  )
})

test_that("Wrapping works correctly", {
  model_big <- lm(mpg ~ ., data = mtcars)
  
  # wrapping with 4 terms works
  expect_snapshot_output(
    extract_eq(model_big, wrap = TRUE, terms_per_line = 4)
  )
  
  # wrapping with 2 terms works
  expect_snapshot_output(
    extract_eq(model_big, wrap = TRUE, terms_per_line = 2)
  )

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
