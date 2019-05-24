
<!-- README.md is generated from README.Rmd. Please edit that file -->

# equatiomatic

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/datalorax/equatiomatic.svg?branch=master)](https://travis-ci.org/datalorax/equatiomatic)
<!-- badges: end -->

The goal of equatiomatic is to reduce the pain associated with writing 
code from a fitted model. At present, only `lm` models are handled, but
the hope is to expand to a greater number of models in the future.

## Installation

equatiomatic is not yet on CRAN. Install the dev version from GitHub
with

``` r
remotes::install_github("datalorax/equatiomatic")
```

## Examples

Below are a few simple examples of how to use the package.

``` r
library(equatiomatic)
# Fit a simple model
mod1 <- lm(mpg ~ cyl + disp, mtcars)

# Give the results to extract_eq_lm
extract_eq_lm(mod1)
#> [1] "$$\n mpg = \\alpha + \\beta_{1}(cyl) + \\beta_{2}(disp) + \\epsilon \n$$"
```

The equation is returned as a string. You can copy/paste it into your R
Markdown doc and it will render as

![](man/figures/eq1.png)

You can make copy/pasting easier by surrounding in `cat`. Or,
alternatively, preview the equation with `texPreview::tex_preview`.

``` r
texPreview::tex_preview(extract_eq_lm(mod1))
```

<img src="man/figures/README-tex_preview-1.png" width="100%" />

It can also handle shortcut syntax.

``` r
mod2 <- lm(mpg ~ ., mtcars)
extract_eq_lm(mod2)
#> [1] "$$\n mpg = \\alpha + \\beta_{1}(cyl) + \\beta_{2}(disp) + \\beta_{3}(hp) + \\beta_{4}(drat) + \\beta_{5}(wt) + \\beta_{6}(qsec) + \\beta_{7}(vs) + \\beta_{8}(am) + \\beta_{9}(gear) + \\beta_{10}(carb) + \\epsilon \n$$"
```

![](man/figures/eq2.png)

For categorical it will place the levels for the coefficients as
subscripts

``` r
mod3 <- lm(Sepal.Length ~ Sepal.Width + Species, iris)
extract_eq_lm(mod3)
#> [1] "$$\n Sepal.Length = \\alpha + \\beta_{1}(Sepal.Width) + \\beta_{2}(Species_{versicolor}) + \\beta_{3}(Species_{virginica}) + \\epsilon \n$$"
```

![](man/figures/eq3.png)

And it preserves the order the variables are supplied in

``` r
set.seed(8675309)
d <- data.frame(cat1 = rep(letters[1:3], 100),
               cat2 = rep(LETTERS[1:3], each = 100),
               cont1 = rnorm(300, 100, 1),
               cont2 = rnorm(300, 50, 5),
               out   = rnorm(300, 10, 0.5))

mod4 <- lm(out ~ cont1 + cat2 + cont2 + cat1, d)

extract_eq_lm(mod4)
#> [1] "$$\n out = \\alpha + \\beta_{1}(cont1) + \\beta_{2}(cat2_{B}) + \\beta_{3}(cat2_{C}) + \\beta_{4}(cont2) + \\beta_{5}(cat1_{b}) + \\beta_{6}(cat1_{c}) + \\epsilon \n$$"
```

![](man/figures/eq4.png)

## Extension

This project is brand new. If you would like to contribute, we’d love
your help\! We are particularly interested in extending to more models.
At present, we have only implemented `lm`, but hope to change that in
the near future. Stay tuned\!
