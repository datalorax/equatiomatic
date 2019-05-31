testthat::context('basic')

fit <- lm(mpg ~ cyl + disp, mtcars)
expect_fit <- '$$\n \\text{mpg} = \\alpha + \\beta_{1} (\\text{cyl}) + \\beta_{2} (\\text{disp}) + \\epsilon \n$$'

fit1 <- lm(Sepal.Length ~ Sepal.Width + Species, iris)
expect_fit1 <- '$$\n \\text{Sepal.Length} = \\alpha + \\beta_{1} (\\text{Sepal.Width}) + \\beta_{2} (\\text{Species}_{\\text{versicolor}}) + \\beta_{3} (\\text{Species}_{\\text{virginica}}) + \\epsilon \n$$'

testthat::describe('extract',{

  it('default',{
    ret <- extract_eq(fit)
    testthat::expect_equal(ret,expect_fit)
  })

  it('all variables',{
    ret <- extract_eq(fit1)
    testthat::expect_equal(ret,expect_fit1)
  })

})
