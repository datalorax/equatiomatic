context("polr")

test_that("Ordered logistic regression works", {
  set.seed(1234)
  df <- data.frame(outcome = factor(rep(LETTERS[1:3], 100),
                                    levels = LETTERS[1:3],
                                    ordered = TRUE),
                   continuous_1 = rnorm(300, 100, 1),
                   continuous_2 = rnorm(300, 50, 5))

  model_polr <- MASS::polr(outcome ~ ., data = df, Hess = TRUE, method = "logistic")
  model_polr_probit <- MASS::polr(outcome ~ ., data = df, Hess = TRUE, method = "probit")

  tex_nowrap <- extract_eq(model_polr, wrap = FALSE)
  tex_wrap <- extract_eq(model_polr, wrap = TRUE, terms_per_line = 2)

  tex_nowrap_probit <- extract_eq(model_polr_probit, wrap = FALSE)
  tex_wrap_probit <- extract_eq(model_polr_probit, wrap = TRUE, terms_per_line = 2)

  actual_nowrap <- "\\begin{aligned}
\\log\\left[ \\frac { P( \\operatorname{A} \\geq \\operatorname{B} ) }{ 1 - P( \\operatorname{A} \\geq \\operatorname{B} ) } \\right] &= \\alpha_{1} + \\beta_{1}(\\operatorname{continuous\\_1}) + \\beta_{2}(\\operatorname{continuous\\_2}) + \\epsilon \\\\
\\log\\left[ \\frac { P( \\operatorname{B} \\geq \\operatorname{C} ) }{ 1 - P( \\operatorname{B} \\geq \\operatorname{C} ) } \\right] &= \\alpha_{2} + \\beta_{1}(\\operatorname{continuous\\_1}) + \\beta_{2}(\\operatorname{continuous\\_2}) + \\epsilon
\\end{aligned}"

  actual_wrap <- "\\begin{aligned}
\\log\\left[ \\frac { P( \\operatorname{A} \\geq \\operatorname{B} ) }{ 1 - P( \\operatorname{A} \\geq \\operatorname{B} ) } \\right] &= \\alpha_{1} + \\beta_{1}(\\operatorname{continuous\\_1})\\ + \\\\
&\\quad \\beta_{2}(\\operatorname{continuous\\_2}) + \\epsilon \\\\
\\log\\left[ \\frac { P( \\operatorname{B} \\geq \\operatorname{C} ) }{ 1 - P( \\operatorname{B} \\geq \\operatorname{C} ) } \\right] &= \\alpha_{2} + \\beta_{1}(\\operatorname{continuous\\_1})\\ + \\\\
&\\quad \\beta_{2}(\\operatorname{continuous\\_2}) + \\epsilon
\\end{aligned}"

  actual_nowrap_probit <- "\\begin{aligned}
P(\\operatorname{A} \\geq \\operatorname{B}) &= \\Phi[\\alpha_{1} + \\beta_{1}(\\operatorname{continuous\\_1}) + \\beta_{2}(\\operatorname{continuous\\_2}) + \\epsilon] \\\\
P(\\operatorname{B} \\geq \\operatorname{C}) &= \\Phi[\\alpha_{2} + \\beta_{1}(\\operatorname{continuous\\_1}) + \\beta_{2}(\\operatorname{continuous\\_2}) + \\epsilon]
\\end{aligned}"

  actual_wrap_probit <- "\\begin{aligned}
P(\\operatorname{A} \\geq \\operatorname{B}) &= \\Phi[\\alpha_{1} + \\beta_{1}(\\operatorname{continuous\\_1})\\ + \\\\
&\\qquad\\ \\beta_{2}(\\operatorname{continuous\\_2}) + \\epsilon] \\\\
P(\\operatorname{B} \\geq \\operatorname{C}) &= \\Phi[\\alpha_{2} + \\beta_{1}(\\operatorname{continuous\\_1})\\ + \\\\
&\\qquad\\ \\beta_{2}(\\operatorname{continuous\\_2}) + \\epsilon]
\\end{aligned}"

  expect_equal(tex_nowrap, equation_class(actual_nowrap),
               label = "ordered logit builds correctly")

  expect_equal(tex_wrap, equation_class(actual_wrap),
               label = "ordered logit builds correctly in wrapped environment")

  expect_equal(tex_nowrap_probit, equation_class(actual_nowrap_probit),
               label = "ordered probit builds correctly")

  expect_equal(tex_wrap_probit, equation_class(actual_wrap_probit),
               label = "ordered probit builds correctly in wrapped environment")

  # Coefficients instead of letters
  tex <- extract_eq(model_polr, use_coefs = TRUE)
  actual <- "\\begin{aligned}
\\log\\left[ \\frac { P( \\operatorname{A} \\geq \\operatorname{B} ) }{ 1 - P( \\operatorname{A} \\geq \\operatorname{B} ) } \\right] &= 1.09 + 0.03(\\operatorname{continuous\\_1}) - 0.03(\\operatorname{continuous\\_2}) + \\epsilon \\\\
\\log\\left[ \\frac { P( \\operatorname{B} \\geq \\operatorname{C} ) }{ 1 - P( \\operatorname{B} \\geq \\operatorname{C} ) } \\right] &= 2.48 + 0.03(\\operatorname{continuous\\_1}) - 0.03(\\operatorname{continuous\\_2}) + \\epsilon
\\end{aligned}"
  expect_equal(tex, equation_class(actual),
               label = "ordered logit + coefs builds correctly")
})
