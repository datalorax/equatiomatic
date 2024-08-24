# equatiomatic 0.3.4
* {tidymodels} *partial* compatibility: method `extract_eq()` added for
    **model_fit** objects of the {parsnip} package, and for **workflow** objects
    of  the {workflows} package, see
    [#237](https://github.com/datalorax/equatiomatic/pull/237). Previously,
    the model object had to be extracted using `parsnip::fit()` before using
    `extract_eq()`. This is not necessary any more, but still valid (no breaking
    changes). Note that `extract_eq()` cannot handle yet *all* {tidymodels}. For
    instance, it can handle `reg_linear()`, but cannot handle
    `reg_linear() |> set_engine("stan")`. There is currently no plan to support
    *all* {tidymodels} models, but pull requests will be considered if you find
    and solve a problematic case by yourself.

# equatiomatic 0.3.3
* Vignette 'intro-equatiomatic' renamed 'equatiomatic' to enable a "Getting
    Started" entry in the pkgdown site.
* Documentation was cleaned up. In particular, methods for internal generics are
    not exported any more. All methods for `extract_eq()` are now properly
    documented in the `extract_eq()` help page.

# equatiomatic 0.3.2
* New maintainer (Philippe Grosjean phgrosjean@sciviews.org).
* Remotes to yonicd/texPreview eliminated because a suitable version is on CRAN.
* Respect of the arguments of the generic functions for
    `add_greek.forecast_ARIMA` and `add_coefs.forecast_ARIMA` (first argument
    `side=` is renamed `rhs=`).

# equatiomatic 0.3.1
* Minor bug fix related to lifecycle badges
* New license: CC-BY
* Bug fix: If names overlap, prior version had an error with the ordering and
    construction of the coefficients.
* Bug fix: Prior versions did not escape characters in multilevel models when
  declaring the grouping factor (e.g., `for census_division l = 1` is now 
  rendered as `for census\_division l = 1`).
* Feature addition: added `se_subscripts` argument, which allows the standard error for each coefficient to be included in parentheses below the coefficient when `se_subscripts = TRUE`. This is supported for `lm` and `glm` models.

# equatiomatic 0.3.0
* Export new `renderEq()` and `eqOutput()` functions for working with equatiomatic with shiny.
* Specific parts of the equation can now be colored with the new `greek_colors`, `subscript_colors`, `var_colors` and `var_subscript_colors` arguments.
* Includes new `swap_var_names` and `swap_subscript_names` arguments to change
 the names of the variables or subscripts in the rendered equation
* A new vignette documents the usage of colors and name swapping.
* Now accommodates `lme4::glmer()` models.
* Include new `return_variances` argument, which allows users to optionally return the variance/covariances in `lme4::lmer()` and `lme4::glmer()` models
* Added new `font_size` argument, which takes any LaTeX font size (see [here](https://www.overleaf.com/learn/latex/Font_sizes,_families,_and_styles#Font_styles))
* Added new `label` argument, which allows for cross-referencing equation in-text
with PDF outputs.
* Now includes rendering of `poly()`, `log()`, and `exp()` functions for in-line equations, and will drop the `I()` for generic in-line equation operation
* Bug fix related to categorical variables and level parsing for `lme4::lmer()` and and `lme4::glmer()` models
* Minor bug fix related to indexing of coefficients for `lme4::lmer()` models
* Minor bug fix related to very large models, which would not render properly before
* `lme4::lmer()` models now allow for in-line alterations to the code, e.g., `I(n >5)`.
* Minor bug fix related to SARIMA models

# equatiomatic 0.2.0

* **New models**: This is the first version to support `lme4::lmer()` models and
  `forecast::Arima()` models.

* New vignettes for each of the new models supported.

* New vignette showing how to use the package with plotting

* Switched the testing framework to use snapshot testing

* Uses new print method so users no longer have to specify `results = "asis"` in
  the R Markdown chunk option

* Fixed error in rendering logistic/probit regression equations by removing the
  epsilon (error term) at the end of the left-hand side

* The epsilon (error term) is no longer shown when rendering the fitted model
  equation, i.e. `use_coefs = TRUE`, for `lm` models. The hat sign is also added
  to the response variable.

# equatiomatic 0.1.0

* Initial CRAN Release

* Extracts equations for `lm` models

* Extracts equations for `glm` models with `family = binomial(link = "logit")`
  or `family = binomial(link = "probit")`

* Extracts equations form ordered regression models using `MASS::polr` or
  `ordered::clm` for logit and probit link functions

* `glm` models have an optional `show_distribution` argument to show the
  distributional assumptions

* All equations can be displayed using Greek notation or the estimated
  coefficients

* The `raw_tex` code can be used to supply custom TeX code for the intercept or
  the coefficients, through the `intercept` and `greek` arguments respectively

* Long equations can be wrapped to multiple lines with the optional `wrap`
  argument. The length of the wrapping is controlled by `terms_per_line`.

* Added a `NEWS.md` file to track subsequent changes to the package.

