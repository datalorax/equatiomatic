context("CLMs")

test_that("Ordered models with clm work", {
  set.seed(1234)
  df <- data.frame(outcome = factor(rep(LETTERS[1:3], 100),
                                    levels = LETTERS[1:3],
                                    ordered = TRUE),
                   continuous_1 = rnorm(300, 1, 1),
                   continuous_2 = rnorm(300, 5, 5))

  model_logit <- ordinal::clm(outcome ~ continuous_1 + continuous_2,
                              data = df, link = "logit")
  model_probit <- ordinal::clm(outcome ~ continuous_1 + continuous_2,
                               data = df, link = "probit")

  tex_nowrap_logit <- extract_eq(model_logit, wrap = FALSE)
  tex_wrap_logit <- extract_eq(model_logit, wrap = TRUE, terms_per_line = 2)

  tex_nowrap_probit <- extract_eq(model_probit, wrap = FALSE)
  tex_wrap_probit <- extract_eq(model_probit, wrap = TRUE, terms_per_line = 2)

  actual_nowrap_logit <- "\\begin{aligned}
\\log\\left[ \\frac { P( \\operatorname{A} \\geq \\operatorname{B} ) }{ 1 - P( \\operatorname{A} \\geq \\operatorname{B} ) } \\right] &= \\alpha_{1} + \\beta_{1}(\\operatorname{continuous\\_1}) + \\beta_{2}(\\operatorname{continuous\\_2}) + \\epsilon \\\\
\\log\\left[ \\frac { P( \\operatorname{B} \\geq \\operatorname{C} ) }{ 1 - P( \\operatorname{B} \\geq \\operatorname{C} ) } \\right] &= \\alpha_{2} + \\beta_{1}(\\operatorname{continuous\\_1}) + \\beta_{2}(\\operatorname{continuous\\_2}) + \\epsilon
\\end{aligned}"

  actual_wrap_logit <- "\\begin{aligned}
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

  expect_equal(tex_nowrap_logit, equation_class(actual_nowrap_logit),
               label = "ordered logit equation builds correctly")

  expect_equal(tex_wrap_logit, equation_class(actual_wrap_logit),
               label = "ordered logit equation builds correctly in wrapped environment")

  expect_equal(tex_nowrap_probit, equation_class(actual_nowrap_probit),
               label = "ordered probit equation builds correctly")

  expect_equal(tex_wrap_probit, equation_class(actual_wrap_probit),
               label = "ordered probit equation builds correctly in wrapped environment")

  # Coefficients instead of letters
  tex <- extract_eq(model_logit, use_coefs = TRUE)
  actual <- "\\begin{aligned}
\\log\\left[ \\frac { P( \\operatorname{A} \\geq \\operatorname{B} ) }{ 1 - P( \\operatorname{A} \\geq \\operatorname{B} ) } \\right] &= -0.81 + 0.03(\\operatorname{continuous\\_1}) - 0.03(\\operatorname{continuous\\_2}) + \\epsilon \\\\
\\log\\left[ \\frac { P( \\operatorname{B} \\geq \\operatorname{C} ) }{ 1 - P( \\operatorname{B} \\geq \\operatorname{C} ) } \\right] &= 0.59 + 0.03(\\operatorname{continuous\\_1}) - 0.03(\\operatorname{continuous\\_2}) + \\epsilon
\\end{aligned}"
  expect_equal(tex, equation_class(actual),
               label = "ordered logit + coefs builds correctly")
})

test_that("Unsupported CLMs create a message", {
  set.seed(1234)
  df <- data.frame(outcome = factor(rep(LETTERS[1:3], 100),
                                    levels = LETTERS[1:3],
                                    ordered = TRUE),
                   continuous_1 = rnorm(300, 1, 1),
                   continuous_2 = rnorm(300, 5, 5))

  model <- ordinal::clm(outcome ~ continuous_1 + continuous_2,
                        data = df, link = "cauchit")

  expect_message(extract_eq(model))
})
