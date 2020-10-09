library(lme4)

test_that("Unconditional lmer models work", {
  um_hsb <- lmer(math ~ 1 + (1|sch.id), data = hsb)
  tex_um_hsb <- extract_eq(um_hsb)
  actual_um_hsb <- "\\begin{aligned}\n  \\operatorname{math}  &\\sim N \\left(\\alpha_{j[i]}, \\sigma^2 \\right) \\\\\n    \\alpha_{j}  &\\sim N \\left(\\mu_{\\alpha_{j}}, \\sigma^2_{\\alpha_{j}} \\right)\n    \\text{, for sch.id j = 1,} \\dots \\text{,J}\n\\end{aligned}"
  expect_equal(tex_um_hsb, equation_class(actual_um_hsb),
               label = "Unconditional HSB model")
  
  um_long1 <- lmer(score ~ 1 + (1|sid), data = sim_longitudinal)
  tex_um_long1 <- extract_eq(um_long1) 
  actual_um_long1 <- "\\begin{aligned}\n  \\operatorname{score}  &\\sim N \\left(\\alpha_{j[i]}, \\sigma^2 \\right) \\\\\n    \\alpha_{j}  &\\sim N \\left(\\mu_{\\alpha_{j}}, \\sigma^2_{\\alpha_{j}} \\right)\n    \\text{, for sid j = 1,} \\dots \\text{,J}\n\\end{aligned}"
  expect_equal(tex_um_long1, equation_class(actual_um_long1),
               label = "Unconditional two-level longitudinal model")
  
  um_long2 <- lmer(score ~ 1 + (1|sid) + (1|school), data = sim_longitudinal)
  tex_um_long2 <- extract_eq(um_long2)
  actual_um_long2 <- "\\begin{aligned}\n  \\operatorname{score}  &\\sim N \\left(\\alpha_{j[i],k[i]}, \\sigma^2 \\right) \\\\\n    \\alpha_{j}  &\\sim N \\left(\\mu_{\\alpha_{j}}, \\sigma^2_{\\alpha_{j}} \\right)\n    \\text{, for sid j = 1,} \\dots \\text{,J} \\\\\n    \\alpha_{k}  &\\sim N \\left(\\mu_{\\alpha_{k}}, \\sigma^2_{\\alpha_{k}} \\right)\n    \\text{, for school k = 1,} \\dots \\text{,K}\n\\end{aligned}"
  expect_equal(tex_um_long2, equation_class(actual_um_long2),
               label = "Unconditional three-level longitudinal model")
  
  um_long3 <- lmer(score ~ 1 + (1|sid) + (1|school) + (1|district), 
                data = sim_longitudinal)
  tex_um_long3 <- extract_eq(um_long3)
  actual_um_long3 <- "\\begin{aligned}\n  \\operatorname{score}  &\\sim N \\left(\\alpha_{j[i],k[i],l[i]}, \\sigma^2 \\right) \\\\\n    \\alpha_{j}  &\\sim N \\left(\\mu_{\\alpha_{j}}, \\sigma^2_{\\alpha_{j}} \\right)\n    \\text{, for sid j = 1,} \\dots \\text{,J} \\\\\n    \\alpha_{k}  &\\sim N \\left(\\mu_{\\alpha_{k}}, \\sigma^2_{\\alpha_{k}} \\right)\n    \\text{, for school k = 1,} \\dots \\text{,K} \\\\\n    \\alpha_{l}  &\\sim N \\left(\\mu_{\\alpha_{l}}, \\sigma^2_{\\alpha_{l}} \\right)\n    \\text{, for district l = 1,} \\dots \\text{,L}\n\\end{aligned}"
  expect_equal(tex_um_long3, equation_class(actual_um_long3),
               label = "Unconditional three-level longitudinal model")
})

# lev 1 models used for multiple tests
lev1_hsb <- lmer(math ~ female + ses + minority + (1|sch.id), hsb)
lev1_long <- lmer(score ~ wave + (1|sid) + (1|school) + (1|district),
                  data = sim_longitudinal)

