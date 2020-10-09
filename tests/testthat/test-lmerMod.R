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
  hsb1 <- lmer(math ~ female + ses + minority + (minority|sch.id),
               hsb)
  tex_hsb1 <- extract_eq(hsb1)
  actual_hsb1 <- "\\begin{aligned}\n  \\operatorname{math}  &\\sim N \\left(\\mu, \\sigma^2 \\right) \\\\\n    \\mu &=\\alpha_{j[i]} + \\beta_{1}(\\operatorname{female}) + \\beta_{2}(\\operatorname{ses}) + \\beta_{3j[i]}(\\operatorname{minority}) \\\\    \n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\alpha_{j} \\\\\n      &\\beta_{3j}\n    \\end{aligned}\n  \\end{array}\n\\right)\n  &\\sim N \\left(\n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\mu_{\\alpha_{j}} \\\\\n      &\\mu_{\\beta_{3j}}\n    \\end{aligned}\n  \\end{array}\n\\right)\n, \n\\left(\n  \\begin{array}{cc}\n     \\sigma^2_{\\alpha_{j}} & \\rho\\alpha_{j}\\beta_{3j} \\\\ \n     \\rho\\beta_{3j}\\alpha_{j} & \\sigma^2_{\\beta_{3j}}\n  \\end{array}\n\\right)\n \\right)\n    \\text{, for sch.id j = 1,} \\dots \\text{,J}\n\\end{aligned}"
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
  l1_hsb_int <- lmer(math ~ minority*female + (1|sch.id),
                     data = hsb)
  tex_l1_hsb_int <- extract_eq(l1_hsb_int)
  actual_l1_hsb_int <- "\\begin{aligned}\n  \\operatorname{math}  &\\sim N \\left(\\mu, \\sigma^2 \\right) \\\\\n    \\mu &=\\alpha_{j[i]} + \\beta_{1}(\\operatorname{minority}) + \\beta_{2}(\\operatorname{female}) + \\beta_{3}(\\operatorname{female} \\times \\operatorname{minority}) \\\\\n    \\alpha_{j}  &\\sim N \\left(\\mu_{\\alpha_{j}}, \\sigma^2_{\\alpha_{j}} \\right)\n    \\text{, for sch.id j = 1,} \\dots \\text{,J}\n\\end{aligned}"
  expect_equal(tex_l1_hsb_int, equation_class(actual_l1_hsb_int),
               label = "Level 1 interaction")
  
  # l2 interaction
  l2_long_int <- lmer(score ~ treatment*group + (1|sid) + (treatment|school) + 
                        (treatment*group|district),
                      data = sim_longitudinal)
  tex_l2_long_int <- extract_eq(l2_long_int)
  actual_l2_long_int <- "\\begin{aligned}\n  \\operatorname{score}  &\\sim N \\left(\\alpha_{j[i],k[i],l[i]}, \\sigma^2 \\right) \\\\\n    \\alpha_{j}  &\\sim N \\left(\\gamma_{0}^{\\alpha} + \\gamma_{1k[i],l[i]}^{\\alpha}(\\operatorname{treatment}_{\\operatorname{1}}) + \\gamma_{2l[i]}^{\\alpha}(\\operatorname{group}_{\\operatorname{low}}) + \\gamma_{3l[i]}^{\\alpha}(\\operatorname{group}_{\\operatorname{medium}}) + \\gamma_{4l[i]}^{\\alpha}(\\operatorname{group}_{\\operatorname{low}} \\times \\operatorname{treatment}_{\\operatorname{1}}) + \\gamma_{5l[i]}^{\\alpha}(\\operatorname{group}_{\\operatorname{medium}} \\times \\operatorname{treatment}_{\\operatorname{1}}), \\sigma^2_{\\alpha_{j}} \\right)\n    \\text{, for sid j = 1,} \\dots \\text{,J} \\\\\n    \n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\alpha_{k} \\\\\n      &\\gamma_{1k}\n    \\end{aligned}\n  \\end{array}\n\\right)\n  &\\sim N \\left(\n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\mu_{\\alpha_{k}} \\\\\n      &\\mu_{\\gamma_{1k}}\n    \\end{aligned}\n  \\end{array}\n\\right)\n, \n\\left(\n  \\begin{array}{cc}\n     \\sigma^2_{\\alpha_{k}} & \\rho\\alpha_{k}\\gamma_{1k} \\\\ \n     \\rho\\gamma_{1k}\\alpha_{k} & \\sigma^2_{\\gamma_{1k}}\n  \\end{array}\n\\right)\n \\right)\n    \\text{, for school k = 1,} \\dots \\text{,K} \\\\\n    \n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\alpha_{l} \\\\\n      &\\gamma_{1l} \\\\\n      &\\gamma_{2l} \\\\\n      &\\gamma_{3l} \\\\\n      &\\gamma_{4l} \\\\\n      &\\gamma_{5l}\n    \\end{aligned}\n  \\end{array}\n\\right)\n  &\\sim N \\left(\n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\mu_{\\alpha_{l}} \\\\\n      &\\mu_{\\gamma_{1l}} \\\\\n      &\\mu_{\\gamma_{2l}} \\\\\n      &\\mu_{\\gamma_{3l}} \\\\\n      &\\mu_{\\gamma_{4l}} \\\\\n      &\\mu_{\\gamma_{5l}}\n    \\end{aligned}\n  \\end{array}\n\\right)\n, \n\\left(\n  \\begin{array}{cccccc}\n     \\sigma^2_{\\alpha_{l}} & \\rho\\alpha_{l}\\gamma_{1l} & \\rho\\alpha_{l}\\gamma_{2l} & \\rho\\alpha_{l}\\gamma_{3l} & \\rho\\alpha_{l}\\gamma_{4l} & \\rho\\alpha_{l}\\gamma_{5l} \\\\ \n     \\rho\\gamma_{1l}\\alpha_{l} & \\sigma^2_{\\gamma_{1l}} & \\rho\\gamma_{1l}\\gamma_{2l} & \\rho\\gamma_{1l}\\gamma_{3l} & \\rho\\gamma_{1l}\\gamma_{4l} & \\rho\\gamma_{1l}\\gamma_{5l} \\\\ \n     \\rho\\gamma_{2l}\\alpha_{l} & \\rho\\gamma_{2l}\\gamma_{1l} & \\sigma^2_{\\gamma_{2l}} & \\rho\\gamma_{2l}\\gamma_{3l} & \\rho\\gamma_{2l}\\gamma_{4l} & \\rho\\gamma_{2l}\\gamma_{5l} \\\\ \n     \\rho\\gamma_{3l}\\alpha_{l} & \\rho\\gamma_{3l}\\gamma_{1l} & \\rho\\gamma_{3l}\\gamma_{2l} & \\sigma^2_{\\gamma_{3l}} & \\rho\\gamma_{3l}\\gamma_{4l} & \\rho\\gamma_{3l}\\gamma_{5l} \\\\ \n     \\rho\\gamma_{4l}\\alpha_{l} & \\rho\\gamma_{4l}\\gamma_{1l} & \\rho\\gamma_{4l}\\gamma_{2l} & \\rho\\gamma_{4l}\\gamma_{3l} & \\sigma^2_{\\gamma_{4l}} & \\rho\\gamma_{4l}\\gamma_{5l} \\\\ \n     \\rho\\gamma_{5l}\\alpha_{l} & \\rho\\gamma_{5l}\\gamma_{1l} & \\rho\\gamma_{5l}\\gamma_{2l} & \\rho\\gamma_{5l}\\gamma_{3l} & \\rho\\gamma_{5l}\\gamma_{4l} & \\sigma^2_{\\gamma_{5l}}\n  \\end{array}\n\\right)\n \\right)\n    \\text{, for district l = 1,} \\dots \\text{,L}\n\\end{aligned}"
  expect_equal(tex_l2_long_int, equation_class(actual_l2_long_int),
               label = "Level 2 interaction")
  
  # cross-level interaction w/random at the level
  cl_long1 <- lmer(score ~ treatment*wave + (wave|sid) + (1|school) + 
                        (1|district),
                      data = sim_longitudinal)
  tex_cl_long1 <- extract_eq(cl_long1)
  actual_cl_long1 <- "\\begin{aligned}\n  \\operatorname{score}  &\\sim N \\left(\\alpha_{j[i],k[i],l[i]} + \\beta_{0j[i]}(\\operatorname{wave}), \\sigma^2 \\right) \\\\    \n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\alpha_{j} \\\\\n      &\\beta_{0j}\n    \\end{aligned}\n  \\end{array}\n\\right)\n  &\\sim N \\left(\n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\gamma_{0}^{\\alpha} + \\gamma_{1}^{\\alpha}(\\operatorname{treatment}_{\\operatorname{1}}) \\\\\n      &\\gamma^{\\beta_{0}}_{0} + \\gamma^{\\beta_{0}}_{1}(\\operatorname{treatment}_{\\operatorname{1}})\n    \\end{aligned}\n  \\end{array}\n\\right)\n, \n\\left(\n  \\begin{array}{cc}\n     \\sigma^2_{\\alpha_{j}} & \\rho\\alpha_{j}\\beta_{0j} \\\\ \n     \\rho\\beta_{0j}\\alpha_{j} & \\sigma^2_{\\beta_{0j}}\n  \\end{array}\n\\right)\n \\right)\n    \\text{, for sid j = 1,} \\dots \\text{,J} \\\\    \\alpha_{k}  &\\sim N \\left(\\mu_{\\alpha_{k}}, \\sigma^2_{\\alpha_{k}} \\right)\n    \\text{, for school k = 1,} \\dots \\text{,K} \\\\    \\alpha_{l}  &\\sim N \\left(\\mu_{\\alpha_{l}}, \\sigma^2_{\\alpha_{l}} \\right)\n    \\text{, for district l = 1,} \\dots \\text{,L}\n\\end{aligned}"
  expect_equal(tex_cl_long1, equation_class(actual_cl_long1),
               label = "Cross-level interaction (random at that level)")
  
  # cross-level interaction w/o random at the level
  cl_long2 <- lmer(score ~ treatment*wave + (1|sid) + (1|school) + 
                      (1|district),
                    data = sim_longitudinal)
  tex_cl_long2 <- extract_eq(cl_long2)
  actual_cl_long2 <- "\\begin{aligned}\n  \\operatorname{score}  &\\sim N \\left(\\alpha_{j[i],k[i],l[i]} + \\beta_{0}(\\operatorname{wave}), \\sigma^2 \\right) \\\\\n    \\alpha_{j}  &\\sim N \\left(\\gamma_{0}^{\\alpha} + \\gamma_{1}^{\\alpha}(\\operatorname{treatment}_{\\operatorname{1}}) + \\gamma_{2}^{\\alpha}(\\operatorname{treatment}_{\\operatorname{1}} \\times \\operatorname{wave}), \\sigma^2_{\\alpha_{j}} \\right)\n    \\text{, for sid j = 1,} \\dots \\text{,J} \\\\\n    \\alpha_{k}  &\\sim N \\left(\\mu_{\\alpha_{k}}, \\sigma^2_{\\alpha_{k}} \\right)\n    \\text{, for school k = 1,} \\dots \\text{,K} \\\\\n    \\alpha_{l}  &\\sim N \\left(\\mu_{\\alpha_{l}}, \\sigma^2_{\\alpha_{l}} \\right)\n    \\text{, for district l = 1,} \\dots \\text{,L}\n\\end{aligned}"
  expect_equal(tex_cl_long2, equation_class(actual_cl_long2),
               label = "Cross-level interaction (no random at that level)")
  
  # Multiple cross-level interactions
  cl_long3 <- lmer(score ~ wave*group*treatment + prop_low*treatment*wave +
                  (wave|sid) + (wave|school) +
                  (wave + treatment|district),
                sim_longitudinal)
  tex_cl_long3 <- extract_eq(cl_long3)
  actual_cl_long3 <- "\\begin{aligned}\n  \\operatorname{score}  &\\sim N \\left(\\alpha_{j[i],k[i],l[i]} + \\beta_{1j[i],k[i],l[i]}(\\operatorname{wave}), \\sigma^2 \\right) \\\\    \n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\alpha_{j} \\\\\n      &\\beta_{1j}\n    \\end{aligned}\n  \\end{array}\n\\right)\n  &\\sim N \\left(\n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\gamma_{0}^{\\alpha} + \\gamma_{1}^{\\alpha}(\\operatorname{group}_{\\operatorname{low}}) + \\gamma_{2}^{\\alpha}(\\operatorname{group}_{\\operatorname{medium}}) + \\gamma_{3l[i]}^{\\alpha}(\\operatorname{treatment}_{\\operatorname{1}}) + \\gamma_{4}^{\\alpha}(\\operatorname{group}_{\\operatorname{low}} \\times \\operatorname{treatment}_{\\operatorname{1}}) + \\gamma_{5}^{\\alpha}(\\operatorname{group}_{\\operatorname{medium}} \\times \\operatorname{treatment}_{\\operatorname{1}}) \\\\\n      &\\gamma^{\\beta_{1}}_{0} + \\gamma^{\\beta_{1}}_{1}(\\operatorname{group}_{\\operatorname{low}}) + \\gamma^{\\beta_{1}}_{2}(\\operatorname{group}_{\\operatorname{medium}}) + \\gamma^{\\beta_{1}}_{3}(\\operatorname{treatment}_{\\operatorname{1}}) + \\gamma^{\\beta_{1}}_{4}(\\operatorname{group}_{\\operatorname{low}} \\times \\operatorname{treatment}_{\\operatorname{1}}) + \\gamma^{\\beta_{1}}_{5}(\\operatorname{group}_{\\operatorname{medium}} \\times \\operatorname{treatment}_{\\operatorname{1}})\n    \\end{aligned}\n  \\end{array}\n\\right)\n, \n\\left(\n  \\begin{array}{cc}\n     \\sigma^2_{\\alpha_{j}} & \\rho\\alpha_{j}\\beta_{1j} \\\\ \n     \\rho\\beta_{1j}\\alpha_{j} & \\sigma^2_{\\beta_{1j}}\n  \\end{array}\n\\right)\n \\right)\n    \\text{, for sid j = 1,} \\dots \\text{,J} \\\\    \n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\alpha_{k} \\\\\n      &\\beta_{1k}\n    \\end{aligned}\n  \\end{array}\n\\right)\n  &\\sim N \\left(\n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\gamma_{0}^{\\alpha} + \\gamma_{1}^{\\alpha}(\\operatorname{prop\\_low}) + \\gamma_{2}^{\\alpha}(\\operatorname{prop\\_low} \\times \\operatorname{treatment}_{\\operatorname{1}}) \\\\\n      &\\gamma^{\\beta_{1}}_{0} + \\gamma^{\\beta_{1}}_{2}(\\operatorname{prop\\_low}) + \\gamma^{\\beta_{1}}_{1}(\\operatorname{prop\\_low} \\times \\operatorname{treatment}_{\\operatorname{1}})\n    \\end{aligned}\n  \\end{array}\n\\right)\n, \n\\left(\n  \\begin{array}{cc}\n     \\sigma^2_{\\alpha_{k}} & \\rho\\alpha_{k}\\beta_{1k} \\\\ \n     \\rho\\beta_{1k}\\alpha_{k} & \\sigma^2_{\\beta_{1k}}\n  \\end{array}\n\\right)\n \\right)\n    \\text{, for school k = 1,} \\dots \\text{,K} \\\\    \n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\alpha_{l} \\\\\n      &\\beta_{1l} \\\\\n      &\\gamma_{3l}\n    \\end{aligned}\n  \\end{array}\n\\right)\n  &\\sim N \\left(\n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\mu_{\\alpha_{l}} \\\\\n      &\\mu_{\\beta_{1l}} \\\\\n      &\\mu_{\\gamma_{3l}}\n    \\end{aligned}\n  \\end{array}\n\\right)\n, \n\\left(\n  \\begin{array}{ccc}\n     \\sigma^2_{\\alpha_{l}} & \\rho\\alpha_{l}\\beta_{1l} & \\rho\\alpha_{l}\\gamma_{3l} \\\\ \n     \\rho\\beta_{1l}\\alpha_{l} & \\sigma^2_{\\beta_{1l}} & \\rho\\beta_{1l}\\gamma_{3l} \\\\ \n     \\rho\\gamma_{3l}\\alpha_{l} & \\rho\\gamma_{3l}\\beta_{1l} & \\sigma^2_{\\gamma_{3l}}\n  \\end{array}\n\\right)\n \\right)\n    \\text{, for district l = 1,} \\dots \\text{,L}\n\\end{aligned}"
  expect_equal(tex_cl_long3, equation_class(actual_cl_long3),
               label = "Multiple cross-level interactions")
})

