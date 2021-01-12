library(forecast)

# Test Group A: Simple Arima Model
test_that("Basic ARIMA model functions",{
  
  # Build Arima (no regression)
  model <- forecast::Arima(simple_ts, 
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
  # Build Exogenous Regressors
  xregs <- as.matrix(data.frame(x1 = ts_reg_list$x1 + 5,
                                x2 = ts_reg_list$x2 * 5))
  
  regress_ts <- ts(ts_reg_list$ts_rnorm,freq = 4)
  
  # Build Regression Model
  model <- forecast::Arima(regress_ts, 
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
