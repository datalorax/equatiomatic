Tests and Coverage
================
12 January, 2021 01:06:04

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
| equatiomatic                                     |    94.54     |
| [R/print.R](../R/print.R)                        |    35.71     |
| [R/merMod.R](../R/merMod.R)                      |    90.42     |
| [R/extract\_lhs.R](../R/extract_lhs.R)           |    95.74     |
| [R/extract\_rhs.R](../R/extract_rhs.R)           |    96.49     |
| [R/create\_eq.R](../R/create_eq.R)               |    99.56     |
| [R/extract\_eq.R](../R/extract_eq.R)             |    100.00    |
| [R/helpers\_forecast.R](../R/helpers_forecast.R) |    100.00    |
| [R/utils.R](../R/utils.R)                        |    100.00    |

<br>

## Unit Tests

Unit Test summary is created using the
[testthat](https://github.com/r-lib/testthat) package.

| file                                                              |  n |    time | error | failed | skipped | warning | icon |
| :---------------------------------------------------------------- | -: | ------: | ----: | -----: | ------: | ------: | :--- |
| [test-clm.R](testthat/test-clm.R)                                 |  6 |   4.710 |     0 |      0 |       0 |       0 |      |
| [test-forecast-arima.R](testthat/test-forecast-arima.R)           |  4 |   3.752 |     0 |      0 |       0 |       0 |      |
| [test-glm.R](testthat/test-glm.R)                                 | 12 |   0.131 |     0 |      0 |       0 |       0 |      |
| [test-lm.R](testthat/test-lm.R)                                   |  7 |   0.068 |     0 |      0 |       0 |       0 |      |
| [test-lmerMod.R](testthat/test-lmerMod.R)                         | 31 | 117.374 |     0 |      0 |       0 |       0 |      |
| [test-polr.R](testthat/test-polr.R)                               |  5 |   0.268 |     0 |      0 |       0 |       0 |      |
| [test-print.R](testthat/test-print.R)                             |  5 |   1.837 |     0 |      3 |       0 |       0 | 🛑    |
| [test-utils.R](testthat/test-utils.R)                             |  8 |   0.128 |     0 |      0 |       0 |       0 |      |
| [test-wrapping-formatting.R](testthat/test-wrapping-formatting.R) | 10 |   0.245 |     0 |      0 |       0 |       0 |      |

<details open>

<summary> Show Detailed Test Results </summary>

| file                                                                      | context                 | test                                               | status | n |   time | icon |
| :------------------------------------------------------------------------ | :---------------------- | :------------------------------------------------- | :----- | -: | -----: | :--- |
| [test-clm.R](testthat/test-clm.R#L46_L47)                                 | CLMs                    | Ordered models with clm work                       | PASS   | 5 |  4.691 |      |
| [test-clm.R](testthat/test-clm.R#L79)                                     | CLMs                    | Unsupported CLMs create a message                  | PASS   | 1 |  0.019 |      |
| [test-forecast-arima.R](testthat/test-forecast-arima.R#L19_L20)           | forecast\_ARIMA         | Basic ARIMA model functions                        | PASS   | 2 |  1.112 |      |
| [test-forecast-arima.R](testthat/test-forecast-arima.R#L75_L76)           | forecast\_ARIMA         | Regression w/ ARIMA Errors functions               | PASS   | 2 |  2.640 |      |
| [test-glm.R](testthat/test-glm.R#L16_L17)                                 | GLMs                    | Logistic regression works                          | PASS   | 1 |  0.016 |      |
| [test-glm.R](testthat/test-glm.R#L33_L34)                                 | GLMs                    | Probit regression works                            | PASS   | 2 |  0.021 |      |
| [test-glm.R](testthat/test-glm.R#L49)                                     | GLMs                    | Unsupported GLMs create a message                  | PASS   | 1 |  0.009 |      |
| [test-glm.R](testthat/test-glm.R#L80_L81)                                 | GLMs                    | Distribution-based equations work                  | PASS   | 3 |  0.030 |      |
| [test-glm.R](testthat/test-glm.R#L108)                                    | GLMs                    | Weights work                                       | PASS   | 1 |  0.013 |      |
| [test-glm.R](testthat/test-glm.R#L123_L124)                               | GLMs                    | non-binomial regression works                      | PASS   | 4 |  0.042 |      |
| [test-lm.R](testthat/test-lm.R#L11_L12)                                   | Linear models           | Simple lm models work                              | PASS   | 3 |  0.035 |      |
| [test-lm.R](testthat/test-lm.R#L32_L33)                                   | Linear models           | Interactions work                                  | PASS   | 2 |  0.019 |      |
| [test-lm.R](testthat/test-lm.R#L48_L49)                                   | Linear models           | Custom Greek works                                 | PASS   | 2 |  0.014 |      |
| [test-lmerMod.R](testthat/test-lmerMod.R#L8_L9)                           | lmerMod                 | Unconditional lmer models work                     | PASS   | 3 |  2.266 |      |
| [test-lmerMod.R](testthat/test-lmerMod.R#L33_L34)                         | lmerMod                 | Level 1 predictors work                            | PASS   | 2 |  1.198 |      |
| [test-lmerMod.R](testthat/test-lmerMod.R#L45_L46)                         | lmerMod                 | Mean separate works as expected                    | PASS   | 2 |  0.879 |      |
| [test-lmerMod.R](testthat/test-lmerMod.R#L57_L58)                         | lmerMod                 | Wrapping works as expected                         | PASS   | 1 |  0.204 |      |
| [test-lmerMod.R](testthat/test-lmerMod.R#L67_L68)                         | lmerMod                 | Unstructured variance-covariances work as expected | PASS   | 5 | 13.823 |      |
| [test-lmerMod.R](testthat/test-lmerMod.R#L114_L115)                       | lmerMod                 | Group-level predictors work as expected            | PASS   | 3 | 71.663 |      |
| [test-lmerMod.R](testthat/test-lmerMod.R#L153_L154)                       | lmerMod                 | Interactions work as expected                      | PASS   | 5 | 17.322 |      |
| [test-lmerMod.R](testthat/test-lmerMod.R#L200_L201)                       | lmerMod                 | Alternate random effect VCV structures work        | PASS   | 3 |  4.206 |      |
| [test-lmerMod.R](testthat/test-lmerMod.R#L225_L227)                       | lmerMod                 | Nested model syntax works                          | PASS   | 6 |  1.771 |      |
| [test-lmerMod.R](testthat/test-lmerMod.R#L258_L259)                       | lmerMod                 | use\_coef works                                    | PASS   | 1 |  4.042 |      |
| [test-polr.R](testthat/test-polr.R#L44_L45)                               | polr                    | Ordered logistic regression works                  | PASS   | 5 |  0.268 |      |
| [test-print.R](testthat/test-print.R#L11_L12)                             | Printing                | Equation is printed correctly                      | PASS   | 2 |  0.026 |      |
| [test-print.R](testthat/test-print.R#L24_L26)                             | Printing                | Equation is knit\_print-ed correctly               | FAILED | 3 |  1.811 | 🛑    |
| [test-utils.R](testthat/test-utils.R#L9_L11)                              | Utility functions       | Strict mapply\_\* functions work                   | PASS   | 8 |  0.128 |      |
| [test-wrapping-formatting.R](testthat/test-wrapping-formatting.R#L8_L9)   | Wrapping and formatting | Coefficient digits work correctly                  | PASS   | 2 |  0.051 |      |
| [test-wrapping-formatting.R](testthat/test-wrapping-formatting.R#L26_L27) | Wrapping and formatting | Wrapping works correctly                           | PASS   | 8 |  0.194 |      |

| Failed | Warning | Skipped |
| :----- | :------ | :------ |
| 🛑      | ⚠️      | 🔶       |

</details>

<details>

<summary> Session Info </summary>

| Field    | Value                             |                                                                                                                                                                                                                                                                         |
| :------- | :-------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Version  | R version 4.0.3 (2020-10-10)      |                                                                                                                                                                                                                                                                         |
| Platform | x86\_64-apple-darwin17.0 (64-bit) | <a href="https://github.com/datalorax/equatiomatic/commit/c3057051361b5626fe4319c2783fbf480871d281/checks" target="_blank"><span title="Built on Github Actions">![](https://github.com/metrumresearchgroup/covrpage/blob/actions/inst/logo/gh.png?raw=true)</span></a> |
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
