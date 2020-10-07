context("lmerMod")
library(lme4)

test_that("Unconditional lmer models work", {
  um_hsb <- lmer(math ~ 1 + (1|sch.id), data = hsb)
  tex_um_hsb <- extract_eq(um_hsb)
  actual_um_hsb <- "\\begin{aligned}\n  \\operatorname{math}  &\\sim N \\left(\\alpha_{j[i]}, \\sigma^2 \\right) \\\\ \n    \\alpha_{j}  &\\sim N \\left(\\mu_{\\alpha_{j}}, \\sigma^2_{\\alpha_{j}} \\right)\n      \\text{, for sch.id j = 1,} \\dots \\text{,J}\n\\end{aligned}"
  expect_equal(tex_um_hsb, equation_class(actual_um_hsb),
               label = "Unconditional HSB model")
  
  um_long1 <- lmer(score ~ 1 + (1|sid), data = sim_longitudinal)
  tex_um_long1 <- extract_eq(um_long1) 
  actual_um_long1 <- "\\begin{aligned}\n  \\operatorname{score}  &\\sim N \\left(\\alpha_{j[i]}, \\sigma^2 \\right) \\\\ \n    \\alpha_{j}  &\\sim N \\left(\\mu_{\\alpha_{j}}, \\sigma^2_{\\alpha_{j}} \\right)\n      \\text{, for sid j = 1,} \\dots \\text{,J}\n\\end{aligned}"
  expect_equal(tex_um_long1, equation_class(actual_um_long1),
               label = "Unconditional two-level longitudinal model")
  
  um_long2 <- lmer(score ~ 1 + (1|sid) + (1|school), data = sim_longitudinal)
  tex_um_long2 <- extract_eq(um_long2)
  actual_um_long2 <- "\\begin{aligned}\n  \\operatorname{score}  &\\sim N \\left(\\alpha_{j[i],k[i]}, \\sigma^2 \\right) \\\\ \n    \\alpha_{j}  &\\sim N \\left(\\mu_{\\alpha_{j}}, \\sigma^2_{\\alpha_{j}} \\right)\n      \\text{, for sid j = 1,} \\dots \\text{,J} \\\\ \n    \\alpha_{k}  &\\sim N \\left(\\mu_{\\alpha_{k}}, \\sigma^2_{\\alpha_{k}} \\right)\n      \\text{, for school k = 1,} \\dots \\text{,K}\n\\end{aligned}"
  expect_equal(tex_um_long2, equation_class(actual_um_long2),
               label = "Unconditional three-level longitudinal model")
  
  um_long3 <- lmer(score ~ 1 + (1|sid) + (1|school) + (1|district), 
                data = sim_longitudinal)
  tex_um_long3 <- extract_eq(um_long3)
  actual_um_long3 <- "\\begin{aligned}\n  \\operatorname{score}  &\\sim N \\left(\\alpha_{j[i],k[i],l[i]}, \\sigma^2 \\right) \\\\ \n    \\alpha_{j}  &\\sim N \\left(\\mu_{\\alpha_{j}}, \\sigma^2_{\\alpha_{j}} \\right)\n      \\text{, for sid j = 1,} \\dots \\text{,J} \\\\ \n    \\alpha_{k}  &\\sim N \\left(\\mu_{\\alpha_{k}}, \\sigma^2_{\\alpha_{k}} \\right)\n      \\text{, for school k = 1,} \\dots \\text{,K} \\\\ \n    \\alpha_{l}  &\\sim N \\left(\\mu_{\\alpha_{l}}, \\sigma^2_{\\alpha_{l}} \\right)\n      \\text{, for district l = 1,} \\dots \\text{,L}\n\\end{aligned}"
  expect_equal(tex_um_long3, equation_class(actual_um_long3),
               label = "Unconditional three-level longitudinal model")
})

test_that("Level 1 predictors work", {
  lev1_hsb <- lmer(math ~ female + ses + minority + (1|sch.id),
                   hsb)
  tex_lev1_hsb <- extract_eq(lev1_hsb)
  actual_lev1_hsb <- "\\begin{aligned}\n  \\operatorname{math}  &\\sim N \\left(\\mu, \\sigma^2 \\right) \\\\ \\mu &=\\alpha_{j[i]} + \\beta_{1}(\\operatorname{female}) + \\beta_{2}(\\operatorname{ses}) + \\beta_{3}(\\operatorname{minority}) \\\\ \n    \\alpha_{j}  &\\sim N \\left(\\mu_{\\alpha_{j}}, \\sigma^2_{\\alpha_{j}} \\right)\n      \\text{, for sch.id j = 1,} \\dots \\text{,J}\n\\end{aligned}"
  expect_equal(tex_lev1_hsb, equation_class(actual_lev1_hsb),
               label = "Level 1 predictors HSB")
  
  lev1_long <- lmer(score ~ wave + (1|sid) + (1|school) + (1|district),
                    data = sim_longitudinal)
  tex_lev1_long <- extract_eq(lev1_long)
  actual_lev1_long <- "\\begin{aligned}\n  \\operatorname{score}  &\\sim N \\left(\\alpha_{j[i],k[i],l[i]} + \\beta_{1}(\\operatorname{wave}), \\sigma^2 \\right) \\\\ \n    \\alpha_{j}  &\\sim N \\left(\\mu_{\\alpha_{j}}, \\sigma^2_{\\alpha_{j}} \\right)\n      \\text{, for sid j = 1,} \\dots \\text{,J} \\\\ \n    \\alpha_{k}  &\\sim N \\left(\\mu_{\\alpha_{k}}, \\sigma^2_{\\alpha_{k}} \\right)\n      \\text{, for school k = 1,} \\dots \\text{,K} \\\\ \n    \\alpha_{l}  &\\sim N \\left(\\mu_{\\alpha_{l}}, \\sigma^2_{\\alpha_{l}} \\right)\n      \\text{, for district l = 1,} \\dots \\text{,L}\n\\end{aligned}"
  expect_equal(tex_lev1_long, equation_class(actual_lev1_long),
               label = "Level 1 longitudinal")
})

test_that("Unstructured variance-covariances work as expected", {
  # two-level models
  hsb1 <- lmer(math ~ female + ses + minority + (female|sch.id),
               hsb)
  tex_hsb1 <- extract_eq(hsb1)
  
  hsb2 <- lmer(math ~ female + ses + minority + (ses + female|sch.id),
               hsb)
  tex_hsb2 <- extract_eq(hsb2)
  
  hsb3 <- lmer(math ~ female * ses + minority + (ses * female|sch.id),
               hsb)
  tex_hsb3 <- extract_eq(hsb3)
  
  hsb4 <- lmer(math ~ female * ses + minority + 
                 (ses * female + minority|sch.id),
               hsb)
  tex_hsb4 <- extract_eq(hsb4)
  
  # four-level models
  long1 <- lmer(score ~ wave + group + 
                  (wave|sid) + (wave|school) + (wave|district),
             sim_longitudinal)
  tex_
  long2 <- lmer(score ~ wave + group + 
                  (wave|sid) + (wave + group + treatment|school) + 
                  (wave + treatment|district),
                sim_longitudinal)
  
})

test_that("Interactions work as expected", {
  # l1 interaction
  # l2 interaction
  # cross-level interaction w/random at the level
  # cross-level interaction w/o random at the level
})

