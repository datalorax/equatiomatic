library(lme4)

test_that("Checking for random/fixed effects works", {
  # PhG: On MacOS the following model fails to converge, thus issuing
  # warnings that are not part of the test itself... So, I suppress them.
  m <- suppressWarnings(
    lmer(score ~ wave + (group | sid), data = sim_longitudinal)
  )
  expect_error(extract_eq(m))
})

test_that("colorizing works", {
  # calculate district means
  dist_mean <- tapply(
    sim_longitudinal$score,
    sim_longitudinal$district,
    mean
  )
  
  # put them in a df to merge
  dist_mean <- data.frame(
    district = names(dist_mean),
    dist_mean = dist_mean
  )
  
  # create a new df with dist_mean added
  d <- merge(sim_longitudinal, dist_mean, by = "district")
  
  suppressWarnings(
    cl_long3 <- lme4::lmer(
      score ~ wave * group * treatment + wave * prop_low * treatment +
        (wave | sid) + (wave | school) +
        (wave + treatment | district),
      sim_longitudinal
    )
  )
  
  expect_snapshot_output(
    extract_eq(
      cl_long3,
      var_colors = c(
        wave = "blue", 
        treatment = "red",
        score = "#FF00CC"
      ),
      var_subscript_colors = c(
        group = "orange"
      )
    )
  )
  
  expect_warning(
    extract_eq(
      cl_long3,
      var_colors = c(
        wave = "blue", 
        treatment = "red",
        score = "#FF00CC"
      ),
      var_subscript_colors = c(
        group = "orange"
      ),
      greek_colors = rainbow(15)
    )
  )
  
  expect_warning(
    extract_eq(
      cl_long3,
      var_colors = c(
        wave = "blue", 
        treatment = "red",
        score = "#FF00CC"
      ),
      var_subscript_colors = c(
        group = "orange"
      ),
      subscript_colors = rev(rainbow(15))
    )
  )
})

test_that("Math extraction works", {
  expect_warning(
    m1 <- lmer(Reaction ~ log(Days + 1) + exp(Days) + poly(Days, 4) + 
                 (1 | Subject), 
               data = sleepstudy)
  )
  m2 <- lmer(score ~ log(wave + 1) + exp(prop_low) +
                     (log(wave + 1)|sid),
             data = sim_longitudinal)
  
  m3 <- lmer(score ~ wave + poly(prop_low, 4) +
                     (wave|sid) + (wave|school) + (wave|district),
             data = sim_longitudinal)
  
  expect_snapshot(extract_eq(m1))
  expect_snapshot(extract_eq(m2))
  expect_snapshot(extract_eq(m3))
})
test_that("Implicit ID variables are handled", {
  splt <- split(sim_longitudinal, sim_longitudinal$school)
  splt <- lapply(splt, function(x) {
    x$sid <- as.numeric(as.factor(x$sid))
    x
  })
  d <- do.call(rbind, splt)
  
  m <- lme4::lmer(
    score ~ wave + treatment +
      (wave | sid) + (wave | school),
    data = d
  )
  
  expect_snapshot_output(extract_eq(m))
  
})


test_that("Renaming Variables works", {
  m5 <- lme4::lmer(
    score ~ wave + group + treatment + prop_low +
      (wave | sid) + (wave + group + treatment | school) +
      (wave + treatment + prop_low | district),
    sim_longitudinal
  )
  
  expect_snapshot_output(
    extract_eq(
      m5,
      swap_var_names = c(
        "wave" = "Wave",
        "prop_low" = "P(low income)",
        "score" = "Student Scores"),
      swap_subscript_names = c(
        "1" = ""
      )
    )
  )
})

test_that("Really big models work", {
  big_mod <- lmer(rt ~ 0 + n1_intercept + n1_warning1 + n1_cuing1 + x1_intercept +  
         x1_warning1 + x1_cuing1 + n2_intercept + n2_warning1 + n2_cuing1 +  
         x2_intercept + x2_warning1 + x2_cuing1 + 
         (0 + n1_intercept + n1_warning1 + n1_cuing1 + x1_intercept + 
            x1_warning1 + x1_cuing1 + n2_intercept + n2_warning1 + n2_cuing1 + 
            x2_intercept + x2_warning1 + x2_cuing1 | id),
         data = test_data)
  expect_snapshot(extract_eq(big_mod))
})


DF <- structure(list(brochure = structure(c(2L, 1L, 2L, 1L, 1L, 1L, 1L, 2L, 1L, 1L), 
                                          .Label = c("pictorial", "standard"), 
                                          class = "factor"), 
                     disease = structure(c(1L, 2L, 2L, 2L, 1L, 2L, 2L, 1L, 1L, 2L), 
                                         .Label = c("BC", "DS"), 
                                         class = "factor"), 
                     ID = c(1L, 2L, 3L, 4L, 5L, 1L, 2L, 3L, 4L, 5L), 
                     error = c(5, 3.9, 70, 73.5, 0.2, 19.9, 60.6, 50.8, 0.1, 0.3), 
                     pers = c(4, 2.3, 4.7, 3.3, 3.7, 3, 5, 4.6, 4.4, 5)), 
                row.names = c(NA, -10L), class = c("tbl_df", "tbl", "data.frame"))

