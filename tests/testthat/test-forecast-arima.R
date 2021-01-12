library(forecast)

# Test Group A: Simple Arima Model
test_that("Basic ARIMA model functions",{
  # Set seed so that rnorm returns the same result
  set.seed(123)
  
  # Build Arima (no regression)
  model <- forecast::Arima(ts(rnorm(1000),freq=4), 
                           order=c(1,1,1),
                           seasonal=c(1,0,1),
                           include.constant = TRUE)
  
  # Test 1: Works with greek letters
  # basic Arima + greek builds correctly
  expect_snapshot_output(extract_eq(model))
  
  # Test 2: Works with coefficients
  expect_snapshot_output(extract_eq(model, use_coefs = TRUE))
})

# Test Group B: Regression w/ ARIMA Errors
test_that("Regression w/ ARIMA Errors functions",{
  # Set seed so that rnorm returns the same result
  set.seed(123)
  
  # Build our random numbers
  rnd_numbers <- list(x1 = rnorm(1000),
                      x2 = rnorm(1000),
                      ts_rnorm = rnorm(1000))
  
  # Build Exogenous Regressors
  xregs <- as.matrix(data.frame(x1 = rnd_numbers$x1 + 5,
                                x2 = rnd_numbers$x2 * 5))
  
  # Build Regression Model
  model <- forecast::Arima(ts(rnd_numbers$ts_rnorm,freq=4), 
                           order=c(1,1,1),
                           seasonal=c(1,0,1),
                           xreg = xregs,
                           include.constant = TRUE)
  
  # Test 1: Works with greek letters
  # Regession w/ Arima Errors + greek builds correctly
  expect_snapshot_output(extract_eq(model))
  
  # Test 2: Works with coefficients
  # Regession w/ Arima Errors + coefficients builds correctly
  expect_snapshot_output(extract_eq(model, use_coefs = TRUE))
})
