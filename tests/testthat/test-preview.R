testthat::context('preview')

fit <- lm(mpg ~ cyl + disp, mtcars)
expect_fit <- '$$\n \\text{mpg} = \\alpha + \\beta_{1} (\\text{cyl}) + \\beta_{2} (\\text{disp}) + \\epsilon \n$$'

testthat::describe('preview',{

  texPreview::tex_opts$set(returnType = 'tex')

  it('texPreview',{
    testthat::expect_equal(paste0(preview(extract_eq(fit)),collapse = '\n'),expect_fit)

  })

  texPreview::tex_opts$restore()

})
