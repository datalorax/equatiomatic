testthat::context('basic')

fit <- lm(mpg ~ cyl + disp, mtcars)
expect_fit <- '$$\n mpg = \\alpha + \\beta_{1}(cyl) + \\beta_{2}(disp) + \\epsilon \n$$'

fit1 <- lm(Sepal.Length ~ Sepal.Width + Species, iris)
expect_fit1 <- '$$\n Sepal.Length = \\alpha + \\beta_{1}(Sepal.Width) + \\beta_{2}(Species_{versicolor}) + \\beta_{3}(Species_{virginica}) + \\epsilon \n$$'

testthat::describe('extract',{

  it('default',{
    ret <- extract_eq_lm(fit)
    testthat::expect_equal(ret,expect_fit)
  })

  it('all variables',{
    ret <- extract_eq_lm(fit1)
    testthat::expect_equal(ret,expect_fit1)

  })

})
