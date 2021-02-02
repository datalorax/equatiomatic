Tests and Coverage
================
02 February, 2021 00:01:13

  - [Coverage](#coverage)
  - [Unit Tests](#unit-tests)

This output is created by
[covrpage](https://github.com/yonicd/covrpage).

## Coverage

Coverage summary is created using the
[covr](https://github.com/r-lib/covr) package.

| Object                                           | Coverage (%) |
| :----------------------------------------------- | :----------: |
| equatiomatic                                     |    94.22     |
| [R/print.R](../R/print.R)                        |    23.81     |
| [R/merMod.R](../R/merMod.R)                      |    90.51     |
| [R/extract\_rhs.R](../R/extract_rhs.R)           |    95.98     |
| [R/extract\_lhs.R](../R/extract_lhs.R)           |    96.03     |
| [R/create\_eq.R](../R/create_eq.R)               |    99.60     |
| [R/extract\_eq.R](../R/extract_eq.R)             |    100.00    |
| [R/helpers\_forecast.R](../R/helpers_forecast.R) |    100.00    |
| [R/utils.R](../R/utils.R)                        |    100.00    |

<br>

## Unit Tests

Unit Test summary is created using the
[testthat](https://github.com/r-lib/testthat) package.

| file                                                              |  n |  time | error | failed | skipped | warning |
| :---------------------------------------------------------------- | -: | ----: | ----: | -----: | ------: | ------: |
| [test-clm.R](testthat/test-clm.R)                                 |  6 | 0.034 |     0 |      0 |       0 |       0 |
| [test-forecast-arima.R](testthat/test-forecast-arima.R)           |  4 | 0.002 |     0 |      0 |       0 |       0 |
| [test-glm.R](testthat/test-glm.R)                                 | 12 | 0.004 |     0 |      0 |       0 |       0 |
| [test-lm.R](testthat/test-lm.R)                                   |  7 | 0.003 |     0 |      0 |       0 |       0 |
| [test-lmerMod.R](testthat/test-lmerMod.R)                         | 29 | 0.009 |     0 |      0 |       0 |       0 |
| [test-polr.R](testthat/test-polr.R)                               |  5 | 0.001 |     0 |      0 |       0 |       0 |
| [test-print.R](testthat/test-print.R)                             |  4 | 0.002 |     0 |      0 |       0 |       0 |
| [test-utils.R](testthat/test-utils.R)                             |  8 | 0.002 |     0 |      0 |       0 |       0 |
| [test-wrapping-formatting.R](testthat/test-wrapping-formatting.R) | 10 | 0.003 |     0 |      0 |       0 |       0 |

<details closed>

<summary> Show Detailed Test Results </summary>

| file                                                               | context | test                                                        | status | n |  time |
| :----------------------------------------------------------------- | :------ | :---------------------------------------------------------- | :----- | -: | ----: |
| [test-clm.R](testthat/test-clm.R#)                                 |         | Ordered models with clm work                                | PASS   | 5 | 0.034 |
| [test-clm.R](testthat/test-clm.R#)                                 |         | Unsupported CLMs create a message                           | PASS   | 1 | 0.000 |
| [test-forecast-arima.R](testthat/test-forecast-arima.R#)           |         | Basic ARIMA model functions                                 | PASS   | 2 | 0.001 |
| [test-forecast-arima.R](testthat/test-forecast-arima.R#)           |         | Regression w/ ARIMA Errors functions                        | PASS   | 2 | 0.001 |
| [test-glm.R](testthat/test-glm.R#)                                 |         | Logistic regression works                                   | PASS   | 1 | 0.001 |
| [test-glm.R](testthat/test-glm.R#)                                 |         | Probit regression works                                     | PASS   | 2 | 0.000 |
| [test-glm.R](testthat/test-glm.R#)                                 |         | Unsupported GLMs create a message                           | PASS   | 1 | 0.000 |
| [test-glm.R](testthat/test-glm.R#)                                 |         | Distribution-based equations work                           | PASS   | 3 | 0.001 |
| [test-glm.R](testthat/test-glm.R#)                                 |         | Weights work                                                | PASS   | 1 | 0.000 |
| [test-glm.R](testthat/test-glm.R#)                                 |         | non-binomial regression works                               | PASS   | 4 | 0.002 |
| [test-lm.R](testthat/test-lm.R#)                                   |         | Simple lm models work                                       | PASS   | 3 | 0.001 |
| [test-lm.R](testthat/test-lm.R#)                                   |         | Interactions work                                           | PASS   | 2 | 0.001 |
| [test-lm.R](testthat/test-lm.R#)                                   |         | Custom Greek works                                          | PASS   | 2 | 0.001 |
| [test-lmerMod.R](testthat/test-lmerMod.R#)                         |         | Categorical variable level parsing works (from issue \#140) | PASS   | 1 | 0.001 |
| [test-lmerMod.R](testthat/test-lmerMod.R#)                         |         | Unconditional lmer models work                              | PASS   | 3 | 0.001 |
| [test-lmerMod.R](testthat/test-lmerMod.R#)                         |         | Level 1 predictors work                                     | PASS   | 2 | 0.001 |
| [test-lmerMod.R](testthat/test-lmerMod.R#)                         |         | Mean separate works as expected                             | PASS   | 2 | 0.001 |
| [test-lmerMod.R](testthat/test-lmerMod.R#)                         |         | Wrapping works as expected                                  | PASS   | 1 | 0.000 |
| [test-lmerMod.R](testthat/test-lmerMod.R#)                         |         | Unstructured variance-covariances work as expected          | PASS   | 5 | 0.001 |
| [test-lmerMod.R](testthat/test-lmerMod.R#)                         |         | Group-level predictors work as expected                     | PASS   | 3 | 0.001 |
| [test-lmerMod.R](testthat/test-lmerMod.R#)                         |         | Interactions work as expected                               | PASS   | 5 | 0.001 |
| [test-lmerMod.R](testthat/test-lmerMod.R#)                         |         | Alternate random effect VCV structures work                 | PASS   | 3 | 0.001 |
| [test-lmerMod.R](testthat/test-lmerMod.R#)                         |         | Nested model syntax works                                   | PASS   | 3 | 0.001 |
| [test-lmerMod.R](testthat/test-lmerMod.R#)                         |         | use\_coef works                                             | PASS   | 1 | 0.000 |
| [test-polr.R](testthat/test-polr.R#)                               |         | Ordered logistic regression works                           | PASS   | 5 | 0.001 |
| [test-print.R](testthat/test-print.R#)                             |         | Equation is printed correctly                               | PASS   | 2 | 0.001 |
| [test-print.R](testthat/test-print.R#)                             |         | Equation is knit\_print-ed correctly                        | PASS   | 2 | 0.001 |
| [test-utils.R](testthat/test-utils.R#)                             |         | Strict mapply\_\* functions work                            | PASS   | 8 | 0.002 |
| [test-wrapping-formatting.R](testthat/test-wrapping-formatting.R#) |         | Coefficient digits work correctly                           | PASS   | 2 | 0.001 |
| [test-wrapping-formatting.R](testthat/test-wrapping-formatting.R#) |         | Wrapping works correctly                                    | PASS   | 8 | 0.002 |

</details>

<details>

<summary> Session Info </summary>

| Field    | Value                             |                                                                                                                                                                                                                                                                         |
| :------- | :-------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Version  | R version 4.0.3 (2020-10-10)      |                                                                                                                                                                                                                                                                         |
| Platform | x86\_64-apple-darwin17.0 (64-bit) | <a href="https://github.com/datalorax/equatiomatic/commit/16ad9602334ac46a9c6e3db8c4b6086f7d8976cc/checks" target="_blank"><span title="Built on Github Actions">![](https://github.com/metrumresearchgroup/covrpage/blob/actions/inst/logo/gh.png?raw=true)</span></a> |
| Running  | macOS Catalina 10.15.7            |                                                                                                                                                                                                                                                                         |
| Language | en\_US                            |                                                                                                                                                                                                                                                                         |
| Timezone | UTC                               |                                                                                                                                                                                                                                                                         |

| Package  | Version |
| :------- | :------ |
| testthat | 3.0.1   |
| covr     | 3.5.1   |
| covrpage | 0.1     |

</details>

<!--- Final Status : pass --->