# Random effect structures with no covars estimated
test_that("Alternate random effect VCV structures work", {
  hsb_varsonly <- lmer(math ~ minority*female + (minority*female || sch.id),
                       data = hsb)
  tex_hsb_varsonly <- extract_eq(hsb_varsonly)
  actual_hsb_varsonly <- "\\begin{aligned}\n  \\operatorname{math}  &\\sim N \\left(\\mu, \\sigma^2 \\right) \\\\\n    \\mu &=\\alpha_{j[i]} + \\beta_{1j[i]}(\\operatorname{minority}) + \\beta_{2j[i]}(\\operatorname{female}) + \\beta_{3j[i]}(\\operatorname{female} \\times \\operatorname{minority}) \\\\    \n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\alpha_{j} \\\\\n      &\\beta_{1j} \\\\\n      &\\beta_{2j} \\\\\n      &\\beta_{3j}\n    \\end{aligned}\n  \\end{array}\n\\right)\n  &\\sim N \\left(\n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\mu_{\\alpha_{j}} \\\\\n      &\\mu_{\\beta_{1j}} \\\\\n      &\\mu_{\\beta_{2j}} \\\\\n      &\\mu_{\\beta_{3j}}\n    \\end{aligned}\n  \\end{array}\n\\right)\n, \n\\left(\n  \\begin{array}{cccc}\n     \\sigma^2_{\\alpha_{j}} & 0 & 0 & 0 \\\\ \n     0 & \\sigma^2_{\\beta_{1j}} & 0 & 0 \\\\ \n     0 & 0 & \\sigma^2_{\\beta_{2j}} & 0 \\\\ \n     0 & 0 & 0 & \\sigma^2_{\\beta_{3j}}\n  \\end{array}\n\\right)\n \\right)\n    \\text{, for sch.id j = 1,} \\dots \\text{,J}\n\\end{aligned}"
  expect_equal(tex_hsb_varsonly, equation_class(actual_hsb_varsonly),
               label = "Variance components only")
  
  expect_warning(
    hsb_doublegroup <- lmer(math ~ minority*female + 
                              (minority|sch.id) + (female|sch.id),
                         data = hsb)
  )
  tex_hsb_doublegroup <- extract_eq(hsb_doublegroup)
  actual_hsb_doublegroup <- "\\begin{aligned}\n  \\operatorname{math}  &\\sim N \\left(\\mu, \\sigma^2 \\right) \\\\\n    \\mu &=\\alpha_{j[i],k[i]} + \\beta_{1j[i]}(\\operatorname{minority}) + \\beta_{2k[i]}(\\operatorname{female}) + \\beta_{3}(\\operatorname{female} \\times \\operatorname{minority}) \\\\    \n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\alpha_{j} \\\\\n      &\\beta_{1j}\n    \\end{aligned}\n  \\end{array}\n\\right)\n  &\\sim N \\left(\n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\mu_{\\alpha_{j}} \\\\\n      &\\mu_{\\beta_{1j}}\n    \\end{aligned}\n  \\end{array}\n\\right)\n, \n\\left(\n  \\begin{array}{cc}\n     \\sigma^2_{\\alpha_{j}} & \\rho\\alpha_{j}\\beta_{1j} \\\\ \n     \\rho\\beta_{1j}\\alpha_{j} & \\sigma^2_{\\beta_{1j}}\n  \\end{array}\n\\right)\n \\right)\n    \\text{, for sch.id j = 1,} \\dots \\text{,J} \\\\    \n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\alpha_{k} \\\\\n      &\\beta_{2k}\n    \\end{aligned}\n  \\end{array}\n\\right)\n  &\\sim N \\left(\n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\mu_{\\alpha_{k}} \\\\\n      &\\mu_{\\beta_{2k}}\n    \\end{aligned}\n  \\end{array}\n\\right)\n, \n\\left(\n  \\begin{array}{cc}\n     \\sigma^2_{\\alpha_{k}} & \\rho\\alpha_{k}\\beta_{2k} \\\\ \n     \\rho\\beta_{2k}\\alpha_{k} & \\sigma^2_{\\beta_{2k}}\n  \\end{array}\n\\right)\n \\right)\n    \\text{, for sch.id.1 k = 1,} \\dots \\text{,K}\n\\end{aligned}"
  expect_equal(tex_hsb_doublegroup, equation_class(actual_hsb_doublegroup),
               label = "Double grouping (like cross-classified models)")
  
  
  long_mixed_ranef <- lmer(score ~ wave +
         (wave||sid) + (wave|school) + (1|school) + (wave||district),
         sim_longitudinal)
  tex_long_mixed_ranef <- extract_eq(long_mixed_ranef)
  actual_long_mixed_ranef <- "\\begin{aligned}\n  \\operatorname{score}  &\\sim N \\left(\\alpha_{j[i],k[i],l[i],m[i]} + \\beta_{1j[i],k[i],m[i]}(\\operatorname{wave}), \\sigma^2 \\right) \\\\    \n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\alpha_{j} \\\\\n      &\\beta_{1j}\n    \\end{aligned}\n  \\end{array}\n\\right)\n  &\\sim N \\left(\n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\mu_{\\alpha_{j}} \\\\\n      &\\mu_{\\beta_{1j}}\n    \\end{aligned}\n  \\end{array}\n\\right)\n, \n\\left(\n  \\begin{array}{cc}\n     \\sigma^2_{\\alpha_{j}} & 0 \\\\ \n     0 & \\sigma^2_{\\beta_{1j}}\n  \\end{array}\n\\right)\n \\right)\n    \\text{, for sid j = 1,} \\dots \\text{,J} \\\\    \n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\alpha_{k} \\\\\n      &\\beta_{1k}\n    \\end{aligned}\n  \\end{array}\n\\right)\n  &\\sim N \\left(\n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\mu_{\\alpha_{k}} \\\\\n      &\\mu_{\\beta_{1k}}\n    \\end{aligned}\n  \\end{array}\n\\right)\n, \n\\left(\n  \\begin{array}{cc}\n     \\sigma^2_{\\alpha_{k}} & \\rho\\alpha_{k}\\beta_{1k} \\\\ \n     \\rho\\beta_{1k}\\alpha_{k} & \\sigma^2_{\\beta_{1k}}\n  \\end{array}\n\\right)\n \\right)\n    \\text{, for school k = 1,} \\dots \\text{,K} \\\\    \\alpha_{l}  &\\sim N \\left(\\mu_{\\alpha_{l}}, \\sigma^2_{\\alpha_{l}} \\right)\n    \\text{, for school.1 l = 1,} \\dots \\text{,L} \\\\    \n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\alpha_{m} \\\\\n      &\\beta_{1m}\n    \\end{aligned}\n  \\end{array}\n\\right)\n  &\\sim N \\left(\n\\left(\n  \\begin{array}{c} \n    \\begin{aligned}\n      &\\mu_{\\alpha_{m}} \\\\\n      &\\mu_{\\beta_{1m}}\n    \\end{aligned}\n  \\end{array}\n\\right)\n, \n\\left(\n  \\begin{array}{cc}\n     \\sigma^2_{\\alpha_{m}} & 0 \\\\ \n     0 & \\sigma^2_{\\beta_{1m}}\n  \\end{array}\n\\right)\n \\right)\n    \\text{, for district m = 1,} \\dots \\text{,M}\n\\end{aligned}"
  expect_equal(tex_long_mixed_ranef, equation_class(actual_long_mixed_ranef),
               label = "Mixed random effect structures at diff levels")
  
})