test_that("Categorical variable level parsing works (from issue #140)", {
  cat_interaction <- lmer(error ~ brochure * disease  + (1 | ID), data = DF)
  expect_snapshot_output(extract_eq(cat_interaction))
})


test_that("Unconditional lmer models work", {
  um_long1 <- lmer(score ~ 1 + (1 | sid), data = sim_longitudinal)
  expect_snapshot_output(extract_eq(um_long1))

  um_long2 <- lmer(score ~ 1 + (1 | sid) + (1 | school), data = sim_longitudinal)
  expect_snapshot_output(extract_eq(um_long2))

  um_long3 <- lmer(score ~ 1 + (1 | sid) + (1 | school) + (1 | district),
    data = sim_longitudinal
  )
  expect_snapshot_output(extract_eq(um_long3))
})

test_that("Level 1 predictors work", {
  # lev 1 models used for multiple tests
  lev1_hsb <- lmer(math ~ female + ses + minority + (1 | sch.id), hsb)
  lev1_long <- lmer(score ~ wave + (1 | sid) + (1 | school) + (1 | district),
    data = sim_longitudinal
  )

  # Level 1 predictors HSB
  expect_snapshot_output(extract_eq(lev1_hsb))

  # Level 1 longitudinal
  expect_snapshot_output(extract_eq(lev1_long))
})

test_that("Mean separate works as expected", {
  # lev 1 models used for multiple tests
  lev1_hsb <- lmer(math ~ female + ses + minority + (1 | sch.id), hsb)
  lev1_long <- lmer(score ~ wave + (1 | sid) + (1 | school) + (1 | district),
    data = sim_longitudinal
  )

  # Mean separate HSB
  expect_snapshot_output(extract_eq(lev1_hsb, mean_separate = FALSE))

  # Mean separate longitudinal
  expect_snapshot_output(extract_eq(lev1_long, mean_separate = TRUE))
})

test_that("Wrapping works as expected", {
  # lev 1 models used for multiple tests
  lev1_hsb <- lmer(math ~ female + ses + minority + (1 | sch.id), hsb)
  lev1_long <- lmer(score ~ wave + (1 | sid) + (1 | school) + (1 | district),
    data = sim_longitudinal
  )

  # Wrapping HSB
  expect_snapshot_output(extract_eq(lev1_hsb, wrap = TRUE, terms_per_line = 2))
})

test_that("Unstructured variance-covariances work as expected", {
  # two-level models
  hsb1 <- lmer(
    math ~ female + ses + minority + (minority | sch.id),
    hsb
  )

  # Unstructured VCV, HSB 1
  expect_snapshot_output(extract_eq(hsb1))

  # Unstructured VCV, HSB 2
  hsb2 <- lmer(
    math ~ female + ses + minority + (ses + female | sch.id),
    hsb
  )
  expect_snapshot_output(extract_eq(hsb2))

  # Unstructured VCV, HSB 3
  hsb3 <- lmer(
    math ~ female * ses + minority + (ses * female | sch.id),
    hsb
  )
  expect_snapshot_output(extract_eq(hsb3))

  # Unstructured VCV, HSB 4
  suppressWarnings(
    hsb4 <- lmer(
      math ~ female * ses + minority +
        (ses * female + minority | sch.id),
      hsb
    )
  )
  expect_snapshot_output(extract_eq(hsb4))

  # four-level model
  # Unstructured VCV, Longitudinal 1
  long1 <- lmer(
    score ~ wave +
      (wave | sid) + (wave | school) + (wave | district),
    sim_longitudinal
  )
  expect_snapshot_output(extract_eq(long1))
})

test_that("Group-level predictors work as expected", {
  # level 2 variables
  suppressWarnings(
    long2 <- lmer(
      score ~ wave + group + treatment +
        (wave | sid) + (wave + group + treatment | school) +
        (wave + treatment | district),
      sim_longitudinal
    )
  )

  # Group-level predictors, Longitudinal (level 2)
  expect_snapshot_output(extract_eq(long2))

  # level 3 variable
  long3 <- lmer(
    score ~ wave + group + treatment + prop_low +
      (wave | sid) + (wave + group + treatment | school) +
      (wave + treatment + prop_low | district),
    sim_longitudinal
  )

  # Group-level predictors, Longitudinal (level 3)
  expect_snapshot_output(extract_eq(long3))

  # level 4 variable
  dist_mean <- tapply(
    sim_longitudinal$score,
    sim_longitudinal$district,
    mean
  )
  dist_mean <- data.frame(
    district = names(dist_mean),
    dist_mean = dist_mean
  )
  sim_longitudinal <- merge(sim_longitudinal, dist_mean, by = "district")

  long4 <- lmer(
    score ~ wave + group + treatment + prop_low + dist_mean +
      (wave | sid) + (wave + treatment | school) +
      (wave | district),
    sim_longitudinal
  )

  # Group-level predictors, Longitudinal (level 4)
  expect_snapshot_output(extract_eq(long4))
})

