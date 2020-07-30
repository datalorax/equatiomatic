Tests and Coverage
================
29 July, 2020 23:25:01

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
| [test-clm.R](testthat/test-clm.R)                                 |  6 | 0.157 |     0 |      0 |       0 |       0 |
| [test-glm.R](testthat/test-glm.R)                                 |  3 | 0.033 |     0 |      0 |       0 |       0 |
| [test-lm.R](testthat/test-lm.R)                                   |  7 | 0.046 |     0 |      0 |       0 |       0 |
| [test-polr.R](testthat/test-polr.R)                               |  5 | 0.115 |     0 |      0 |       0 |       0 |
| [test-print.R](testthat/test-print.R)                             |  2 | 0.011 |     0 |      0 |       0 |       0 |
| [test-utils.R](testthat/test-utils.R)                             |  8 | 0.175 |     0 |      0 |       0 |       0 |
| [test-wrapping-formatting.R](testthat/test-wrapping-formatting.R) | 10 | 0.099 |     0 |      0 |       0 |       0 |

<details closed>

<summary> Show Detailed Test Results </summary>

| file                                                                      | context                 | test                              | status | n |  time |
| :------------------------------------------------------------------------ | :---------------------- | :-------------------------------- | :----- | -: | ----: |
| [test-clm.R](testthat/test-clm.R#L38_L39)                                 | CLMs                    | Ordered models with clm work      | PASS   | 5 | 0.136 |
| [test-clm.R](testthat/test-clm.R#L69)                                     | CLMs                    | Unsupported CLMs create a message | PASS   | 1 | 0.021 |
| [test-glm.R](testthat/test-glm.R#L16_L17)                                 | GLMs                    | Logistic regression works         | PASS   | 1 | 0.015 |
| [test-glm.R](testthat/test-glm.R#L33_L34)                                 | GLMs                    | Probit regression works           | PASS   | 1 | 0.010 |
| [test-glm.R](testthat/test-glm.R#L41)                                     | GLMs                    | Unsupported GLMs create a message | PASS   | 1 | 0.008 |
| [test-lm.R](testthat/test-lm.R#L11_L12)                                   | Linear models           | Simple lm models work             | PASS   | 3 | 0.019 |
| [test-lm.R](testthat/test-lm.R#L32_L33)                                   | Linear models           | Interactions work                 | PASS   | 2 | 0.016 |
| [test-lm.R](testthat/test-lm.R#L48_L49)                                   | Linear models           | Custom Greek works                | PASS   | 2 | 0.011 |
| [test-polr.R](testthat/test-polr.R#L36_L37)                               | polr                    | Ordered logistic regression works | PASS   | 5 | 0.115 |
| [test-print.R](testthat/test-print.R#L11_L12)                             | Printing                | Equation is printed correctly     | PASS   | 2 | 0.011 |
| [test-utils.R](testthat/test-utils.R#L9_L11)                              | Utility functions       | Strict mapply\_\* functions work  | PASS   | 8 | 0.175 |
| [test-wrapping-formatting.R](testthat/test-wrapping-formatting.R#L8_L9)   | Wrapping and formatting | Coefficient digits work correctly | PASS   | 2 | 0.020 |
| [test-wrapping-formatting.R](testthat/test-wrapping-formatting.R#L26_L27) | Wrapping and formatting | Wrapping works correctly          | PASS   | 8 | 0.079 |

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
