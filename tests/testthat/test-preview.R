testthat::context('preview')

fit <- lm(mpg ~ cyl + disp, mtcars)
expect_fit <- '$$\n \\text{mpg} = \\alpha + \\beta_{1} (\\text{cyl}) + \\beta_{2} (\\text{disp}) + \\epsilon \n$$'

testthat::describe('preview',{

  texPreview::tex_opts$set(returnType = 'tex')

  it('texPreview',{
    ret <- extract_eq(fit,preview = TRUE)
    testthat::expect_equal(ret,expect_fit)

  })

  texPreview::tex_opts$restore()

})
