# equatiomatic (development version)
* Export new `renderEq()` and `eqOutput()` functions for working with equatiomatic with shiny.
* Now accommodates `lme4::glmer()` models.
* Include new `return_variances` argument, which allows users to optionally return the variance/covariances in `lme4::lmer()` and `lme4::glmer()` models
* Added new `font_size` argument, which takes any LaTeX font size (see [here](https://www.overleaf.com/learn/latex/Font_sizes,_families,_and_styles#Font_styles))
* Added new `label` argument, which allows for cross-referencing equation in-text
with PDF outputs.
* Now includes rendering of `poly()`, `log()`, and `exp()` functions for in-line equations
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

