library(lme4)

test_that("Standard Poisson regression models work", {
  p1 <- glmer(stops ~ eth + (1|precinct), 
              data = arrests,
              family = poisson(link = "log"))
  expect_snapshot_output(extract_eq(p1))
  
  d <- arrests
  totes <- tapply(d$arrests, d$precinct, sum)
  tot_arrests <- data.frame(precinct = as.numeric(names(totes)),
                            total_arrests = totes)
  
  d <- merge(d, tot_arrests, by = "precinct")
  
  expect_warning(
    p_complicated <- glmer(stops ~ eth*total_arrests + (eth|precinct), 
                           data = d,
                           family = poisson(link = "log"))
  )
  expect_snapshot_output(extract_eq(p_complicated))
})

test_that("Binomial Logistic Regression models work", {
  m <- glmer(bush ~ 1 + black + female + edu + (black|state),
             data = polls,
             family = binomial(link = "logit"))
  expect_snapshot_output(extract_eq(m))
})
