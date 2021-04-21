test_that("font-size changes, lm", {
  mod1 <- lm(mpg ~ cyl + disp, data = mtcars)
  expect_snapshot_output(extract_eq(mod1, font_size = "large"))
  expect_snapshot_output(extract_eq(mod1, font_size = "Huge"))
  expect_snapshot_output(extract_eq(mod1, font_size = "tiny"))
})

test_that("font-size changes, lmer", {
  um_long1 <- lme4::lmer(score ~ 1 + (1 | sid), data = sim_longitudinal)
  expect_snapshot_output(extract_eq(um_long1, font_size = "scriptsize"))
  expect_snapshot_output(extract_eq(um_long1, font_size = "Large"))
  expect_snapshot_output(extract_eq(um_long1, font_size = "huge"))
})

test_that("font-size changes, arima", {
  model <- forecast::Arima(simple_ts,
                           order = c(1, 1, 1),
                           seasonal = c(1, 0, 1),
                           include.constant = TRUE
  )
  
  expect_snapshot_output(extract_eq(model, font_size = "footnotesize"))
  expect_snapshot_output(extract_eq(model, font_size = "small"))
  expect_snapshot_output(extract_eq(model, font_size = "LARGE"))
  
})