test_that("Level 1 predictors work", {
  tex_lev1_hsb <- extract_eq(lev1_hsb)
  actual_lev1_hsb <- "\\begin{aligned}\n  \\operatorname{math}  &\\sim N \\left(\\mu, \\sigma^2 \\right) \\\\\n    \\mu &=\\alpha_{j[i]} + \\beta_{1}(\\operatorname{female}) + \\beta_{2}(\\operatorname{ses}) + \\beta_{3}(\\operatorname{minority}) \\\\\n    \\alpha_{j}  &\\sim N \\left(\\mu_{\\alpha_{j}}, \\sigma^2_{\\alpha_{j}} \\right)\n    \\text{, for sch.id j = 1,} \\dots \\text{,J}\n\\end{aligned}"
  expect_equal(tex_lev1_hsb, equation_class(actual_lev1_hsb),
               label = "Level 1 predictors HSB")
  
  tex_lev1_long <- extract_eq(lev1_long)
  actual_lev1_long <- "\\begin{aligned}\n  \\operatorname{score}  &\\sim N \\left(\\alpha_{j[i],k[i],l[i]} + \\beta_{1}(\\operatorname{wave}), \\sigma^2 \\right) \\\\\n    \\alpha_{j}  &\\sim N \\left(\\mu_{\\alpha_{j}}, \\sigma^2_{\\alpha_{j}} \\right)\n    \\text{, for sid j = 1,} \\dots \\text{,J} \\\\\n    \\alpha_{k}  &\\sim N \\left(\\mu_{\\alpha_{k}}, \\sigma^2_{\\alpha_{k}} \\right)\n    \\text{, for school k = 1,} \\dots \\text{,K} \\\\\n    \\alpha_{l}  &\\sim N \\left(\\mu_{\\alpha_{l}}, \\sigma^2_{\\alpha_{l}} \\right)\n    \\text{, for district l = 1,} \\dots \\text{,L}\n\\end{aligned}"
  expect_equal(tex_lev1_long, equation_class(actual_lev1_long),
               label = "Level 1 longitudinal")
})

test_that("Mean separate works as expected", {
  tex_lev1_hsb_ms <- extract_eq(lev1_hsb, mean_separate = FALSE)
  actual_lev1_hsb_ms <- "\\begin{aligned}\n  \\operatorname{math}  &\\sim N \\left(\\alpha_{j[i]} + \\beta_{1}(\\operatorname{female}) + \\beta_{2}(\\operatorname{ses}) + \\beta_{3}(\\operatorname{minority}), \\sigma^2 \\right) \\\\\n    \\alpha_{j}  &\\sim N \\left(\\mu_{\\alpha_{j}}, \\sigma^2_{\\alpha_{j}} \\right)\n    \\text{, for sch.id j = 1,} \\dots \\text{,J}\n\\end{aligned}"
  expect_equal(tex_lev1_hsb_ms, equation_class(actual_lev1_hsb_ms),
               label = "Mean separate HSB")
  
  tex_lev1_long_ms <- extract_eq(lev1_long, mean_separate = TRUE)
  actual_lev1_long1_ms <- "\\begin{aligned}\n  \\operatorname{score}  &\\sim N \\left(\\mu, \\sigma^2 \\right) \\\\\n    \\mu &=\\alpha_{j[i],k[i],l[i]} + \\beta_{1}(\\operatorname{wave}) \\\\\n    \\alpha_{j}  &\\sim N \\left(\\mu_{\\alpha_{j}}, \\sigma^2_{\\alpha_{j}} \\right)\n    \\text{, for sid j = 1,} \\dots \\text{,J} \\\\\n    \\alpha_{k}  &\\sim N \\left(\\mu_{\\alpha_{k}}, \\sigma^2_{\\alpha_{k}} \\right)\n    \\text{, for school k = 1,} \\dots \\text{,K} \\\\\n    \\alpha_{l}  &\\sim N \\left(\\mu_{\\alpha_{l}}, \\sigma^2_{\\alpha_{l}} \\right)\n    \\text{, for district l = 1,} \\dots \\text{,L}\n\\end{aligned}"
  expect_equal(tex_lev1_long_ms, equation_class(actual_lev1_long1_ms),
               label = "Mean separate longitudinal")
})

test_that("Wrapping works as expected", {
  tex_lev1_hsb_wrap <- extract_eq(lev1_hsb, wrap = TRUE, terms_per_line = 2)
  actual_lev1_hsb_wrap <- "\\begin{aligned}\n  \\operatorname{math}  &\\sim N \\left(\\mu, \\sigma^2 \\right) \\\\\n    \\mu &=\\alpha_{j[i]} + \\beta_{1}(\\operatorname{female})\\ + \\\\\n&\\quad \\beta_{2}(\\operatorname{ses}) + \\beta_{3}(\\operatorname{minority}) \\\\\n    \\alpha_{j}  &\\sim N \\left(\\mu_{\\alpha_{j}}, \\sigma^2_{\\alpha_{j}} \\right)\n    \\text{, for sch.id j = 1,} \\dots \\text{,J}\n\\end{aligned}"
  expect_equal(tex_lev1_hsb_wrap, equation_class(actual_lev1_hsb_wrap),
               label = "Wrapping HSB")
})
  
