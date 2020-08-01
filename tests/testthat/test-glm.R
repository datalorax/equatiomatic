context("GLMs")

test_that("Logistic regression works", {
  set.seed(1234)
  df <- data.frame(outcome = sample(0:1, 300, replace = TRUE),
                   categorical = rep(letters[1:3], 100),
                   continuous_1 = rnorm(300, 100, 1),
                   continuous_2 = rnorm(300, 50, 5))

  model_logit <- glm(outcome ~ ., data = df,
                     family = binomial(link = "logit"))

  tex <- extract_eq(model_logit)
  actual <- "\\log\\left[ \\frac { P( \\operatorname{outcome} = \\operatorname{1} ) }{ 1 - P( \\operatorname{outcome} = \\operatorname{1} ) } \\right] = \\alpha + \\beta_{1}(\\operatorname{categorical}_{\\operatorname{b}}) + \\beta_{2}(\\operatorname{categorical}_{\\operatorname{c}}) + \\beta_{3}(\\operatorname{continuous\\_1}) + \\beta_{4}(\\operatorname{continuous\\_2}) + \\epsilon"

  expect_equal(tex, equation_class(actual),
               label = "basic equation builds correctly")
})

test_that("Probit regression works", {
  set.seed(1234)
  df <- data.frame(outcome = sample(0:1, 300, replace = TRUE),
                   categorical = rep(letters[1:3], 100),
                   continuous_1 = rnorm(300, 100, 1),
                   continuous_2 = rnorm(300, 50, 5))

  model_probit <- glm(outcome ~ ., data = df,
                      family = binomial(link = "probit"))

  tex <- extract_eq(model_probit)
  actual <- "P(\\operatorname{outcome} = \\operatorname{1}) = \\Phi[\\alpha + \\beta_{1}(\\operatorname{categorical}_{\\operatorname{b}}) + \\beta_{2}(\\operatorname{categorical}_{\\operatorname{c}}) + \\beta_{3}(\\operatorname{continuous\\_1}) + \\beta_{4}(\\operatorname{continuous\\_2}) + \\epsilon]"

  expect_equal(tex, equation_class(actual),
               label = "basic equation builds correctly")

  # Everything works when there are no categorical variables
  model_gaussian <- glm(mpg ~ cyl + disp, data = mtcars, family = gaussian())
  tex <- extract_eq(model_gaussian)
  actual <- "\\operatorname{mpg} = \\alpha + \\beta_{1}(\\operatorname{cyl}) + \\beta_{2}(\\operatorname{disp}) + \\epsilon"

  expect_equal(tex, equation_class(actual),
               label = "equation sans categorical variables builds correctly")
})

test_that("Unsupported GLMs create a message", {
  model_gaussian <- glm(mpg ~ cyl + disp, data = mtcars, family = gaussian())
  model_gaussian$family$link <- "nothing"

  expect_message(extract_eq(model_gaussian))
})

test_that("Distribution-based equations work", {
  set.seed(1234)
  df <- data.frame(outcome = sample(0:1, 300, replace = TRUE),
                   categorical = rep(letters[1:3], 100),
                   continuous_1 = rnorm(300, 100, 1),
                   continuous_2 = rnorm(300, 50, 5))

  model_logit <- glm(outcome ~ ., data = df,
                     family = binomial(link = "logit"))

  model_probit <- glm(outcome ~ ., data = df,
                      family = binomial(link = "probit"))

  tex_logit <- extract_eq(model_logit, show_distribution = TRUE)
  tex_probit <- extract_eq(model_probit, show_distribution = TRUE)

  actual_logit <- "\\begin{aligned}
\\operatorname{outcome}_{\\operatorname{1}} &\\sim B\\left(\\operatorname{prob} = \\hat{P},\\operatorname{size} = 300\\right) \\\\
 \\log\\left[ \\frac {\\hat{P}}{1 - \\hat{P}} \\right] \n &= \\alpha + \\beta_{1}(\\operatorname{categorical}_{\\operatorname{b}}) + \\beta_{2}(\\operatorname{categorical}_{\\operatorname{c}}) + \\beta_{3}(\\operatorname{continuous\\_1}) + \\beta_{4}(\\operatorname{continuous\\_2}) + \\epsilon
\\end{aligned}"

  actual_probit <- "\\begin{aligned}
\\operatorname{outcome}_{\\operatorname{1}} &\\sim B\\left(\\operatorname{prob} = \\hat{P},\\operatorname{size} = 300\\right) \\\\
 \\log\\left[ \\frac {\\hat{P}}{1 - \\hat{P}} \\right] \n &= \\Phi[\\alpha + \\beta_{1}(\\operatorname{categorical}_{\\operatorname{b}}) + \\beta_{2}(\\operatorname{categorical}_{\\operatorname{c}}) + \\beta_{3}(\\operatorname{continuous\\_1}) + \\beta_{4}(\\operatorname{continuous\\_2}) + \\epsilon]
\\end{aligned}"

  expect_equal(tex_logit, equation_class(actual_logit),
               label = "logit equation builds correctly")

  expect_equal(tex_probit, equation_class(actual_probit),
               label = "probit equation builds correctly")

  # Everything works when there are no categorical variables
  model_gaussian <- glm(mpg ~ cyl + disp, data = mtcars, family = gaussian())
  tex <- extract_eq(model_gaussian, show_distribution = TRUE)
  actual <- "\\begin{aligned}
\\operatorname{mpg} &\\sim B\\left(\\operatorname{prob} = \\hat{P},\\operatorname{size} = 32\\right) \\\\
 \\log\\left[ \\frac {\\hat{P}}{1 - \\hat{P}} \\right] \n &= \\alpha + \\beta_{1}(\\operatorname{cyl}) + \\beta_{2}(\\operatorname{disp}) + \\epsilon
\\end{aligned}"

  expect_equal(tex, equation_class(actual),
               label = "equation sans categorical variables builds correctly")
})

test_that("Weights work", {
  set.seed(1234)
  df <- data.frame(outcome = sample(0:1, 300, replace = TRUE),
                   categorical = rep(letters[1:3], 100),
                   continuous_1 = rnorm(300, 100, 1),
                   continuous_2 = rnorm(300, 50, 5),
                   weight = rep(c(1, 2), 150))

  model_logit <- glm(outcome ~ ., data = df, weights = weight,
                     family = binomial(link = "logit"))

  expect_warning(extract_eq(model_logit, show_distribution = TRUE))
})
