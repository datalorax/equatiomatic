Tests and Coverage
================
19 June, 2019 15:26:43

  - [Coverage](#coverage)
  - [Unit Tests](#unit-tests)

This output is created by
[covrpage](https://github.com/metrumresearchgroup/covrpage).

## Coverage

Coverage summary is created using the
[covr](https://github.com/r-lib/covr) package.

| Object                                 | Coverage (%) |
| :------------------------------------- | :----------: |
| equatiomatic                           |    99.32     |
| [R/create\_eq.R](../R/create_eq.R)     |    98.21     |
| [R/extract\_eq.R](../R/extract_eq.R)   |    100.00    |
| [R/extract\_lhs.R](../R/extract_lhs.R) |    100.00    |
| [R/extract\_rhs.R](../R/extract_rhs.R) |    100.00    |
| [R/preview.R](../R/preview.R)          |    100.00    |
| [R/print.R](../R/print.R)              |    100.00    |
| [R/utils.R](../R/utils.R)              |    100.00    |

<br>

## Unit Tests

Unit Test summary is created using the
[testthat](https://github.com/r-lib/testthat) package.

| file                                                              |  n |  time | error | failed | skipped | warning |
| :---------------------------------------------------------------- | -: | ----: | ----: | -----: | ------: | ------: |
| [test-glm.R](testthat/test-glm.R)                                 |  2 | 0.015 |     0 |      0 |       0 |       0 |
| [test-lm.R](testthat/test-lm.R)                                   |  3 | 0.011 |     0 |      0 |       0 |       0 |
| [test-preview.R](testthat/test-preview.R)                         |  3 | 1.095 |     0 |      0 |       0 |       0 |
| [test-print.R](testthat/test-print.R)                             |  2 | 0.005 |     0 |      0 |       0 |       0 |
| [test-utils.R](testthat/test-utils.R)                             |  8 | 0.009 |     0 |      0 |       0 |       0 |
| [test-wrapping-formatting.R](testthat/test-wrapping-formatting.R) | 10 | 0.038 |     0 |      0 |       0 |       0 |

<details closed>

<summary> Show Detailed Test Results </summary>

| file                                                                      | context                 | test                                            | status | n |  time |
| :------------------------------------------------------------------------ | :---------------------- | :---------------------------------------------- | :----- | -: | ----: |
| [test-glm.R](testthat/test-glm.R#L16_L17)                                 | GLMs                    | Logistic regression works                       | PASS   | 1 | 0.009 |
| [test-glm.R](testthat/test-glm.R#L24)                                     | GLMs                    | Unsupported GLMs create a message               | PASS   | 1 | 0.006 |
| [test-lm.R](testthat/test-lm.R#L11_L12)                                   | Linear models           | Simple lm models work                           | PASS   | 3 | 0.011 |
| [test-preview.R](testthat/test-preview.R#L13_L14)                         | Previewing              | Previewing works                                | PASS   | 2 | 1.087 |
| [test-preview.R](testthat/test-preview.R#L23_L28)                         | Previewing              | Previewing stops if texPreview is not installed | PASS   | 1 | 0.008 |
| [test-print.R](testthat/test-print.R#L11_L12)                             | Printing                | Equation is printed correctly                   | PASS   | 2 | 0.005 |
| [test-utils.R](testthat/test-utils.R#L9_L11)                              | Utility functions       | Strict mapply\_\* functions work                | PASS   | 8 | 0.009 |
| [test-wrapping-formatting.R](testthat/test-wrapping-formatting.R#L8_L9)   | Wrapping and formatting | Coefficient digits work correctly               | PASS   | 2 | 0.007 |
| [test-wrapping-formatting.R](testthat/test-wrapping-formatting.R#L26_L27) | Wrapping and formatting | Wrapping works correctly                        | PASS   | 8 | 0.031 |

</details>

<details>

<summary> Session Info </summary>

| Field    | Value                               |
| :------- | :---------------------------------- |
| Version  | R version 3.6.0 (2019-04-26)        |
| Platform | x86\_64-apple-darwin15.6.0 (64-bit) |
| Running  | macOS Mojave 10.14.5                |
| Language | en\_US                              |
| Timezone | America/Denver                      |

| Package  | Version |
| :------- | :------ |
| testthat | 2.1.1   |
| covr     | 3.2.1   |
| covrpage | 0.0.70  |

</details>

<!--- Final Status : pass --->
