Tests and Coverage
================
19 January, 2021 04:37:19

  - [Coverage](#coverage)
  - [Unit Tests](#unit-tests)

This output is created by
[covrpage](https://github.com/yonicd/covrpage).

## Coverage

Coverage summary is created using the
[covr](https://github.com/r-lib/covr) package.

    ## ⚠️ Not All Tests Passed
    ##   Coverage statistics are approximations of the non-failing tests.
    ##   Use with caution
    ## 
    ##  For further investigation check in testthat summary tables.

| Object                                           | Coverage (%) |
| :----------------------------------------------- | :----------: |
| equatiomatic                                     |    94.48     |
| [R/print.R](../R/print.R)                        |    35.71     |
| [R/merMod.R](../R/merMod.R)                      |    90.51     |
| [R/extract\_lhs.R](../R/extract_lhs.R)           |    95.04     |
| [R/extract\_rhs.R](../R/extract_rhs.R)           |    96.49     |
| [R/create\_eq.R](../R/create_eq.R)               |    99.56     |
| [R/extract\_eq.R](../R/extract_eq.R)             |    100.00    |
| [R/helpers\_forecast.R](../R/helpers_forecast.R) |    100.00    |
| [R/utils.R](../R/utils.R)                        |    100.00    |

<br>

## Unit Tests

Unit Test summary is created using the
[testthat](https://github.com/r-lib/testthat) package.

| file                                                              |  n |   time | error | failed | skipped | warning | icon |
| :---------------------------------------------------------------- | -: | -----: | ----: | -----: | ------: | ------: | :--- |
| [test-clm.R](testthat/test-clm.R)                                 |  6 |  2.478 |     0 |      0 |       0 |       0 |      |
| [test-forecast-arima.R](testthat/test-forecast-arima.R)           |  4 |  1.045 |     0 |      0 |       0 |       0 |      |
| [test-glm.R](testthat/test-glm.R)                                 | 12 |  0.247 |     0 |      1 |       0 |       0 | 🛑    |
| [test-lm.R](testthat/test-lm.R)                                   |  7 |  0.092 |     0 |      0 |       0 |       0 |      |
| [test-lmerMod.R](testthat/test-lmerMod.R)                         | 28 | 52.475 |     0 |      0 |       0 |       0 |      |
| [test-polr.R](testthat/test-polr.R)                               |  5 |  0.120 |     0 |      0 |       0 |       0 |      |
| [test-print.R](testthat/test-print.R)                             |  5 |  1.658 |     0 |      3 |       0 |       0 | 🛑    |
| [test-utils.R](testthat/test-utils.R)                             |  8 |  0.052 |     0 |      0 |       0 |       0 |      |
| [test-wrapping-formatting.R](testthat/test-wrapping-formatting.R) | 10 |  0.127 |     0 |      0 |       0 |       0 |      |

<details open>

<summary> Show Detailed Test Results </summary>

| file                                                                      | context             | test                                               | status | n |   time | icon |
| :------------------------------------------------------------------------ | :------------------ | :------------------------------------------------- | :----- | -: | -----: | :--- |
| [test-clm.R](testthat/test-clm.R#L14)                                     | clm                 | Ordered models with clm work                       | PASS   | 5 |  2.447 |      |
| [test-clm.R](testthat/test-clm.R#L34)                                     | clm                 | Unsupported CLMs create a message                  | PASS   | 1 |  0.031 |      |
| [test-forecast-arima.R](testthat/test-forecast-arima.R#L14)               | forecast-arima      | Basic ARIMA model functions                        | PASS   | 2 |  0.307 |      |
| [test-forecast-arima.R](testthat/test-forecast-arima.R#L37)               | forecast-arima      | Regression w/ ARIMA Errors functions               | PASS   | 2 |  0.738 |      |
| [test-glm.R](testthat/test-glm.R#L13)                                     | glm                 | Logistic regression works                          | PASS   | 1 |  0.033 |      |
| [test-glm.R](testthat/test-glm.R#L27)                                     | glm                 | Probit regression works                            | PASS   | 2 |  0.032 |      |
| [test-glm.R](testthat/test-glm.R#L39)                                     | glm                 | Unsupported GLMs create a message                  | PASS   | 1 |  0.016 |      |
| [test-glm.R](testthat/test-glm.R#L55)                                     | glm                 | Distribution-based equations work                  | FAILED | 3 |  0.057 | 🛑    |
| [test-glm.R](testthat/test-glm.R#L75)                                     | glm                 | Weights work                                       | PASS   | 1 |  0.018 |      |
| [test-glm.R](testthat/test-glm.R#L89)                                     | glm                 | non-binomial regression works                      | PASS   | 4 |  0.091 |      |
| [test-lm.R](testthat/test-lm.R#L8)                                        | lm                  | Simple lm models work                              | PASS   | 3 |  0.039 |      |
| [test-lm.R](testthat/test-lm.R#L22)                                       | lm                  | Interactions work                                  | PASS   | 2 |  0.028 |      |
| [test-lm.R](testthat/test-lm.R#L32_L34)                                   | lm                  | Custom Greek works                                 | PASS   | 2 |  0.025 |      |
| [test-lmerMod.R](testthat/test-lmerMod.R#L6)                              | lmerMod             | Unconditional lmer models work                     | PASS   | 3 |  1.287 |      |
| [test-lmerMod.R](testthat/test-lmerMod.R#L23)                             | lmerMod             | Level 1 predictors work                            | PASS   | 2 |  0.508 |      |
| [test-lmerMod.R](testthat/test-lmerMod.R#L36)                             | lmerMod             | Mean separate works as expected                    | PASS   | 2 |  0.484 |      |
| [test-lmerMod.R](testthat/test-lmerMod.R#L49)                             | lmerMod             | Wrapping works as expected                         | PASS   | 1 |  0.341 |      |
| [test-lmerMod.R](testthat/test-lmerMod.R#L58)                             | lmerMod             | Unstructured variance-covariances work as expected | PASS   | 5 |  5.844 |      |
| [test-lmerMod.R](testthat/test-lmerMod.R#L96)                             | lmerMod             | Group-level predictors work as expected            | PASS   | 3 | 32.059 |      |
| [test-lmerMod.R](testthat/test-lmerMod.R#L132)                            | lmerMod             | Interactions work as expected                      | PASS   | 5 |  7.350 |      |
| [test-lmerMod.R](testthat/test-lmerMod.R#L168)                            | lmerMod             | Alternate random effect VCV structures work        | PASS   | 3 |  2.095 |      |
| [test-lmerMod.R](testthat/test-lmerMod.R#L193)                            | lmerMod             | Nested model syntax works                          | PASS   | 3 |  0.503 |      |
| [test-lmerMod.R](testthat/test-lmerMod.R#L219)                            | lmerMod             | use\_coef works                                    | PASS   | 1 |  2.004 |      |
| [test-polr.R](testthat/test-polr.R#L13)                                   | polr                | Ordered logistic regression works                  | PASS   | 5 |  0.120 |      |
| [test-print.R](testthat/test-print.R#L9_L10)                              | print               | Equation is printed correctly                      | PASS   | 2 |  0.018 |      |
| [test-print.R](testthat/test-print.R#L22_L24)                             | print               | Equation is knit\_print-ed correctly               | FAILED | 3 |  1.640 | 🛑    |
| [test-utils.R](testthat/test-utils.R#L7_L10)                              | utils               | Strict mapply\_\* functions work                   | PASS   | 8 |  0.052 |      |
| [test-wrapping-formatting.R](testthat/test-wrapping-formatting.R#L5_L7)   | wrapping-formatting | Coefficient digits work correctly                  | PASS   | 2 |  0.030 |      |
| [test-wrapping-formatting.R](testthat/test-wrapping-formatting.R#L19_L21) | wrapping-formatting | Wrapping works correctly                           | PASS   | 8 |  0.097 |      |

| Failed | Warning | Skipped |
| :----- | :------ | :------ |
| 🛑      | ⚠️      | 🔶       |

</details>

<details>

<summary> Session Info </summary>

| Field    | Value                             |                                                                                                                                                                                                                                                                         |
| :------- | :-------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Version  | R version 4.0.3 (2020-10-10)      |                                                                                                                                                                                                                                                                         |
| Platform | x86\_64-apple-darwin17.0 (64-bit) | <a href="https://github.com/datalorax/equatiomatic/commit/e77fa87f39729e41beb296c3a32e0c73a845924f/checks" target="_blank"><span title="Built on Github Actions">![](https://github.com/metrumresearchgroup/covrpage/blob/actions/inst/logo/gh.png?raw=true)</span></a> |
| Running  | macOS Catalina 10.15.7            |                                                                                                                                                                                                                                                                         |
| Language | en\_US                            |                                                                                                                                                                                                                                                                         |
| Timezone | UTC                               |                                                                                                                                                                                                                                                                         |

| Package  | Version |
| :------- | :------ |
| testthat | 3.0.1   |
| covr     | 3.5.1   |
| covrpage | 0.1     |

</details>

<!--- Final Status : error/failed --->
