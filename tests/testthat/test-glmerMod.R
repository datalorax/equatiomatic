library(lme4)

test_that("Checking for random/fixed effects works", {
  m <- glmer(bush ~ 1 + edu + (black|state),
             data = polls,
             family = binomial(link = "logit"))
  expect_error(extract_eq(m))
})

d <- arrests
totes <- tapply(d$arrests, d$precinct, sum)
tot_arrests <- data.frame(precinct = as.numeric(names(totes)),
                          total_arrests = totes)

d <- merge(d, tot_arrests, by = "precinct")


test_that("colorizing works", {
  suppressWarnings(
    m <- lme4::glmer(stops ~ eth + total_arrests + (1|precinct), 
                     data = d,
                     family = poisson(link = "log"))
  )
  
  expect_snapshot_output(
    extract_eq(
      m,
      swap_var_names = c(
        stops = "Stops",
        "eth" = "Ethnicity",
        "total_arrests" = "Total Arrests"
      ),
      var_colors = c(
        eth = "red",
        stops = "blue"
      ),
      var_subscript_colors = c(
        eth = "purple"
      )
    )
  )
  
  suppressWarnings(
  expect_warning(
    extract_eq(
      m,
      swap_var_names = c(
        stops = "Stops",
        "eth" = "Ethnicity",
        "total_arrests" = "Total Arrests"
      ),
      var_colors = c(
        stops = "blue",
        eth = "red"
      ),
      var_subscript_colors = c(
        eth = "purple"
      ),
      greek_colors = rainbow(7)
    )
  )
  )
})

test_that("Renaming Variables works", {
  suppressWarnings(
    m6 <- lme4::glmer(stops ~ eth + total_arrests + (1|precinct), 
                      data = d,
                      family = poisson(link = "log"))
  )
  
  expect_snapshot_output(
    extract_eq(
      m6,
      swap_var_names = c(
        "eth" = "Ethnicity",
        "total_arrests" = "Total Arrests"
      ),
      swap_subscript_names = c(
        "black" = "Black",
        "hispanic" = "Hispanic/Latino",
        "white" = "White"
      )
    )
  )
})

test_that("Standard Poisson regression models work", {
  p1 <- glmer(stops ~ eth + (1|precinct), 
              data = arrests,
              family = poisson(link = "log"))
  expect_snapshot_output(extract_eq(p1))
  
  
  suppressWarnings(
    p_complicated <- glmer(stops ~ eth*total_arrests + (eth|precinct), 
                           data = d,
                           family = poisson(link = "log"))
  )
  expect_snapshot_output(extract_eq(p_complicated))
})


test_that("Poisson regression models with an offset work", {
  p_offset1 <- glmer(stops ~ eth + (1|precinct), 
              data = arrests,
              family = poisson(link = "log"),
              offset = log(arrests))
  expect_snapshot_output(extract_eq(p_offset1))
  
  
  suppressWarnings(
    p_offset_complicated <- glmer(stops ~ eth*total_arrests + (eth|precinct), 
                           data = d,
                           family = poisson(link = "log"),
                           offset = log(arrests))
  )
  expect_snapshot_output(extract_eq(p_offset_complicated))
})



test_that("Binomial Logistic Regression models work", {
  m <- glmer(bush ~ 1 + black + female + edu + (black|state),
             data = polls,
             family = binomial(link = "logit"))
  expect_snapshot_output(extract_eq(m))
})
