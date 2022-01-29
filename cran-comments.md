## Test environments
* local R installation, R 4.1.1
* mac OS 10.15 (on github actions) 4.1.1
* ubuntu 16.04 (on github actions), R 4.1.1
* Microsoft Windows Server 2019 20200726.1 (on github actions) R 4.0.2
* win-builder (devel)

Note that the package was only tested on R >= 4.0 because the **lme4** vignette will not build on previous versions (because **nloptr**, a dependency for **lme4**, requires R >= 4.0), but all other functionality of the package should still work on previous versions

## R CMD check results
Across all environment
0 errors | 0 warnings | 0 notes


