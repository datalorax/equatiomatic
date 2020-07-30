Tests and Coverage
================
29 July, 2020 14:34:02

  - [Coverage](#coverage)
  - [Unit Tests](#unit-tests)

This output is created by
[covrpage](https://github.com/yonicd/covrpage).

## Coverage

Coverage summary is created using the
[covr](https://github.com/r-lib/covr) package.

| Object                                 | Coverage (%) |
| :------------------------------------- | :----------: |
| equatiomatic                           |     100      |
| [R/create\_eq.R](../R/create_eq.R)     |     100      |
| [R/extract\_eq.R](../R/extract_eq.R)   |     100      |
| [R/extract\_lhs.R](../R/extract_lhs.R) |     100      |
| [R/extract\_rhs.R](../R/extract_rhs.R) |     100      |
| [R/print.R](../R/print.R)              |     100      |
| [R/utils.R](../R/utils.R)              |     100      |

<br>

## Unit Tests

Unit Test summary is created using the
[testthat](https://github.com/r-lib/testthat) package.

| file                                                              |  n |  time | error | failed | skipped | warning |
| :---------------------------------------------------------------- | -: | ----: | ----: | -----: | ------: | ------: |
| [test-glm.R](testthat/test-glm.R)                                 |  2 | 0.066 |     0 |      0 |       0 |       0 |
| [test-lm.R](testthat/test-lm.R)                                   |  7 | 0.042 |     0 |      0 |       0 |       0 |
| [test-polr.R](testthat/test-polr.R)                               |  3 | 0.033 |     0 |      0 |       0 |       0 |
| [test-print.R](testthat/test-print.R)                             |  2 | 0.006 |     0 |      0 |       0 |       0 |
| [test-utils.R](testthat/test-utils.R)                             |  8 | 0.031 |     0 |      0 |       0 |       0 |
| [test-wrapping-formatting.R](testthat/test-wrapping-formatting.R) | 10 | 0.048 |     0 |      0 |       0 |       0 |

<details closed>

<summary> Show Detailed Test Results </summary>

| file                                                                      | context                 | test                              | status | n |  time |
| :------------------------------------------------------------------------ | :---------------------- | :-------------------------------- | :----- | -: | ----: |
| [test-glm.R](testthat/test-glm.R#L16_L17)                                 | GLMs                    | Logistic regression works         | PASS   | 1 | 0.059 |
| [test-glm.R](testthat/test-glm.R#L24)                                     | GLMs                    | Unsupported GLMs create a message | PASS   | 1 | 0.007 |
| [test-lm.R](testthat/test-lm.R#L11_L12)                                   | Linear models           | Simple lm models work             | PASS   | 3 | 0.017 |
| [test-lm.R](testthat/test-lm.R#L32_L33)                                   | Linear models           | Interactions work                 | PASS   | 2 | 0.014 |
| [test-lm.R](testthat/test-lm.R#L48_L49)                                   | Linear models           | Custom Greek works                | PASS   | 2 | 0.011 |
| [test-polr.R](testthat/test-polr.R#L24_L25)                               | polr                    | Ordered logistic regression works | PASS   | 3 | 0.033 |
| [test-print.R](testthat/test-print.R#L11_L12)                             | Printing                | Equation is printed correctly     | PASS   | 2 | 0.006 |
| [test-utils.R](testthat/test-utils.R#L9_L11)                              | Utility functions       | Strict mapply\_\* functions work  | PASS   | 8 | 0.031 |
| [test-wrapping-formatting.R](testthat/test-wrapping-formatting.R#L8_L9)   | Wrapping and formatting | Coefficient digits work correctly | PASS   | 2 | 0.010 |
| [test-wrapping-formatting.R](testthat/test-wrapping-formatting.R#L26_L27) | Wrapping and formatting | Wrapping works correctly          | PASS   | 8 | 0.038 |

</details>

<details>

<summary> Session Info </summary>

| Field    | Value                             |
| :------- | :-------------------------------- |
| Version  | R version 4.0.0 (2020-04-24)      |
| Platform | x86\_64-apple-darwin17.0 (64-bit) |
| Running  | macOS Catalina 10.15.6            |
| Language | en\_US                            |
| Timezone | America/New\_York                 |

| Package  | Version |
| :------- | :------ |
| testthat | 2.3.2   |
| covr     | 3.5.0   |
| covrpage | 0.0.71  |

</details>

<!--- Final Status : pass --->