data("sim_longitudinal", package = "equatiomatic")

test_that("Interactions work as expected", {
  # l1 interaction
  l1_hsb_int <- lmer(math ~ minority * female + (1 | sch.id),
    data = hsb
  )

  # Level 1 interaction
  expect_snapshot_output(extract_eq(l1_hsb_int))

  # l2 interaction
  l2_long_int <- lmer(score ~ treatment * group + (1 | sid) + (treatment | school) +
    (treatment * group | district),
  data = sim_longitudinal
  )
  expect_snapshot_output(extract_eq(l2_long_int))

  # cross-level interaction w/random at the level
  suppressWarnings(
    cl_long1 <- lmer(score ~ treatment * wave + (wave | sid) + (1 | school) +
      (1 | district),
    data = sim_longitudinal
    )
  )
  expect_snapshot_output(extract_eq(cl_long1))

  # cross-level interaction w/o random at the level
  cl_long2 <- lmer(score ~ treatment * wave + (1 | sid) + (1 | school) +
    (1 | district),
  data = sim_longitudinal
  )
  expect_snapshot_output(extract_eq(cl_long2))

  # Multiple cross-level interactions
  cl_long3 <- lmer(
    score ~ wave * group * treatment + prop_low * treatment * wave +
      (wave | sid) + (wave | school) +
      (wave + treatment | district),
    sim_longitudinal
  )
  expect_snapshot_output(extract_eq(cl_long3))
})

# Random effect structures with no covars estimated
test_that("Alternate random effect VCV structures work", {
  hsb_varsonly <- lmer(math ~ minority * female + (minority * female || sch.id),
    data = hsb
  )

  # Variance components only
  expect_snapshot_output(extract_eq(hsb_varsonly))

  suppressWarnings(
    hsb_doublegroup <- lmer(math ~ minority * female +
      (minority | sch.id) + (female | sch.id),
    data = hsb
    )
  )

  # Double grouping (like cross-classified models)
  expect_snapshot_output(extract_eq(hsb_varsonly))

  long_mixed_ranef <- lmer(
    score ~ wave +
      (wave || sid) + (wave | school) + (1 | school) + (wave || district),
    sim_longitudinal
  )

  # Mixed random effect structures at diff levels
  expect_snapshot_output(extract_eq(long_mixed_ranef))
})

test_that("Nested model syntax works", {
  suppressWarnings(
    nested_m1 <- lmer(score ~ 1 + (1 | sid / school), sim_longitudinal)
  )

  # Nested random effects 1
  expect_snapshot_output(extract_eq(nested_m1))

  suppressWarnings(
    nested_m2 <- lmer(score ~ 1 + (1 | sid / school / district), sim_longitudinal)
  )

  # Nested random effects 2
  expect_snapshot_output(extract_eq(nested_m1))

  suppressWarnings(
    nested_m3 <- lmer(score ~ wave + group + prop_low +
      (1 | sid / school / district), sim_longitudinal)
  )

  # Nested random effects 2
  expect_snapshot_output(extract_eq(nested_m1))
})

# PhG: skipping these two tests for now because they fail on MacOS. In fact,
# result is correct but coefficient roundings are slightly differents, at least
# on aarch64 (silicon) processors, it seems. expect_snapshot_output() is looking
# for an **exact** equivalence.
# TODO: a solution would be to make two different versions of this test, but
# that requires extended testings on different platforms.
test_that("use_coef works", {
  skip_on_os("mac", "aarch64")
  
  suppressWarnings(
    use_coef_m1 <- lmer(
      score ~ wave  + treatment +
        (wave | sid) + (wave | school) +
        (1 | district),
      sim_longitudinal
    )
  )
  # Nested random effects 3
  expect_snapshot_output(extract_eq(use_coef_m1, use_coefs = TRUE, coef.digits = 1))
})

test_that("return variances works", {
  skip_on_os("mac", "aarch64")
  
  suppressWarnings(
    use_coef_m1_var <- lmer(
      score ~ wave  + treatment +
        (wave | sid) + (wave | school) +
        (1 | district),
      sim_longitudinal
    )
  )
  # Nested random effects 3
  expect_snapshot_output(
    extract_eq(use_coef_m1_var, use_coefs = TRUE, return_variances = TRUE)
  )
})
