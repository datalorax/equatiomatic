
test_that("se_subscripts argument works with numeric coefficients", {
  
 # test lm with negative coefficient
  mod <- lm(disp ~ cyl + mpg, data = mtcars)
  
  expect_snapshot_output(
    extract_eq(mod,
               use_coefs = TRUE,
               se_subscripts = TRUE)
  )
    
  # test glm with negative coefficients (linear model)
  mod <- glm(disp ~ cyl + mpg, data = mtcars)
    
    expect_snapshot_output(
      extract_eq(mod,
                 se_subscripts = TRUE)
  )
    
    # test glm with negative coefficients (logistic model)
    mod <- glm(am ~ mpg + wt, family = binomial, data = mtcars)
    
    expect_snapshot_output(
      extract_eq(mod,
                 se_subscripts = TRUE)
    )
})


test_that("se_subscripts argument works with wrapping", {
  
  # test lm  
  mod <- lm(disp ~ cyl + mpg + hp, data = mtcars)
  
  expect_snapshot_output(
    extract_eq(mod,
               use_coefs = TRUE,
               wrap = TRUE,
               terms_per_line = 1,
               se_subscripts = TRUE)
  )
  
  # test glm with linear model
  mod <- glm(disp ~ cyl + mpg, data = mtcars)
  
  expect_snapshot_output(
    extract_eq(mod,
               use_coefs = TRUE,
               wrap = TRUE,
               terms_per_line = 1,
               se_subscripts = TRUE)
  )
  
  # test glm with linear model
  mod <- glm(disp ~ cyl + mpg, data = mtcars)
  
  expect_snapshot_output(
    extract_eq(mod,
               use_coefs = TRUE,
               wrap = TRUE,
               terms_per_line = 1,
               se_subscripts = TRUE)
  )
  
  # test glm with logistic model
  mod <- glm(am ~ mpg + wt,
             family = binomial, 
             data = mtcars)
  
  expect_snapshot_output(
    extract_eq(mod,
               use_coefs = TRUE,
               wrap = TRUE,
               terms_per_line = 1,
               se_subscripts = TRUE)
  )
  
})


test_that("se_subscripts argument works with Greek letter terms", {
         
         # test lm  
         mod <- lm(disp ~ cyl + mpg + hp, data = mtcars)
         
         expect_snapshot_output(
           extract_eq(mod,
                      se_subscripts = TRUE)
         )
         
         
         # test lm with wrapping
         mod <- lm(disp ~ cyl + mpg + hp, data = mtcars)
         
         expect_snapshot_output(
           extract_eq(mod,
                      wrap = TRUE,
                      terms_per_line = 1,
                      se_subscripts = TRUE)
         )
         
         # test glm with linear model
         mod <- glm(disp ~ cyl + mpg, data = mtcars)
         
         expect_snapshot_output(
           extract_eq(mod,
                      wrap = TRUE,
                      terms_per_line = 1,
                      se_subscripts = TRUE)
         )
         
         # test glm with logistic model
         mod <- glm(am ~ mpg + wt,
                    family = binomial, 
                    data = mtcars)
         
         expect_snapshot_output(
           extract_eq(mod,
                      wrap = TRUE,
                      terms_per_line = 1,
                      se_subscripts = TRUE)
         )
         
         
})


test_that("se_subscripts argument works with transformed variables", {
  
  # test lm with log transformed variable 
  mod <- lm(disp ~ cyl + log(mpg) + hp, data = mtcars)
  
  # test without wrapping 
  expect_snapshot_output(
    extract_eq(mod,
               use_coefs = TRUE,
               se_subscripts = TRUE)
  )
  
  # test with wrapping 
  expect_snapshot_output(
    extract_eq(mod,
               use_coefs = TRUE,
               wrap = TRUE,
               terms_per_line = 1,
               se_subscripts = TRUE)
  )
  
  # test glm with log transformed variable 
  mod <- glm(disp ~ cyl + log(mpg) + hp, data = mtcars)
  
  # test without wrapping 
  expect_snapshot_output(
    extract_eq(mod,
               use_coefs = TRUE,
               se_subscripts = TRUE)
  )
  
  # test with wrapping 
  expect_snapshot_output(
    extract_eq(mod,
               use_coefs = TRUE,
               wrap = TRUE,
               terms_per_line = 1,
               se_subscripts = TRUE)
  )
  
})


test_that("se_subscripts works with factor variable", {
  
  # test handling of model with factor variable
  mod <- glm(disp ~ cyl + log(mpg) + hp + factor(gear), data = mtcars)

  # with coefficients
  expect_snapshot_output(
    extract_eq(mod,
               use_coefs = TRUE,
               se_subscripts = TRUE)
  )
  
  # with Greek letters
  expect_snapshot_output(
    extract_eq(mod,
               se_subscripts = TRUE)
  )

  
})