test_that("Unstructured variance-covariances work as expected", {
  # two-level models
  hsb1 <- lmer(math ~ female + ses + minority + (female|sch.id),
               hsb)
  tex_hsb1 <- extract_eq(hsb1)
  actual_hsb1 <- "\\begin{aligned}\n  \\operatorname{math}  &\\sim N \\left(\\mu, \\sigma^2 \\right) \\\\\n    \\mu &=\\alpha_{j[i]} + \\beta_{1j[i]}(\\operatorname{female}) + \\beta_{2}(\\operatorname{ses}) + \\beta_{3}(\\operatorname{minority}) \\\\    \n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\alpha_{j} \\\\\n      &\\beta_{1j}\n    \\end{aligned}\n  \\end{array}\n\\right)\n  &\\sim N \\left(\n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\mu_{\\alpha_{j}} \\\\\n      &\\mu_{\\beta_{1j}}\n    \\end{aligned}\n  \\end{array}\n\\right)\n, \n\\left(\n  \\begin{array}{cc}\n     \\sigma^2_{\\alpha_{j}} & \\rho\\alpha_{j}\\beta_{1j} \\\\ \n     \\rho\\beta_{1j}\\alpha_{j} & \\sigma^2_{\\beta_{1j}}\n  \\end{array}\n\\right)\n \\right)\n    \\text{, for sch.id j = 1,} \\dots \\text{,J}\n\\end{aligned}"
  expect_equal(tex_hsb1, equation_class(actual_hsb1),
               label = "Unstructured VCV, HSB 1")
  
  hsb2 <- lmer(math ~ female + ses + minority + (ses + female|sch.id),
               hsb)
  tex_hsb2 <- extract_eq(hsb2)
  actual_hsb2 <- "\\begin{aligned}\n  \\operatorname{math}  &\\sim N \\left(\\mu, \\sigma^2 \\right) \\\\\n    \\mu &=\\alpha_{j[i]} + \\beta_{1j[i]}(\\operatorname{female}) + \\beta_{2j[i]}(\\operatorname{ses}) + \\beta_{3}(\\operatorname{minority}) \\\\    \n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\alpha_{j} \\\\\n      &\\beta_{1j} \\\\\n      &\\beta_{2j}\n    \\end{aligned}\n  \\end{array}\n\\right)\n  &\\sim N \\left(\n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\mu_{\\alpha_{j}} \\\\\n      &\\mu_{\\beta_{1j}} \\\\\n      &\\mu_{\\beta_{2j}}\n    \\end{aligned}\n  \\end{array}\n\\right)\n, \n\\left(\n  \\begin{array}{ccc}\n     \\sigma^2_{\\alpha_{j}} & \\rho\\alpha_{j}\\beta_{1j} & \\rho\\alpha_{j}\\beta_{2j} \\\\ \n     \\rho\\beta_{1j}\\alpha_{j} & \\sigma^2_{\\beta_{1j}} & \\rho\\beta_{1j}\\beta_{2j} \\\\ \n     \\rho\\beta_{2j}\\alpha_{j} & \\rho\\beta_{2j}\\beta_{1j} & \\sigma^2_{\\beta_{2j}}\n  \\end{array}\n\\right)\n \\right)\n    \\text{, for sch.id j = 1,} \\dots \\text{,J}\n\\end{aligned}"
  expect_equal(tex_hsb2, equation_class(actual_hsb2),
               label = "Unstructured VCV, HSB 2")
  
  hsb3 <- lmer(math ~ female * ses + minority + (ses * female|sch.id),
               hsb)
  tex_hsb3 <- extract_eq(hsb3)
  actual_hsb3 <- "\\begin{aligned}\n  \\operatorname{math}  &\\sim N \\left(\\mu, \\sigma^2 \\right) \\\\\n    \\mu &=\\alpha_{j[i]} + \\beta_{1j[i]}(\\operatorname{female}) + \\beta_{2j[i]}(\\operatorname{ses}) + \\beta_{3}(\\operatorname{minority}) + \\beta_{4j[i]}(\\operatorname{female} \\times \\operatorname{ses}) \\\\    \n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\alpha_{j} \\\\\n      &\\beta_{1j} \\\\\n      &\\beta_{2j} \\\\\n      &\\beta_{4j}\n    \\end{aligned}\n  \\end{array}\n\\right)\n  &\\sim N \\left(\n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\mu_{\\alpha_{j}} \\\\\n      &\\mu_{\\beta_{1j}} \\\\\n      &\\mu_{\\beta_{2j}} \\\\\n      &\\mu_{\\beta_{4j}}\n    \\end{aligned}\n  \\end{array}\n\\right)\n, \n\\left(\n  \\begin{array}{cccc}\n     \\sigma^2_{\\alpha_{j}} & \\rho\\alpha_{j}\\beta_{1j} & \\rho\\alpha_{j}\\beta_{2j} & \\rho\\alpha_{j}\\beta_{4j} \\\\ \n     \\rho\\beta_{1j}\\alpha_{j} & \\sigma^2_{\\beta_{1j}} & \\rho\\beta_{1j}\\beta_{2j} & \\rho\\beta_{1j}\\beta_{4j} \\\\ \n     \\rho\\beta_{2j}\\alpha_{j} & \\rho\\beta_{2j}\\beta_{1j} & \\sigma^2_{\\beta_{2j}} & \\rho\\beta_{2j}\\beta_{4j} \\\\ \n     \\rho\\beta_{4j}\\alpha_{j} & \\rho\\beta_{4j}\\beta_{1j} & \\rho\\beta_{4j}\\beta_{2j} & \\sigma^2_{\\beta_{4j}}\n  \\end{array}\n\\right)\n \\right)\n    \\text{, for sch.id j = 1,} \\dots \\text{,J}\n\\end{aligned}"
  expect_equal(tex_hsb3, equation_class(actual_hsb3),
               label = "Unstructured VCV, HSB 3")
  
  expect_warning(
    hsb4 <- lmer(math ~ female * ses + minority + 
                 (ses * female + minority|sch.id),
                 hsb)
  )
  tex_hsb4 <- extract_eq(hsb4)
  actual_hsb4 <- "\\begin{aligned}\n  \\operatorname{math}  &\\sim N \\left(\\mu, \\sigma^2 \\right) \\\\\n    \\mu &=\\alpha_{j[i]} + \\beta_{1j[i]}(\\operatorname{female}) + \\beta_{2j[i]}(\\operatorname{ses}) + \\beta_{3j[i]}(\\operatorname{minority}) + \\beta_{4j[i]}(\\operatorname{female} \\times \\operatorname{ses}) \\\\    \n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\alpha_{j} \\\\\n      &\\beta_{1j} \\\\\n      &\\beta_{2j} \\\\\n      &\\beta_{3j} \\\\\n      &\\beta_{4j}\n    \\end{aligned}\n  \\end{array}\n\\right)\n  &\\sim N \\left(\n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\mu_{\\alpha_{j}} \\\\\n      &\\mu_{\\beta_{1j}} \\\\\n      &\\mu_{\\beta_{2j}} \\\\\n      &\\mu_{\\beta_{3j}} \\\\\n      &\\mu_{\\beta_{4j}}\n    \\end{aligned}\n  \\end{array}\n\\right)\n, \n\\left(\n  \\begin{array}{ccccc}\n     \\sigma^2_{\\alpha_{j}} & \\rho\\alpha_{j}\\beta_{1j} & \\rho\\alpha_{j}\\beta_{2j} & \\rho\\alpha_{j}\\beta_{3j} & \\rho\\alpha_{j}\\beta_{4j} \\\\ \n     \\rho\\beta_{1j}\\alpha_{j} & \\sigma^2_{\\beta_{1j}} & \\rho\\beta_{1j}\\beta_{2j} & \\rho\\beta_{1j}\\beta_{3j} & \\rho\\beta_{1j}\\beta_{4j} \\\\ \n     \\rho\\beta_{2j}\\alpha_{j} & \\rho\\beta_{2j}\\beta_{1j} & \\sigma^2_{\\beta_{2j}} & \\rho\\beta_{2j}\\beta_{3j} & \\rho\\beta_{2j}\\beta_{4j} \\\\ \n     \\rho\\beta_{3j}\\alpha_{j} & \\rho\\beta_{3j}\\beta_{1j} & \\rho\\beta_{3j}\\beta_{2j} & \\sigma^2_{\\beta_{3j}} & \\rho\\beta_{3j}\\beta_{4j} \\\\ \n     \\rho\\beta_{4j}\\alpha_{j} & \\rho\\beta_{4j}\\beta_{1j} & \\rho\\beta_{4j}\\beta_{2j} & \\rho\\beta_{4j}\\beta_{3j} & \\sigma^2_{\\beta_{4j}}\n  \\end{array}\n\\right)\n \\right)\n    \\text{, for sch.id j = 1,} \\dots \\text{,J}\n\\end{aligned}"
  expect_equal(tex_hsb4, equation_class(actual_hsb4),
               label = "Unstructured VCV, HSB 4")
  
  # four-level model
  long1 <- lmer(score ~ wave + 
                  (wave|sid) + (wave|school) + (wave|district),
             sim_longitudinal)
  tex_long1 <- extract_eq(long1)
  actual_long1 <- "\\begin{aligned}\n  \\operatorname{score}  &\\sim N \\left(\\alpha_{j[i],k[i],l[i]} + \\beta_{1j[i],k[i],l[i]}(\\operatorname{wave}), \\sigma^2 \\right) \\\\    \n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\alpha_{j} \\\\\n      &\\beta_{1j}\n    \\end{aligned}\n  \\end{array}\n\\right)\n  &\\sim N \\left(\n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\mu_{\\alpha_{j}} \\\\\n      &\\mu_{\\beta_{1j}}\n    \\end{aligned}\n  \\end{array}\n\\right)\n, \n\\left(\n  \\begin{array}{cc}\n     \\sigma^2_{\\alpha_{j}} & \\rho\\alpha_{j}\\beta_{1j} \\\\ \n     \\rho\\beta_{1j}\\alpha_{j} & \\sigma^2_{\\beta_{1j}}\n  \\end{array}\n\\right)\n \\right)\n    \\text{, for sid j = 1,} \\dots \\text{,J} \\\\    \n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\alpha_{k} \\\\\n      &\\beta_{1k}\n    \\end{aligned}\n  \\end{array}\n\\right)\n  &\\sim N \\left(\n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\mu_{\\alpha_{k}} \\\\\n      &\\mu_{\\beta_{1k}}\n    \\end{aligned}\n  \\end{array}\n\\right)\n, \n\\left(\n  \\begin{array}{cc}\n     \\sigma^2_{\\alpha_{k}} & \\rho\\alpha_{k}\\beta_{1k} \\\\ \n     \\rho\\beta_{1k}\\alpha_{k} & \\sigma^2_{\\beta_{1k}}\n  \\end{array}\n\\right)\n \\right)\n    \\text{, for school k = 1,} \\dots \\text{,K} \\\\    \n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\alpha_{l} \\\\\n      &\\beta_{1l}\n    \\end{aligned}\n  \\end{array}\n\\right)\n  &\\sim N \\left(\n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\mu_{\\alpha_{l}} \\\\\n      &\\mu_{\\beta_{1l}}\n    \\end{aligned}\n  \\end{array}\n\\right)\n, \n\\left(\n  \\begin{array}{cc}\n     \\sigma^2_{\\alpha_{l}} & \\rho\\alpha_{l}\\beta_{1l} \\\\ \n     \\rho\\beta_{1l}\\alpha_{l} & \\sigma^2_{\\beta_{1l}}\n  \\end{array}\n\\right)\n \\right)\n    \\text{, for district l = 1,} \\dots \\text{,L}\n\\end{aligned}"
  expect_equal(tex_long1, equation_class(actual_long1),
               label = "Unstructured VCV, Longitudinal 1")
})

