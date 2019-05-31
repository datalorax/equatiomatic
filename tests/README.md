Tests and Coverage
================
31 May, 2019 17:46:39

  - [Coverage](#coverage)
  - [Unit Tests](#unit-tests)

This output is created by
[covrpage](https://github.com/metrumresearchgroup/covrpage).

## Coverage

Coverage summary is created using the
[covr](https://github.com/r-lib/covr) package.

| Object                               | Coverage (%) |
| :----------------------------------- | :----------: |
| equatiomatic                         |      0       |
| [R/extract\_eq.R](../R/extract_eq.R) |      0       |
| [R/printer.R](../R/printer.R)        |      0       |

<br>

## Unit Tests

Unit Test summary is created using the
[testthat](https://github.com/r-lib/testthat)
package.

| file                                      | n |  time | error | failed | skipped | warning |
| :---------------------------------------- | -: | ----: | ----: | -----: | ------: | ------: |
| [test-basic.R](testthat/test-basic.R)     | 2 | 0.006 |     0 |      0 |       0 |       0 |
| [test-preview.R](testthat/test-preview.R) | 1 | 0.226 |     0 |      0 |       0 |       0 |

<details closed>

<summary> Show Detailed Test Results
</summary>

| file                                          | context | test                   | status | n |  time |
| :-------------------------------------------- | :------ | :--------------------- | :----- | -: | ----: |
| [test-basic.R](testthat/test-basic.R#L14)     | basic   | extract: default       | PASS   | 1 | 0.003 |
| [test-basic.R](testthat/test-basic.R#L18)     | basic   | extract: all variables | PASS   | 1 | 0.003 |
| [test-preview.R](testthat/test-preview.R#L12) | preview | preview: texPreview    | PASS   | 1 | 0.226 |

</details>

<details>

<summary> Session Info </summary>

| Field    | Value                               |
| :------- | :---------------------------------- |
| Version  | R version 3.5.1 (2018-07-02)        |
| Platform | x86\_64-apple-darwin15.6.0 (64-bit) |
| Running  | macOS 10.14.5                       |
| Language | en\_US                              |
| Timezone | America/New\_York                   |

| Package  | Version |
| :------- | :------ |
| testthat | 2.0.1   |
| covr     | 3.2.1   |
| covrpage | 0.0.70  |

</details>

<!--- Final Status : pass --->
