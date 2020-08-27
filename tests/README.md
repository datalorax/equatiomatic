Tests and Coverage
================
27 August, 2020 18:06:39

  - [Coverage](#coverage)
  - [Unit Tests](#unit-tests)

This output is created by
[covrpage](https://github.com/metrumresearchgroup/covrpage).

## Coverage

Coverage summary is created using the
[covr](https://github.com/r-lib/covr) package.

| Object                                 | Coverage (%) |
| :------------------------------------- | :----------: |
| equatiomatic                           |    99.66     |
| [R/extract\_lhs.R](../R/extract_lhs.R) |    98.70     |
| [R/create\_eq.R](../R/create_eq.R)     |    100.00    |
| [R/extract\_eq.R](../R/extract_eq.R)   |    100.00    |
| [R/extract\_rhs.R](../R/extract_rhs.R) |    100.00    |
| [R/print.R](../R/print.R)              |    100.00    |
| [R/utils.R](../R/utils.R)              |    100.00    |

<br>

## Unit Tests

Unit Test summary is created using the
[testthat](https://github.com/r-lib/testthat) package.

| file                                                              |  n |  time | error | failed | skipped | warning |
| :---------------------------------------------------------------- | -: | ----: | ----: | -----: | ------: | ------: |
| [test-clm.R](testthat/test-clm.R)                                 |  6 | 1.890 |     0 |      0 |       0 |       0 |
| [test-glm.R](testthat/test-glm.R)                                 |  8 | 0.123 |     0 |      0 |       0 |       0 |
| [test-lm.R](testthat/test-lm.R)                                   |  7 | 0.121 |     0 |      0 |       0 |       0 |
| [test-polr.R](testthat/test-polr.R)                               |  5 | 0.142 |     0 |      0 |       0 |       0 |
| [test-print.R](testthat/test-print.R)                             |  4 | 0.028 |     0 |      0 |       0 |       0 |
| [test-utils.R](testthat/test-utils.R)                             |  8 | 0.041 |     0 |      0 |       0 |       0 |
| [test-wrapping-formatting.R](testthat/test-wrapping-formatting.R) | 10 | 0.092 |     0 |      0 |       0 |       0 |

<details closed>

<summary> Show Detailed Test Results </summary>

| file                                                                      | context                 | test                                 | status | n |  time |
| :------------------------------------------------------------------------ | :---------------------- | :----------------------------------- | :----- | -: | ----: |
| [test-clm.R](testthat/test-clm.R#L46_L47)                                 | CLMs                    | Ordered models with clm work         | PASS   | 5 | 1.861 |
| [test-clm.R](testthat/test-clm.R#L79)                                     | CLMs                    | Unsupported CLMs create a message    | PASS   | 1 | 0.029 |
| [test-glm.R](testthat/test-glm.R#L16_L17)                                 | GLMs                    | Logistic regression works            | PASS   | 1 | 0.028 |
| [test-glm.R](testthat/test-glm.R#L33_L34)                                 | GLMs                    | Probit regression works              | PASS   | 2 | 0.037 |
| [test-glm.R](testthat/test-glm.R#L49)                                     | GLMs                    | Unsupported GLMs create a message    | PASS   | 1 | 0.011 |
| [test-glm.R](testthat/test-glm.R#L78_L79)                                 | GLMs                    | Distribution-based equations work    | PASS   | 3 | 0.034 |
| [test-glm.R](testthat/test-glm.R#L107)                                    | GLMs                    | Weights work                         | PASS   | 1 | 0.013 |
| [test-lm.R](testthat/test-lm.R#L11_L12)                                   | Linear models           | Simple lm models work                | PASS   | 3 | 0.027 |
| [test-lm.R](testthat/test-lm.R#L32_L33)                                   | Linear models           | Interactions work                    | PASS   | 2 | 0.020 |
| [test-lm.R](testthat/test-lm.R#L48_L49)                                   | Linear models           | Custom Greek works                   | PASS   | 2 | 0.074 |
| [test-polr.R](testthat/test-polr.R#L44_L45)                               | polr                    | Ordered logistic regression works    | PASS   | 5 | 0.142 |
| [test-print.R](testthat/test-print.R#L11_L12)                             | Printing                | Equation is printed correctly        | PASS   | 2 | 0.010 |
| [test-print.R](testthat/test-print.R#L24_L26)                             | Printing                | Equation is knit\_print-ed correctly | PASS   | 2 | 0.018 |
| [test-utils.R](testthat/test-utils.R#L9_L11)                              | Utility functions       | Strict mapply\_\* functions work     | PASS   | 8 | 0.041 |
| [test-wrapping-formatting.R](testthat/test-wrapping-formatting.R#L8_L9)   | Wrapping and formatting | Coefficient digits work correctly    | PASS   | 2 | 0.022 |
| [test-wrapping-formatting.R](testthat/test-wrapping-formatting.R#L26_L27) | Wrapping and formatting | Wrapping works correctly             | PASS   | 8 | 0.070 |

</details>

<details>

<summary> Session Info </summary>

| Field    | Value                             |                                                                                                                                                                                                                                                                         |
| :------- | :-------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Version  | R version 4.0.2 (2020-06-22)      |                                                                                                                                                                                                                                                                         |
| Platform | x86\_64-apple-darwin17.0 (64-bit) | <a href="https://github.com/datalorax/equatiomatic/commit/6b1df34e0904942a7a1843be969ece9fe06bf21c/checks" target="_blank"><span title="Built on Github Actions">![](https://github.com/metrumresearchgroup/covrpage/blob/actions/inst/logo/gh.png?raw=true)</span></a> |
| Running  | macOS Catalina 10.15.6            |                                                                                                                                                                                                                                                                         |
| Language | en\_US                            |                                                                                                                                                                                                                                                                         |
| Timezone | UTC                               |                                                                                                                                                                                                                                                                         |

| Package  | Version |
| :------- | :------ |
| testthat | 2.3.2   |
| covr     | 3.5.0   |
| covrpage | 0.0.71  |

</details>

<!--- Final Status : pass --->
