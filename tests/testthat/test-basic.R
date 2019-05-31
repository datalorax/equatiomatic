testthat::context('basic')

fit <- lm(mpg ~ cyl + disp, mtcars)
expect_fit <- '\\text{mpg} = \\alpha + \\beta_{1} (\\text{cyl}) + \\beta_{2} (\\text{disp}) + \\epsilon'
class(expect_fit) <- c('tex','character')

fit1 <- lm(Sepal.Length ~ Sepal.Width + Species, iris)
expect_fit1 <- '\\text{Sepal.Length} = \\alpha + \\beta_{1} (\\text{Sepal.Width}) + \\beta_{2} (\\text{Species}_{\\text{versicolor}}) + \\beta_{3} (\\text{Species}_{\\text{virginica}}) + \\epsilon'
class(expect_fit1) <- c('tex','character')

testthat::describe('extract',{

  it('default',{
    testthat::expect_equal(extract_eq(fit),expect_fit)
  })

  it('all variables',{
    testthat::expect_equal(extract_eq(fit1),expect_fit1)

  })

})
