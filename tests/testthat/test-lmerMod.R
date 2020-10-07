context("lmerMod")
library(lme4)

test_that("Unconditional models work", {
  um_hsb <- lmer(math ~ 1 + (1|sch.id), data = hsb)
  um_l1 <- lmer(score ~ 1 + (1|sid), data = sim_longitudinal)
  um_l2 <- lmer(score ~ 1 + (1|sid) + (1|school), data = sim_longitudinal)
  um_l3 <- lmer(score ~ 1 + (1|sid) + (1|school) + (1|district), 
                data = sim_longitudinal)
  
  tex_um_hsb <- extract_eq(um_hsb)
  tex_um_l1 <- extract_eq(um_l1) 
  tex_um_l2 <- extract_eq(um_l2) 
  tex_um_l3 <- extract_eq(um_l3) 
  
  actual_um_hsb_eq
  actual_um_l1_eq 
  actual_um_l2_eq 
  actual_um_l3_eq 
})