test_that("Group-level predictors work as expected", {
  # level 2 variables
  expect_warning(
    long2 <- lmer(score ~ wave + group + treatment +
                    (wave|sid) + (wave + group + treatment|school) +
                    (wave + treatment|district),
                  sim_longitudinal)
  )
  tex_long2 <- extract_eq(long2)
  actual_long2 <- "\\begin{aligned}\n  \\operatorname{score}  &\\sim N \\left(\\alpha_{j[i],k[i],l[i]} + \\beta_{1j[i],k[i],l[i]}(\\operatorname{wave}), \\sigma^2 \\right) \\\\    \n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\alpha_{j} \\\\\n      &\\beta_{1j}\n    \\end{aligned}\n  \\end{array}\n\\right)\n  &\\sim N \\left(\n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\gamma_{0}^{\\alpha} + \\gamma_{1k[i]}^{\\alpha}(\\operatorname{group}_{\\operatorname{low}}) + \\gamma_{2k[i]}^{\\alpha}(\\operatorname{group}_{\\operatorname{medium}}) + \\gamma_{3k[i],l[i]}^{\\alpha}(\\operatorname{treatment}_{\\operatorname{1}}) \\\\\n      &\\mu_{\\beta_{1j}}\n    \\end{aligned}\n  \\end{array}\n\\right)\n, \n\\left(\n  \\begin{array}{cc}\n     \\sigma^2_{\\alpha_{j}} & \\rho\\alpha_{j}\\beta_{1j} \\\\ \n     \\rho\\beta_{1j}\\alpha_{j} & \\sigma^2_{\\beta_{1j}}\n  \\end{array}\n\\right)\n \\right)\n    \\text{, for sid j = 1,} \\dots \\text{,J} \\\\    \n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\alpha_{k} \\\\\n      &\\beta_{1k} \\\\\n      &\\gamma_{1k} \\\\\n      &\\gamma_{2k} \\\\\n      &\\gamma_{3k}\n    \\end{aligned}\n  \\end{array}\n\\right)\n  &\\sim N \\left(\n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\mu_{\\alpha_{k}} \\\\\n      &\\mu_{\\beta_{1k}} \\\\\n      &\\mu_{\\gamma_{1k}} \\\\\n      &\\mu_{\\gamma_{2k}} \\\\\n      &\\mu_{\\gamma_{3k}}\n    \\end{aligned}\n  \\end{array}\n\\right)\n, \n\\left(\n  \\begin{array}{ccccc}\n     \\sigma^2_{\\alpha_{k}} & \\rho\\alpha_{k}\\beta_{1k} & \\rho\\alpha_{k}\\gamma_{1k} & \\rho\\alpha_{k}\\gamma_{2k} & \\rho\\alpha_{k}\\gamma_{3k} \\\\ \n     \\rho\\beta_{1k}\\alpha_{k} & \\sigma^2_{\\beta_{1k}} & \\rho\\beta_{1k}\\gamma_{1k} & \\rho\\beta_{1k}\\gamma_{2k} & \\rho\\beta_{1k}\\gamma_{3k} \\\\ \n     \\rho\\gamma_{1k}\\alpha_{k} & \\rho\\gamma_{1k}\\beta_{1k} & \\sigma^2_{\\gamma_{1k}} & \\rho\\gamma_{1k}\\gamma_{2k} & \\rho\\gamma_{1k}\\gamma_{3k} \\\\ \n     \\rho\\gamma_{2k}\\alpha_{k} & \\rho\\gamma_{2k}\\beta_{1k} & \\rho\\gamma_{2k}\\gamma_{1k} & \\sigma^2_{\\gamma_{2k}} & \\rho\\gamma_{2k}\\gamma_{3k} \\\\ \n     \\rho\\gamma_{3k}\\alpha_{k} & \\rho\\gamma_{3k}\\beta_{1k} & \\rho\\gamma_{3k}\\gamma_{1k} & \\rho\\gamma_{3k}\\gamma_{2k} & \\sigma^2_{\\gamma_{3k}}\n  \\end{array}\n\\right)\n \\right)\n    \\text{, for school k = 1,} \\dots \\text{,K} \\\\    \n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\alpha_{l} \\\\\n      &\\beta_{1l} \\\\\n      &\\gamma_{3l}\n    \\end{aligned}\n  \\end{array}\n\\right)\n  &\\sim N \\left(\n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\mu_{\\alpha_{l}} \\\\\n      &\\mu_{\\beta_{1l}} \\\\\n      &\\mu_{\\gamma_{3l}}\n    \\end{aligned}\n  \\end{array}\n\\right)\n, \n\\left(\n  \\begin{array}{ccc}\n     \\sigma^2_{\\alpha_{l}} & \\rho\\alpha_{l}\\beta_{1l} & \\rho\\alpha_{l}\\gamma_{3l} \\\\ \n     \\rho\\beta_{1l}\\alpha_{l} & \\sigma^2_{\\beta_{1l}} & \\rho\\beta_{1l}\\gamma_{3l} \\\\ \n     \\rho\\gamma_{3l}\\alpha_{l} & \\rho\\gamma_{3l}\\beta_{1l} & \\sigma^2_{\\gamma_{3l}}\n  \\end{array}\n\\right)\n \\right)\n    \\text{, for district l = 1,} \\dots \\text{,L}\n\\end{aligned}"
  expect_equal(tex_long2, equation_class(actual_long2),
               label = "Group-level predictors, Longitudinal (level 2)")
  
  # level 3 variable
  long3 <- lmer(score ~ wave + group + treatment + prop_low +
                  (wave|sid) + (wave + group + treatment|school) +
                  (wave + treatment + prop_low|district),
                sim_longitudinal)
  
  tex_long3 <- extract_eq(long3)
  actual_long3 <- "\\begin{aligned}\n  \\operatorname{score}  &\\sim N \\left(\\alpha_{j[i],k[i],l[i]} + \\beta_{1j[i],k[i],l[i]}(\\operatorname{wave}), \\sigma^2 \\right) \\\\    \n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\alpha_{j} \\\\\n      &\\beta_{1j}\n    \\end{aligned}\n  \\end{array}\n\\right)\n  &\\sim N \\left(\n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\gamma_{0}^{\\alpha} + \\gamma_{1k[i]}^{\\alpha}(\\operatorname{group}_{\\operatorname{low}}) + \\gamma_{2k[i]}^{\\alpha}(\\operatorname{group}_{\\operatorname{medium}}) + \\gamma_{3k[i],l[i]}^{\\alpha}(\\operatorname{treatment}_{\\operatorname{1}}) \\\\\n      &\\mu_{\\beta_{1j}}\n    \\end{aligned}\n  \\end{array}\n\\right)\n, \n\\left(\n  \\begin{array}{cc}\n     \\sigma^2_{\\alpha_{j}} & \\rho\\alpha_{j}\\beta_{1j} \\\\ \n     \\rho\\beta_{1j}\\alpha_{j} & \\sigma^2_{\\beta_{1j}}\n  \\end{array}\n\\right)\n \\right)\n    \\text{, for sid j = 1,} \\dots \\text{,J} \\\\    \n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\alpha_{k} \\\\\n      &\\beta_{1k} \\\\\n      &\\gamma_{1k} \\\\\n      &\\gamma_{2k} \\\\\n      &\\gamma_{3k}\n    \\end{aligned}\n  \\end{array}\n\\right)\n  &\\sim N \\left(\n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\gamma_{0}^{\\alpha} + \\gamma_{1l[i]}^{\\alpha}(\\operatorname{prop\\_low}) \\\\\n      &\\mu_{\\beta_{1k}} \\\\\n      &\\mu_{\\gamma_{1k}} \\\\\n      &\\mu_{\\gamma_{2k}} \\\\\n      &\\mu_{\\gamma_{3k}}\n    \\end{aligned}\n  \\end{array}\n\\right)\n, \n\\left(\n  \\begin{array}{ccccc}\n     \\sigma^2_{\\alpha_{k}} & \\rho\\alpha_{k}\\beta_{1k} & \\rho\\alpha_{k}\\gamma_{1k} & \\rho\\alpha_{k}\\gamma_{2k} & \\rho\\alpha_{k}\\gamma_{3k} \\\\ \n     \\rho\\beta_{1k}\\alpha_{k} & \\sigma^2_{\\beta_{1k}} & \\rho\\beta_{1k}\\gamma_{1k} & \\rho\\beta_{1k}\\gamma_{2k} & \\rho\\beta_{1k}\\gamma_{3k} \\\\ \n     \\rho\\gamma_{1k}\\alpha_{k} & \\rho\\gamma_{1k}\\beta_{1k} & \\sigma^2_{\\gamma_{1k}} & \\rho\\gamma_{1k}\\gamma_{2k} & \\rho\\gamma_{1k}\\gamma_{3k} \\\\ \n     \\rho\\gamma_{2k}\\alpha_{k} & \\rho\\gamma_{2k}\\beta_{1k} & \\rho\\gamma_{2k}\\gamma_{1k} & \\sigma^2_{\\gamma_{2k}} & \\rho\\gamma_{2k}\\gamma_{3k} \\\\ \n     \\rho\\gamma_{3k}\\alpha_{k} & \\rho\\gamma_{3k}\\beta_{1k} & \\rho\\gamma_{3k}\\gamma_{1k} & \\rho\\gamma_{3k}\\gamma_{2k} & \\sigma^2_{\\gamma_{3k}}\n  \\end{array}\n\\right)\n \\right)\n    \\text{, for school k = 1,} \\dots \\text{,K} \\\\    \n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\alpha_{l} \\\\\n      &\\beta_{1l} \\\\\n      &\\gamma_{3l} \\\\\n      &\\gamma_{1l}\n    \\end{aligned}\n  \\end{array}\n\\right)\n  &\\sim N \\left(\n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\mu_{\\alpha_{l}} \\\\\n      &\\mu_{\\beta_{1l}} \\\\\n      &\\mu_{\\gamma_{3l}} \\\\\n      &\\mu_{\\gamma_{1l}}\n    \\end{aligned}\n  \\end{array}\n\\right)\n, \n\\left(\n  \\begin{array}{cccc}\n     \\sigma^2_{\\alpha_{l}} & \\rho\\alpha_{l}\\beta_{1l} & \\rho\\alpha_{l}\\gamma_{3l} & \\rho\\alpha_{l}\\gamma_{1l} \\\\ \n     \\rho\\beta_{1l}\\alpha_{l} & \\sigma^2_{\\beta_{1l}} & \\rho\\beta_{1l}\\gamma_{3l} & \\rho\\beta_{1l}\\gamma_{1l} \\\\ \n     \\rho\\gamma_{3l}\\alpha_{l} & \\rho\\gamma_{3l}\\beta_{1l} & \\sigma^2_{\\gamma_{3l}} & \\rho\\gamma_{3l}\\gamma_{1l} \\\\ \n     \\rho\\gamma_{1l}\\alpha_{l} & \\rho\\gamma_{1l}\\beta_{1l} & \\rho\\gamma_{1l}\\gamma_{3l} & \\sigma^2_{\\gamma_{1l}}\n  \\end{array}\n\\right)\n \\right)\n    \\text{, for district l = 1,} \\dots \\text{,L}\n\\end{aligned}"
  expect_equal(tex_long3, equation_class(actual_long3),
               label = "Group-level predictors, Longitudinal (level 3)")
  
  # level 4 variable
  dist_mean <- tapply(sim_longitudinal$score,
                      sim_longitudinal$district,
                      mean)
  dist_mean <- data.frame(district = names(dist_mean),
                          dist_mean = dist_mean)
  sim_longitudinal <- merge(sim_longitudinal, dist_mean, by = "district")
  
  long4 <- lmer(score ~ wave + group + treatment + prop_low + dist_mean +
                  (wave|sid) + (wave + treatment|school) +
                  (wave|district),
                sim_longitudinal)
  tex_long4 <- extract_eq(long4)
  actual_long4 <- "\\begin{aligned}\n  \\operatorname{score}  &\\sim N \\left(\\alpha_{j[i],k[i],l[i]} + \\beta_{1j[i],k[i],l[i]}(\\operatorname{wave}), \\sigma^2 \\right) \\\\    \n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\alpha_{j} \\\\\n      &\\beta_{1j}\n    \\end{aligned}\n  \\end{array}\n\\right)\n  &\\sim N \\left(\n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\gamma_{0}^{\\alpha} + \\gamma_{1}^{\\alpha}(\\operatorname{group}_{\\operatorname{low}}) + \\gamma_{2}^{\\alpha}(\\operatorname{group}_{\\operatorname{medium}}) + \\gamma_{3k[i]}^{\\alpha}(\\operatorname{treatment}_{\\operatorname{1}}) \\\\\n      &\\mu_{\\beta_{1j}}\n    \\end{aligned}\n  \\end{array}\n\\right)\n, \n\\left(\n  \\begin{array}{cc}\n     \\sigma^2_{\\alpha_{j}} & \\rho\\alpha_{j}\\beta_{1j} \\\\ \n     \\rho\\beta_{1j}\\alpha_{j} & \\sigma^2_{\\beta_{1j}}\n  \\end{array}\n\\right)\n \\right)\n    \\text{, for sid j = 1,} \\dots \\text{,J} \\\\    \n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\alpha_{k} \\\\\n      &\\beta_{1k} \\\\\n      &\\gamma_{3k}\n    \\end{aligned}\n  \\end{array}\n\\right)\n  &\\sim N \\left(\n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\gamma_{0}^{\\alpha} + \\gamma_{1}^{\\alpha}(\\operatorname{prop\\_low}) \\\\\n      &\\mu_{\\beta_{1k}} \\\\\n      &\\mu_{\\gamma_{3k}}\n    \\end{aligned}\n  \\end{array}\n\\right)\n, \n\\left(\n  \\begin{array}{ccc}\n     \\sigma^2_{\\alpha_{k}} & \\rho\\alpha_{k}\\beta_{1k} & \\rho\\alpha_{k}\\gamma_{3k} \\\\ \n     \\rho\\beta_{1k}\\alpha_{k} & \\sigma^2_{\\beta_{1k}} & \\rho\\beta_{1k}\\gamma_{3k} \\\\ \n     \\rho\\gamma_{3k}\\alpha_{k} & \\rho\\gamma_{3k}\\beta_{1k} & \\sigma^2_{\\gamma_{3k}}\n  \\end{array}\n\\right)\n \\right)\n    \\text{, for school k = 1,} \\dots \\text{,K} \\\\    \n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\alpha_{l} \\\\\n      &\\beta_{1l}\n    \\end{aligned}\n  \\end{array}\n\\right)\n  &\\sim N \\left(\n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\gamma_{0}^{\\alpha} + \\gamma_{1}^{\\alpha}(\\operatorname{dist\\_mean}) \\\\\n      &\\mu_{\\beta_{1l}}\n    \\end{aligned}\n  \\end{array}\n\\right)\n, \n\\left(\n  \\begin{array}{cc}\n     \\sigma^2_{\\alpha_{l}} & \\rho\\alpha_{l}\\beta_{1l} \\\\ \n     \\rho\\beta_{1l}\\alpha_{l} & \\sigma^2_{\\beta_{1l}}\n  \\end{array}\n\\right)\n \\right)\n    \\text{, for district l = 1,} \\dots \\text{,L}\n\\end{aligned}"
  expect_equal(tex_long4, equation_class(actual_long4),
               label = "Group-level predictors, Longitudinal (level 4)")
})
data("sim_longitudinal", package = "equatiomatic")

test_that("Interactions work as expected", {
  # l1 interaction
  # l2 interaction
  # cross-level interaction w/random at the level
  # cross-level interaction w/o random at the level
  
  # long3 <- lmer(score ~ wave*group*treatment +
  #                 (wave|sid) + (wave + group*treatment|school) + 
  #                 (wave + treatment|district),
  #               sim_longitudinal)
  # tex_long3 <- extract_eq(long3)
})

