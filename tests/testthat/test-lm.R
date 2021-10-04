test_that("Overlapping names don't result in an error", {
  penguins2 <- penguins
  names(penguins2)[3:5] <- c("ca", "p", "gender_cat")
  
  #Model with the iris dataset variables renamed to show the problem
  m2 <- lm(body_mass_g ~ p*gender_cat + ca, penguins2)
  
  expect_snapshot_output(
    extract_eq(m2, wrap = TRUE, terms_per_line = 1,
               use_coefs = TRUE)
  )
})

test_that("Dropping intercept notation works", {
  m <- lm(bill_depth_mm ~ 0 + flipper_length_mm*island, penguins)
  expect_snapshot_output(extract_eq(m))
})

test_that("colorizing works", {
  m <- lm(bill_depth_mm ~ flipper_length_mm*island, penguins)
  
  coef_colors <- c("#1B9E77", "#D95F02", "#7570B3", "#E7298A", "#66A61E", 
                   "#E6AB02", "#A6761D")
  ss_colors <- rev(coef_colors)
  
  expect_snapshot_output(
    extract_eq(
      m,
      swap_var_names = c("flipper_length_mm" = "Flipper Length (MM)",
                         "island" = "ISLAND"),
      swap_subscript_names = c("Dream" = "super dreamy"),
      greek_colors = coef_colors, 
      subscript_colors = ss_colors,
      var_colors = c(
        "bill_depth_mm" = "#0f70f7",
        "flipper_length_mm" = "#b22222",
        "island" = "green"
      ),
      var_subscript_colors = c("island" = "cyan"),
      wrap = 2,
      terms_per_line = 2
    )
  )
})
test_that("Renaming Variables works", {
  m1 <- lm(body_mass_g ~ bill_length_mm * species + 
             flipper_length_mm * sex, 
           data = penguins)
  expect_snapshot_output(
    extract_eq(
      m1, 
      swap_var_names = c(
        "bill_length_mm" = "Bill Length (MM)",
        "flipper_length_mm" = "Flipper Length (MM)",
        "sex" = "SEX"
      ),
      swap_subscript_names = c(
        "male" = "Male",
        "Chinstrap" = "chinny chin chin"
      )
    )
  )
})

test_that("Math extraction works", {
  m_lm <- lm(bill_length_mm ~ poly(bill_depth_mm, 5) + 
               log(flipper_length_mm) +
               exp(bill_length_mm), 
             data = na.omit(penguins))
  
  expect_snapshot_output(extract_eq(m_lm))

  m1 <- lm(mpg ~ I(hp > 150), data = mtcars)
  m2 <- lm(mpg ~ I(hp < 250), data = mtcars)
  expect_snapshot_output(extract_eq(m1))
  expect_snapshot_output(extract_eq(m2))
})
test_that("Collapsing lm factors works", {
  d <- mtcars
  d$gear <- as.factor(d$gear)
  d$carb <- as.factor(d$carb)
  
  m <- lm(mpg ~ gear*carb*disp, data = d)
  
  # no collapsing
  expect_snapshot(extract_eq(m))
  
  # collapsing
  expect_snapshot(extract_eq(m, index_factors = TRUE))
})

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
