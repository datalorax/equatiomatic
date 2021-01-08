Tests and Coverage
================
08 January, 2021 19:04:46

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
| equatiomatic                                     |    96.76     |
| [R/print.R](../R/print.R)                        |    35.71     |
| [R/extract\_lhs.R](../R/extract_lhs.R)           |    96.40     |
| [R/merMod.R](../R/merMod.R)                      |    96.45     |
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
| [test-clm.R](testthat/test-clm.R)                                 |  6 |  1.995 |     0 |      0 |       0 |       0 |      |
| [test-forecast-arima.R](testthat/test-forecast-arima.R)           |  4 |  1.481 |     0 |      0 |       0 |       0 |      |
| [test-glm.R](testthat/test-glm.R)                                 | 12 |  0.134 |     0 |      0 |       0 |       0 |      |
| [test-lm.R](testthat/test-lm.R)                                   |  7 |  0.055 |     0 |      0 |       0 |       0 |      |
| [test-lmerMod.R](testthat/test-lmerMod.R)                         | 30 | 50.595 |     0 |      0 |       0 |       0 |      |
| [test-polr.R](testthat/test-polr.R)                               |  5 |  0.099 |     0 |      0 |       0 |       0 |      |
| [test-print.R](testthat/test-print.R)                             |  5 |  1.520 |     0 |      3 |       0 |       0 | 🛑    |
| [test-utils.R](testthat/test-utils.R)                             |  8 |  0.048 |     0 |      0 |       0 |       0 |      |
| [test-wrapping-formatting.R](testthat/test-wrapping-formatting.R) | 10 |  0.082 |     0 |      0 |       0 |       0 |      |

<details open>

<summary> Show Detailed Test Results </summary>

| file                                                                      | context                 | test                                               | status | n |   time | icon |
| :------------------------------------------------------------------------ | :---------------------- | :------------------------------------------------- | :----- | -: | -----: | :--- |
| [test-clm.R](testthat/test-clm.R#L46_L47)                                 | CLMs                    | Ordered models with clm work                       | PASS   | 5 |  1.977 |      |
| [test-clm.R](testthat/test-clm.R#L79)                                     | CLMs                    | Unsupported CLMs create a message                  | PASS   | 1 |  0.018 |      |
| [test-forecast-arima.R](testthat/test-forecast-arima.R#L19_L20)           | forecast\_ARIMA         | Basic ARIMA model functions                        | PASS   | 2 |  0.374 |      |
| [test-forecast-arima.R](testthat/test-forecast-arima.R#L75_L76)           | forecast\_ARIMA         | Regression w/ ARIMA Errors functions               | PASS   | 2 |  1.107 |      |
| [test-glm.R](testthat/test-glm.R#L16_L17)                                 | GLMs                    | Logistic regression works                          | PASS   | 1 |  0.017 |      |
| [test-glm.R](testthat/test-glm.R#L33_L34)                                 | GLMs                    | Probit regression works                            | PASS   | 2 |  0.022 |      |
| [test-glm.R](testthat/test-glm.R#L49)                                     | GLMs                    | Unsupported GLMs create a message                  | PASS   | 1 |  0.010 |      |
| [test-glm.R](testthat/test-glm.R#L80_L81)                                 | GLMs                    | Distribution-based equations work                  | PASS   | 3 |  0.031 |      |
| [test-glm.R](testthat/test-glm.R#L108)                                    | GLMs                    | Weights work                                       | PASS   | 1 |  0.013 |      |
| [test-glm.R](testthat/test-glm.R#L123_L124)                               | GLMs                    | non-binomial regression works                      | PASS   | 4 |  0.041 |      |
| [test-lm.R](testthat/test-lm.R#L11_L12)                                   | Linear models           | Simple lm models work                              | PASS   | 3 |  0.023 |      |
| [test-lm.R](testthat/test-lm.R#L32_L33)                                   | Linear models           | Interactions work                                  | PASS   | 2 |  0.018 |      |
| [test-lm.R](testthat/test-lm.R#L48_L49)                                   | Linear models           | Custom Greek works                                 | PASS   | 2 |  0.014 |      |
| [test-lmerMod.R](testthat/test-lmerMod.R#L8_L9)                           | lmerMod                 | Unconditional lmer models work                     | PASS   | 3 |  1.002 |      |
| [test-lmerMod.R](testthat/test-lmerMod.R#L33_L34)                         | lmerMod                 | Level 1 predictors work                            | PASS   | 2 |  0.382 |      |
| [test-lmerMod.R](testthat/test-lmerMod.R#L45_L46)                         | lmerMod                 | Mean separate works as expected                    | PASS   | 2 |  0.344 |      |
| [test-lmerMod.R](testthat/test-lmerMod.R#L57_L58)                         | lmerMod                 | Wrapping works as expected                         | PASS   | 1 |  0.207 |      |
| [test-lmerMod.R](testthat/test-lmerMod.R#L67_L68)                         | lmerMod                 | Unstructured variance-covariances work as expected | PASS   | 5 |  5.699 |      |
| [test-lmerMod.R](testthat/test-lmerMod.R#L114_L115)                       | lmerMod                 | Group-level predictors work as expected            | PASS   | 3 | 32.236 |      |
| [test-lmerMod.R](testthat/test-lmerMod.R#L153_L154)                       | lmerMod                 | Interactions work as expected                      | PASS   | 5 |  7.949 |      |
| [test-lmerMod.R](testthat/test-lmerMod.R#L200_L201)                       | lmerMod                 | Alternate random effect VCV structures work        | PASS   | 3 |  2.174 |      |
| [test-lmerMod.R](testthat/test-lmerMod.R#L225_L227)                       | lmerMod                 | Nested model syntax works                          | PASS   | 6 |  0.602 |      |
| [test-polr.R](testthat/test-polr.R#L44_L45)                               | polr                    | Ordered logistic regression works                  | PASS   | 5 |  0.099 |      |
| [test-print.R](testthat/test-print.R#L11_L12)                             | Printing                | Equation is printed correctly                      | PASS   | 2 |  0.010 |      |
| [test-print.R](testthat/test-print.R#L24_L26)                             | Printing                | Equation is knit\_print-ed correctly               | FAILED | 3 |  1.510 | 🛑    |
| [test-utils.R](testthat/test-utils.R#L9_L11)                              | Utility functions       | Strict mapply\_\* functions work                   | PASS   | 8 |  0.048 |      |
| [test-wrapping-formatting.R](testthat/test-wrapping-formatting.R#L8_L9)   | Wrapping and formatting | Coefficient digits work correctly                  | PASS   | 2 |  0.019 |      |
| [test-wrapping-formatting.R](testthat/test-wrapping-formatting.R#L26_L27) | Wrapping and formatting | Wrapping works correctly                           | PASS   | 8 |  0.063 |      |

| Failed | Warning | Skipped |
| :----- | :------ | :------ |
| 🛑      | ⚠️      | 🔶       |

</details>

<details>

<summary> Session Info </summary>

| Field    | Value                             |                                                                                                                                                                                                                                                                         |
| :------- | :-------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Version  | R version 4.0.3 (2020-10-10)      |                                                                                                                                                                                                                                                                         |
| Platform | x86\_64-apple-darwin17.0 (64-bit) | <a href="https://github.com/datalorax/equatiomatic/commit/d0cc53f5666475c810990e88bf91d9d049db06db/checks" target="_blank"><span title="Built on Github Actions">![](https://github.com/metrumresearchgroup/covrpage/blob/actions/inst/logo/gh.png?raw=true)</span></a> |
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
