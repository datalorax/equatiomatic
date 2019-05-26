testthat::context('preview')

fit <- lm(mpg ~ cyl + disp, mtcars)
expect_fit <- '$$\n mpg = \\alpha + \\beta_{1}(cyl) + \\beta_{2}(disp) + \\epsilon \n$$'

testthat::describe('preview',{

  texPreview::tex_opts$set(returnType = 'tex')

  it('texPreview',{
    ret <- extract_eq_lm(fit,preview = TRUE)
    testthat::expect_equal(paste0(ret,collapse = '\n'),expect_fit)

  })

  texPreview::tex_opts$restore()

})
