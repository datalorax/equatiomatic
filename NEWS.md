# equatiomatic 0.1.0
* Initial CRAN Release
* Extracts equations for `lm` models
* Extracts equations for `glm` models with `family = binomial(link = "logit")` or `family = binomial(link = "probit")`
* Extracts equations form ordered regression models using `MASS::polr` or `ordered::clm` for logit and probit link functions
* `glm` models have an optional `show_distribution` argument to show the distributional assumptions
* All equations can be displayed using Greek notation or the estimated coefficients
* The `raw_tex` code can be used to supply custom TeX code for the intercept or the coefficients, through the `intercept` and `greek` arguments respectively
* Long equations can be wrapped to multiple lines with the optional `wrap` argument. The length of the wrapping is controlled by `terms_per_line`.
* Added a `NEWS.md` file to track subsequent changes to the package.
