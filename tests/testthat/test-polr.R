context("polr")

test_that("Ordered logistic regression works", {
  set.seed(1234)
  df <- data.frame(outcome = factor(rep(LETTERS[1:3], 100),
                                    levels = LETTERS[1:3],
                                    ordered = TRUE),
                   continuous_1 = rnorm(300, 100, 1),
                   continuous_2 = rnorm(300, 50, 5))

  model_polr <- MASS::polr(outcome ~ ., data = df, Hess = TRUE)

  tex_nowrap <- extract_eq(model_polr, wrap = FALSE)
  tex_wrap <- extract_eq(model_polr, wrap = TRUE)

  actual_nowrap <- "\\log\\left[ \\frac { P( \\text{A} \\geq \\text{B} ) }{ 1 - P( \\text{A} \\geq \\text{B} ) } \\right] = \\alpha_{2} + \\beta_{1}(\\text{continuous\\_1}) + \\beta_{2}(\\text{continuous\\_2}) + \\epsilon \\\\
\\log\\left[ \\frac { P( \\text{B} \\geq \\text{C} ) }{ 1 - P( \\text{B} \\geq \\text{C} ) } \\right] = \\alpha_{1} + \\beta_{1}(\\text{continuous\\_1}) + \\beta_{2}(\\text{continuous\\_2}) + \\epsilon"

  actual_wrap <- "\\begin{aligned}
\\log\\left[ \\frac { P( \\text{A} \\geq \\text{B} ) }{ 1 - P( \\text{A} \\geq \\text{B} ) } \\right] &= \\alpha_{2} + \\beta_{1}(\\text{continuous\\_1}) + \\beta_{2}(\\text{continuous\\_2}) + \\epsilon \\\\
\\log\\left[ \\frac { P( \\text{B} \\geq \\text{C} ) }{ 1 - P( \\text{B} \\geq \\text{C} ) } \\right] &= \\alpha_{1} + \\beta_{1}(\\text{continuous\\_1}) + \\beta_{2}(\\text{continuous\\_2}) + \\epsilon
\\end{aligned}"

  expect_equal(tex_nowrap, equation_class(actual_nowrap),
               label = "basic equation builds correctly")

  expect_equal(tex_wrap, equation_class(actual_wrap),
               label = "basic equation builds correctly in wrapped environment")
})
