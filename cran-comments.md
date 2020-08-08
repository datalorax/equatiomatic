## Resubmission
This is a resubmission. In this version we have

* Fixed all of the broken links referencing a deleted branch in `inst/doc/tests_and_coverage.html`
* Removed Rd documentation for all internal functions (which before had shown up with missing RD-tags). This also fixes the issue related to examples in unexported functions. 
* Added single quotes around 'LaTeX' in the Title and Description
* Added `()` to function names in the description text.

In addition to these changes, we made one minor additional change by including and documenting a new data source in the package, removing the palmerpenguins package from `Imports`, and crediting its source in the README.

## Test environments
* local R installation, R 4.0.2
* mac OS 10.15 (on github actions) 4.0.2
* ubuntu 16.04 (on github actions), R 4.0.2, R-devel, R 3.6.3
* Microsoft Windows Server 2019 20200726.1 (on github actions) R 4.0.2, R 3.6.3
* win-builder (devel)

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.
