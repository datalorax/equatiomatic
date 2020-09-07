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
  actual <- "\\log\\left[ \\frac { P( \\operatorname{outcome} = \\operatorname{1} ) }{ 1 - P( \\operatorname{outcome} = \\operatorname{1} ) } \\right] = \\alpha + \\beta_{1}(\\operatorname{categorical}_{\\operatorname{b}}) + \\beta_{2}(\\operatorname{categorical}_{\\operatorname{c}}) + \\beta_{3}(\\operatorname{continuous\\_1}) + \\beta_{4}(\\operatorname{continuous\\_2})"

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
  actual <- "P( \\operatorname{outcome} = \\operatorname{1} ) = \\Phi[\\alpha + \\beta_{1}(\\operatorname{categorical}_{\\operatorname{b}}) + \\beta_{2}(\\operatorname{categorical}_{\\operatorname{c}}) + \\beta_{3}(\\operatorname{continuous\\_1}) + \\beta_{4}(\\operatorname{continuous\\_2})]"

  expect_equal(tex, equation_class(actual),
               label = "basic equation builds correctly")

  # Everything works when there are no categorical variables
  model_gaussian <- glm(mpg ~ cyl + disp, data = mtcars, family = gaussian())
  tex <- extract_eq(model_gaussian)
  actual <- "E( \\operatorname{mpg} ) = \\alpha + \\beta_{1}(\\operatorname{cyl}) + \\beta_{2}(\\operatorname{disp})"

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
\\operatorname{outcome} &\\sim Bernoulli\\left(\\operatorname{prob}_{\\operatorname{outcome} = \\operatorname{1}}= \\hat{P}\\right) \\\\
 \\log\\left[ \\frac { \\hat{P} }{ 1 - \\hat{P} } \\right] 
 &= \\alpha + \\beta_{1}(\\operatorname{categorical}_{\\operatorname{b}}) + \\beta_{2}(\\operatorname{categorical}_{\\operatorname{c}}) + \\beta_{3}(\\operatorname{continuous\\_1}) + \\beta_{4}(\\operatorname{continuous\\_2})
\\end{aligned}"

  actual_probit <- "\\begin{aligned}
\\operatorname{outcome} &\\sim Bernoulli\\left(\\operatorname{prob}_{\\operatorname{outcome} = \\operatorname{1}}= \\hat{P}\\right) \\\\
 \\hat{P} 
 &= \\Phi[\\alpha + \\beta_{1}(\\operatorname{categorical}_{\\operatorname{b}}) + \\beta_{2}(\\operatorname{categorical}_{\\operatorname{c}}) + \\beta_{3}(\\operatorname{continuous\\_1}) + \\beta_{4}(\\operatorname{continuous\\_2})]
\\end{aligned}"

  expect_equal(tex_logit, equation_class(actual_logit),
               label = "logit equation builds correctly")

  expect_equal(tex_probit, equation_class(actual_probit),
               label = "probit equation builds correctly")

  # Everything works when there are no categorical variables
  model_gaussian <- glm(mpg ~ cyl + disp, data = mtcars, family = gaussian())
  tex <- extract_eq(model_gaussian, show_distribution = TRUE)
  actual <- "\\begin{aligned}
E( \\operatorname{mpg} ) &= \\alpha + \\beta_{1}(\\operatorname{cyl}) + \\beta_{2}(\\operatorname{disp})
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

test_that("non-binomial regression works", {
  set.seed(1234)
  df <- data.frame(outcome = sample(0:15, 300, replace = TRUE),
                   categorical = rep(letters[1:3], 100),
                   continuous_1 = rnorm(300, 100, 1),
                   continuous_2 = rnorm(300, 50, 5))

  model_log <- glm(outcome ~ ., data = df,
                   family = poisson(link = "log"))
  tex_log <- extract_eq(model_log)
  actual_log <- "\\log ({ E( \\operatorname{outcome} ) })  = \\alpha + \\beta_{1}(\\operatorname{categorical}_{\\operatorname{b}}) + \\beta_{2}(\\operatorname{categorical}_{\\operatorname{c}}) + \\beta_{3}(\\operatorname{continuous\\_1}) + \\beta_{4}(\\operatorname{continuous\\_2})"

  expect_equal(tex_log, equation_class(actual_log),
               label = "basic log equation builds correctly")

  expect_message(extract_eq(model_log, show_distribution = TRUE))

  model_id <- glm(outcome ~ ., data = df,
                  family = gaussian(link = "identity"))
  tex_id <- extract_eq(model_log)
  actual_id <- "\\log ({ E( \\operatorname{outcome} ) })  = \\alpha + \\beta_{1}(\\operatorname{categorical}_{\\operatorname{b}}) + \\beta_{2}(\\operatorname{categorical}_{\\operatorname{c}}) + \\beta_{3}(\\operatorname{continuous\\_1}) + \\beta_{4}(\\operatorname{continuous\\_2})"

  expect_equal(tex_id, equation_class(actual_id),
               label = "basic identity equation builds correctly")

  model_offset <- glm(outcome ~ . + offset(rep(1, 300)), data = df,
                      family = poisson(link = "log"))
  tex_offset <- extract_eq(model_offset)
  actual_offset <- "\\log ({ E( \\operatorname{outcome} ) })  = \\alpha + \\beta_{1}(\\operatorname{categorical}_{\\operatorname{b}}) + \\beta_{2}(\\operatorname{categorical}_{\\operatorname{c}}) + \\beta_{3}(\\operatorname{continuous\\_1}) + \\beta_{4}(\\operatorname{continuous\\_2}) + \\operatorname{offset(rep(1, 300))}"

  expect_equal(tex_offset, equation_class(actual_offset),
               label = "basic equation with offset builds correctly")
})

