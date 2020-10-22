library(lme4)

test_that("Unconditional lmer models work", {
  
  um_long1 <- lmer(score ~ 1 + (1|sid), data = sim_longitudinal)
  tex_um_long1 <- rm_ws(extract_eq(um_long1) )
  actual_um_long1 <- rm_ws("\\begin{aligned}\\operatorname{score}_{i}&\\simN\\left(\\alpha_{j[i]},\\sigma^2\\right)\\\\\\alpha_{j}&\\simN\\left(\\mu_{\\alpha_{j}},\\sigma^2_{\\alpha_{j}}\\right)\\text{,forsidj=1,}\\dots\\text{,J}\\end{aligned}")
  expect_equal(tex_um_long1, equation_class(actual_um_long1),
               label = "Unconditional two-level longitudinal model")
  
  um_long2 <- lmer(score ~ 1 + (1|sid) + (1|school), data = sim_longitudinal)
  tex_um_long2 <- rm_ws(extract_eq(um_long2))
  actual_um_long2 <- rm_ws("\\begin{aligned}\\operatorname{score}_{i}&\\simN\\left(\\alpha_{j[i],k[i]},\\sigma^2\\right)\\\\\\alpha_{j}&\\simN\\left(\\mu_{\\alpha_{j}},\\sigma^2_{\\alpha_{j}}\\right)\\text{,forsidj=1,}\\dots\\text{,J}\\\\\\alpha_{k}&\\simN\\left(\\mu_{\\alpha_{k}},\\sigma^2_{\\alpha_{k}}\\right)\\text{,forschoolk=1,}\\dots\\text{,K}\\end{aligned}")
  expect_equal(tex_um_long2, equation_class(actual_um_long2),
               label = "Unconditional three-level longitudinal model")
  
  um_long3 <- lmer(score ~ 1 + (1|sid) + (1|school) + (1|district), 
                data = sim_longitudinal)
  tex_um_long3 <- rm_ws(extract_eq(um_long3))
  actual_um_long3 <- rm_ws("\\begin{aligned}\\operatorname{score}_{i}&\\simN\\left(\\alpha_{j[i],k[i],l[i]},\\sigma^2\\right)\\\\\\alpha_{j}&\\simN\\left(\\mu_{\\alpha_{j}},\\sigma^2_{\\alpha_{j}}\\right)\\text{,forsidj=1,}\\dots\\text{,J}\\\\\\alpha_{k}&\\simN\\left(\\mu_{\\alpha_{k}},\\sigma^2_{\\alpha_{k}}\\right)\\text{,forschoolk=1,}\\dots\\text{,K}\\\\\\alpha_{l}&\\simN\\left(\\mu_{\\alpha_{l}},\\sigma^2_{\\alpha_{l}}\\right)\\text{,fordistrictl=1,}\\dots\\text{,L}\\end{aligned}")
  expect_equal(tex_um_long3, equation_class(actual_um_long3),
               label = "Unconditional three-level longitudinal model")
})

# lev 1 models used for multiple tests
lev1_hsb <- lmer(math ~ female + ses + minority + (1|sch.id), hsb)
lev1_long <- lmer(score ~ wave + (1|sid) + (1|school) + (1|district),
                  data = sim_longitudinal)

test_that("Level 1 predictors work", {
  tex_lev1_hsb <- rm_ws(extract_eq(lev1_hsb))
  actual_lev1_hsb <- rm_ws("\\begin{aligned}\\operatorname{math}_{i}&\\simN\\left(\\mu,\\sigma^2\\right)\\\\\\mu&=\\alpha_{j[i]}+\\beta_{1}(\\operatorname{female})+\\beta_{2}(\\operatorname{ses})+\\beta_{3}(\\operatorname{minority})\\\\\\alpha_{j}&\\simN\\left(\\mu_{\\alpha_{j}},\\sigma^2_{\\alpha_{j}}\\right)\\text{,forsch.idj=1,}\\dots\\text{,J}\\end{aligned}")
  expect_equal(tex_lev1_hsb, equation_class(actual_lev1_hsb),
               label = "Level 1 predictors HSB")
  
  tex_lev1_long <- rm_ws(extract_eq(lev1_long))
  actual_lev1_long <- rm_ws("\\begin{aligned}\\operatorname{score}_{i}&\\simN\\left(\\alpha_{j[i],k[i],l[i]}+\\beta_{1}(\\operatorname{wave}),\\sigma^2\\right)\\\\\\alpha_{j}&\\simN\\left(\\mu_{\\alpha_{j}},\\sigma^2_{\\alpha_{j}}\\right)\\text{,forsidj=1,}\\dots\\text{,J}\\\\\\alpha_{k}&\\simN\\left(\\mu_{\\alpha_{k}},\\sigma^2_{\\alpha_{k}}\\right)\\text{,forschoolk=1,}\\dots\\text{,K}\\\\\\alpha_{l}&\\simN\\left(\\mu_{\\alpha_{l}},\\sigma^2_{\\alpha_{l}}\\right)\\text{,fordistrictl=1,}\\dots\\text{,L}\\end{aligned}")
  expect_equal(tex_lev1_long, equation_class(actual_lev1_long),
               label = "Level 1 longitudinal")
})

test_that("Mean separate works as expected", {
  tex_lev1_hsb_ms <- rm_ws(extract_eq(lev1_hsb, mean_separate = FALSE))
  actual_lev1_hsb_ms <- rm_ws("\\begin{aligned}\\operatorname{math}_{i}&\\simN\\left(\\alpha_{j[i]}+\\beta_{1}(\\operatorname{female})+\\beta_{2}(\\operatorname{ses})+\\beta_{3}(\\operatorname{minority}),\\sigma^2\\right)\\\\\\alpha_{j}&\\simN\\left(\\mu_{\\alpha_{j}},\\sigma^2_{\\alpha_{j}}\\right)\\text{,forsch.idj=1,}\\dots\\text{,J}\\end{aligned}")
  expect_equal(tex_lev1_hsb_ms, equation_class(actual_lev1_hsb_ms),
               label = "Mean separate HSB")
  
  tex_lev1_long_ms <- rm_ws(extract_eq(lev1_long, mean_separate = TRUE))
  actual_lev1_long1_ms <- rm_ws("\\begin{aligned}\\operatorname{score}_{i}&\\simN\\left(\\mu,\\sigma^2\\right)\\\\\\mu&=\\alpha_{j[i],k[i],l[i]}+\\beta_{1}(\\operatorname{wave})\\\\\\alpha_{j}&\\simN\\left(\\mu_{\\alpha_{j}},\\sigma^2_{\\alpha_{j}}\\right)\\text{,forsidj=1,}\\dots\\text{,J}\\\\\\alpha_{k}&\\simN\\left(\\mu_{\\alpha_{k}},\\sigma^2_{\\alpha_{k}}\\right)\\text{,forschoolk=1,}\\dots\\text{,K}\\\\\\alpha_{l}&\\simN\\left(\\mu_{\\alpha_{l}},\\sigma^2_{\\alpha_{l}}\\right)\\text{,fordistrictl=1,}\\dots\\text{,L}\\end{aligned}")
  expect_equal(tex_lev1_long_ms, equation_class(actual_lev1_long1_ms),
               label = "Mean separate longitudinal")
})

test_that("Wrapping works as expected", {
  tex_lev1_hsb_wrap <- rm_ws(extract_eq(lev1_hsb, wrap = TRUE, terms_per_line = 2))
  actual_lev1_hsb_wrap <- rm_ws("\\begin{aligned}\\operatorname{math}_{i}&\\simN\\left(\\mu,\\sigma^2\\right)\\\\\\mu&=\\alpha_{j[i]}+\\beta_{1}(\\operatorname{female})\\+\\\\&\\quad\\beta_{2}(\\operatorname{ses})+\\beta_{3}(\\operatorname{minority})\\\\\\alpha_{j}&\\simN\\left(\\mu_{\\alpha_{j}},\\sigma^2_{\\alpha_{j}}\\right)\\text{,forsch.idj=1,}\\dots\\text{,J}\\end{aligned}")
  expect_equal(tex_lev1_hsb_wrap, equation_class(actual_lev1_hsb_wrap),
               label = "Wrapping HSB")
})

test_that("Unstructured variance-covariances work as expected", {
  # two-level models
  hsb1 <- lmer(math ~ female + ses + minority + (minority|sch.id),
               hsb)
  tex_hsb1 <- rm_ws(extract_eq(hsb1))
  actual_hsb1 <- rm_ws("\\begin{aligned}\\operatorname{math}_{i}&\\simN\\left(\\mu,\\sigma^2\\right)\\\\\\mu&=\\alpha_{j[i]}+\\beta_{1}(\\operatorname{female})+\\beta_{2}(\\operatorname{ses})+\\beta_{3j[i]}(\\operatorname{minority})\\\\\\left(\\begin{array}{c}\\begin{aligned}&\\alpha_{j}\\\\&\\beta_{3j}\\end{aligned}\\end{array}\\right)&\\simN\\left(\\left(\\begin{array}{c}\\begin{aligned}&\\mu_{\\alpha_{j}}\\\\&\\mu_{\\beta_{3j}}\\end{aligned}\\end{array}\\right),\\left(\\begin{array}{cc}\\sigma^2_{\\alpha_{j}}&\\rho_{\\alpha_{j}\\beta_{3j}}\\\\\\rho_{\\beta_{3j}\\alpha_{j}}&\\sigma^2_{\\beta_{3j}}\\end{array}\\right)\\right)\\text{,forsch.idj=1,}\\dots\\text{,J}\\end{aligned}")
  expect_equal(tex_hsb1, equation_class(actual_hsb1),
               label = "Unstructured VCV, HSB 1")
  
  hsb2 <- lmer(math ~ female + ses + minority + (ses + female|sch.id),
               hsb)
  tex_hsb2 <- rm_ws(extract_eq(hsb2))
  actual_hsb2 <- rm_ws("\\begin{aligned}\\operatorname{math}_{i}&\\simN\\left(\\mu,\\sigma^2\\right)\\\\\\mu&=\\alpha_{j[i]}+\\beta_{1j[i]}(\\operatorname{female})+\\beta_{2j[i]}(\\operatorname{ses})+\\beta_{3}(\\operatorname{minority})\\\\\\left(\\begin{array}{c}\\begin{aligned}&\\alpha_{j}\\\\&\\beta_{1j}\\\\&\\beta_{2j}\\end{aligned}\\end{array}\\right)&\\simN\\left(\\left(\\begin{array}{c}\\begin{aligned}&\\mu_{\\alpha_{j}}\\\\&\\mu_{\\beta_{1j}}\\\\&\\mu_{\\beta_{2j}}\\end{aligned}\\end{array}\\right),\\left(\\begin{array}{ccc}\\sigma^2_{\\alpha_{j}}&\\rho_{\\alpha_{j}\\beta_{1j}}&\\rho_{\\alpha_{j}\\beta_{2j}}\\\\\\rho_{\\beta_{1j}\\alpha_{j}}&\\sigma^2_{\\beta_{1j}}&\\rho_{\\beta_{1j}\\beta_{2j}}\\\\\\rho_{\\beta_{2j}\\alpha_{j}}&\\rho_{\\beta_{2j}\\beta_{1j}}&\\sigma^2_{\\beta_{2j}}\\end{array}\\right)\\right)\\text{,forsch.idj=1,}\\dots\\text{,J}\\end{aligned}")
  expect_equal(tex_hsb2, equation_class(actual_hsb2),
               label = "Unstructured VCV, HSB 2")
  
  hsb3 <- lmer(math ~ female * ses + minority + (ses * female|sch.id),
               hsb)
  tex_hsb3 <- rm_ws(extract_eq(hsb3))
  actual_hsb3 <- rm_ws("\\begin{aligned}\\operatorname{math}_{i}&\\simN\\left(\\mu,\\sigma^2\\right)\\\\\\mu&=\\alpha_{j[i]}+\\beta_{1j[i]}(\\operatorname{female})+\\beta_{2j[i]}(\\operatorname{ses})+\\beta_{3}(\\operatorname{minority})+\\beta_{4j[i]}(\\operatorname{female}\\times\\operatorname{ses})\\\\\\left(\\begin{array}{c}\\begin{aligned}&\\alpha_{j}\\\\&\\beta_{1j}\\\\&\\beta_{2j}\\\\&\\beta_{4j}\\end{aligned}\\end{array}\\right)&\\simN\\left(\\left(\\begin{array}{c}\\begin{aligned}&\\mu_{\\alpha_{j}}\\\\&\\mu_{\\beta_{1j}}\\\\&\\mu_{\\beta_{2j}}\\\\&\\mu_{\\beta_{4j}}\\end{aligned}\\end{array}\\right),\\left(\\begin{array}{cccc}\\sigma^2_{\\alpha_{j}}&\\rho_{\\alpha_{j}\\beta_{1j}}&\\rho_{\\alpha_{j}\\beta_{2j}}&\\rho_{\\alpha_{j}\\beta_{4j}}\\\\\\rho_{\\beta_{1j}\\alpha_{j}}&\\sigma^2_{\\beta_{1j}}&\\rho_{\\beta_{1j}\\beta_{2j}}&\\rho_{\\beta_{1j}\\beta_{4j}}\\\\\\rho_{\\beta_{2j}\\alpha_{j}}&\\rho_{\\beta_{2j}\\beta_{1j}}&\\sigma^2_{\\beta_{2j}}&\\rho_{\\beta_{2j}\\beta_{4j}}\\\\\\rho_{\\beta_{4j}\\alpha_{j}}&\\rho_{\\beta_{4j}\\beta_{1j}}&\\rho_{\\beta_{4j}\\beta_{2j}}&\\sigma^2_{\\beta_{4j}}\\end{array}\\right)\\right)\\text{,forsch.idj=1,}\\dots\\text{,J}\\end{aligned}")
  expect_equal(tex_hsb3, equation_class(actual_hsb3),
               label = "Unstructured VCV, HSB 3")
  
  suppressWarnings(
    hsb4 <- lmer(math ~ female * ses + minority + 
                   (ses * female + minority|sch.id),
                 hsb)
  )
  tex_hsb4 <- rm_ws(extract_eq(hsb4))
  actual_hsb4 <- rm_ws("\\begin{aligned}\\operatorname{math}_{i}&\\simN\\left(\\mu,\\sigma^2\\right)\\\\\\mu&=\\alpha_{j[i]}+\\beta_{1j[i]}(\\operatorname{female})+\\beta_{2j[i]}(\\operatorname{ses})+\\beta_{3j[i]}(\\operatorname{minority})+\\beta_{4j[i]}(\\operatorname{female}\\times\\operatorname{ses})\\\\\\left(\\begin{array}{c}\\begin{aligned}&\\alpha_{j}\\\\&\\beta_{1j}\\\\&\\beta_{2j}\\\\&\\beta_{3j}\\\\&\\beta_{4j}\\end{aligned}\\end{array}\\right)&\\simN\\left(\\left(\\begin{array}{c}\\begin{aligned}&\\mu_{\\alpha_{j}}\\\\&\\mu_{\\beta_{1j}}\\\\&\\mu_{\\beta_{2j}}\\\\&\\mu_{\\beta_{3j}}\\\\&\\mu_{\\beta_{4j}}\\end{aligned}\\end{array}\\right),\\left(\\begin{array}{ccccc}\\sigma^2_{\\alpha_{j}}&\\rho_{\\alpha_{j}\\beta_{1j}}&\\rho_{\\alpha_{j}\\beta_{2j}}&\\rho_{\\alpha_{j}\\beta_{3j}}&\\rho_{\\alpha_{j}\\beta_{4j}}\\\\\\rho_{\\beta_{1j}\\alpha_{j}}&\\sigma^2_{\\beta_{1j}}&\\rho_{\\beta_{1j}\\beta_{2j}}&\\rho_{\\beta_{1j}\\beta_{3j}}&\\rho_{\\beta_{1j}\\beta_{4j}}\\\\\\rho_{\\beta_{2j}\\alpha_{j}}&\\rho_{\\beta_{2j}\\beta_{1j}}&\\sigma^2_{\\beta_{2j}}&\\rho_{\\beta_{2j}\\beta_{3j}}&\\rho_{\\beta_{2j}\\beta_{4j}}\\\\\\rho_{\\beta_{3j}\\alpha_{j}}&\\rho_{\\beta_{3j}\\beta_{1j}}&\\rho_{\\beta_{3j}\\beta_{2j}}&\\sigma^2_{\\beta_{3j}}&\\rho_{\\beta_{3j}\\beta_{4j}}\\\\\\rho_{\\beta_{4j}\\alpha_{j}}&\\rho_{\\beta_{4j}\\beta_{1j}}&\\rho_{\\beta_{4j}\\beta_{2j}}&\\rho_{\\beta_{4j}\\beta_{3j}}&\\sigma^2_{\\beta_{4j}}\\end{array}\\right)\\right)\\text{,forsch.idj=1,}\\dots\\text{,J}\\end{aligned}")
  expect_equal(tex_hsb4, equation_class(actual_hsb4),
               label = "Unstructured VCV, HSB 4")
  
  # four-level model
  long1 <- lmer(score ~ wave + 
                  (wave|sid) + (wave|school) + (wave|district),
             sim_longitudinal)
  tex_long1 <- rm_ws(extract_eq(long1))
  actual_long1 <- rm_ws("\\begin{aligned}\\operatorname{score}_{i}&\\simN\\left(\\alpha_{j[i],k[i],l[i]}+\\beta_{1j[i],k[i],l[i]}(\\operatorname{wave}),\\sigma^2\\right)\\\\\\left(\\begin{array}{c}\\begin{aligned}&\\alpha_{j}\\\\&\\beta_{1j}\\end{aligned}\\end{array}\\right)&\\simN\\left(\\left(\\begin{array}{c}\\begin{aligned}&\\mu_{\\alpha_{j}}\\\\&\\mu_{\\beta_{1j}}\\end{aligned}\\end{array}\\right),\\left(\\begin{array}{cc}\\sigma^2_{\\alpha_{j}}&\\rho_{\\alpha_{j}\\beta_{1j}}\\\\\\rho_{\\beta_{1j}\\alpha_{j}}&\\sigma^2_{\\beta_{1j}}\\end{array}\\right)\\right)\\text{,forsidj=1,}\\dots\\text{,J}\\\\\\left(\\begin{array}{c}\\begin{aligned}&\\alpha_{k}\\\\&\\beta_{1k}\\end{aligned}\\end{array}\\right)&\\simN\\left(\\left(\\begin{array}{c}\\begin{aligned}&\\mu_{\\alpha_{k}}\\\\&\\mu_{\\beta_{1k}}\\end{aligned}\\end{array}\\right),\\left(\\begin{array}{cc}\\sigma^2_{\\alpha_{k}}&\\rho_{\\alpha_{k}\\beta_{1k}}\\\\\\rho_{\\beta_{1k}\\alpha_{k}}&\\sigma^2_{\\beta_{1k}}\\end{array}\\right)\\right)\\text{,forschoolk=1,}\\dots\\text{,K}\\\\\\left(\\begin{array}{c}\\begin{aligned}&\\alpha_{l}\\\\&\\beta_{1l}\\end{aligned}\\end{array}\\right)&\\simN\\left(\\left(\\begin{array}{c}\\begin{aligned}&\\mu_{\\alpha_{l}}\\\\&\\mu_{\\beta_{1l}}\\end{aligned}\\end{array}\\right),\\left(\\begin{array}{cc}\\sigma^2_{\\alpha_{l}}&\\rho_{\\alpha_{l}\\beta_{1l}}\\\\\\rho_{\\beta_{1l}\\alpha_{l}}&\\sigma^2_{\\beta_{1l}}\\end{array}\\right)\\right)\\text{,fordistrictl=1,}\\dots\\text{,L}\\end{aligned}")
  expect_equal(tex_long1, equation_class(actual_long1),
               label = "Unstructured VCV, Longitudinal 1")
})

test_that("Group-level predictors work as expected", {
  # level 2 variables
  suppressWarnings(
    long2 <- lmer(score ~ wave + group + treatment +
                    (wave|sid) + (wave + group + treatment|school) +
                    (wave + treatment|district),
                  sim_longitudinal)
  )
  tex_long2 <- rm_ws(extract_eq(long2))
  actual_long2 <- rm_ws("\\begin{aligned}\\operatorname{score}_{i}&\\simN\\left(\\alpha_{j[i],k[i],l[i]}+\\beta_{1j[i],k[i],l[i]}(\\operatorname{wave}),\\sigma^2\\right)\\\\\\left(\\begin{array}{c}\\begin{aligned}&\\alpha_{j}\\\\&\\beta_{1j}\\end{aligned}\\end{array}\\right)&\\simN\\left(\\left(\\begin{array}{c}\\begin{aligned}&\\gamma_{0}^{\\alpha}+\\gamma_{1k[i]}^{\\alpha}(\\operatorname{group}_{\\operatorname{low}})+\\gamma_{2k[i]}^{\\alpha}(\\operatorname{group}_{\\operatorname{medium}})+\\gamma_{3k[i],l[i]}^{\\alpha}(\\operatorname{treatment}_{\\operatorname{1}})\\\\&\\mu_{\\beta_{1j}}\\end{aligned}\\end{array}\\right),\\left(\\begin{array}{cc}\\sigma^2_{\\alpha_{j}}&\\rho_{\\alpha_{j}\\beta_{1j}}\\\\\\rho_{\\beta_{1j}\\alpha_{j}}&\\sigma^2_{\\beta_{1j}}\\end{array}\\right)\\right)\\text{,forsidj=1,}\\dots\\text{,J}\\\\\\left(\\begin{array}{c}\\begin{aligned}&\\alpha_{k}\\\\&\\beta_{1k}\\\\&\\gamma_{1k}\\\\&\\gamma_{2k}\\\\&\\gamma_{3k}\\end{aligned}\\end{array}\\right)&\\simN\\left(\\left(\\begin{array}{c}\\begin{aligned}&\\mu_{\\alpha_{k}}\\\\&\\mu_{\\beta_{1k}}\\\\&\\mu_{\\gamma_{1k}}\\\\&\\mu_{\\gamma_{2k}}\\\\&\\mu_{\\gamma_{3k}}\\end{aligned}\\end{array}\\right),\\left(\\begin{array}{ccccc}\\sigma^2_{\\alpha_{k}}&\\rho_{\\alpha_{k}\\beta_{1k}}&\\rho_{\\alpha_{k}\\gamma_{1k}}&\\rho_{\\alpha_{k}\\gamma_{2k}}&\\rho_{\\alpha_{k}\\gamma_{3k}}\\\\\\rho_{\\beta_{1k}\\alpha_{k}}&\\sigma^2_{\\beta_{1k}}&\\rho_{\\beta_{1k}\\gamma_{1k}}&\\rho_{\\beta_{1k}\\gamma_{2k}}&\\rho_{\\beta_{1k}\\gamma_{3k}}\\\\\\rho_{\\gamma_{1k}\\alpha_{k}}&\\rho_{\\gamma_{1k}\\beta_{1k}}&\\sigma^2_{\\gamma_{1k}}&\\rho_{\\gamma_{1k}\\gamma_{2k}}&\\rho_{\\gamma_{1k}\\gamma_{3k}}\\\\\\rho_{\\gamma_{2k}\\alpha_{k}}&\\rho_{\\gamma_{2k}\\beta_{1k}}&\\rho_{\\gamma_{2k}\\gamma_{1k}}&\\sigma^2_{\\gamma_{2k}}&\\rho_{\\gamma_{2k}\\gamma_{3k}}\\\\\\rho_{\\gamma_{3k}\\alpha_{k}}&\\rho_{\\gamma_{3k}\\beta_{1k}}&\\rho_{\\gamma_{3k}\\gamma_{1k}}&\\rho_{\\gamma_{3k}\\gamma_{2k}}&\\sigma^2_{\\gamma_{3k}}\\end{array}\\right)\\right)\\text{,forschoolk=1,}\\dots\\text{,K}\\\\\\left(\\begin{array}{c}\\begin{aligned}&\\alpha_{l}\\\\&\\beta_{1l}\\\\&\\gamma_{3l}\\end{aligned}\\end{array}\\right)&\\simN\\left(\\left(\\begin{array}{c}\\begin{aligned}&\\mu_{\\alpha_{l}}\\\\&\\mu_{\\beta_{1l}}\\\\&\\mu_{\\gamma_{3l}}\\end{aligned}\\end{array}\\right),\\left(\\begin{array}{ccc}\\sigma^2_{\\alpha_{l}}&\\rho_{\\alpha_{l}\\beta_{1l}}&\\rho_{\\alpha_{l}\\gamma_{3l}}\\\\\\rho_{\\beta_{1l}\\alpha_{l}}&\\sigma^2_{\\beta_{1l}}&\\rho_{\\beta_{1l}\\gamma_{3l}}\\\\\\rho_{\\gamma_{3l}\\alpha_{l}}&\\rho_{\\gamma_{3l}\\beta_{1l}}&\\sigma^2_{\\gamma_{3l}}\\end{array}\\right)\\right)\\text{,fordistrictl=1,}\\dots\\text{,L}\\end{aligned}")
  expect_equal(tex_long2, equation_class(actual_long2),
               label = "Group-level predictors, Longitudinal (level 2)")
  
  # level 3 variable
  long3 <- lmer(score ~ wave + group + treatment + prop_low +
                  (wave|sid) + (wave + group + treatment|school) +
                  (wave + treatment + prop_low|district),
                sim_longitudinal)
  
  tex_long3 <- rm_ws(extract_eq(long3))
  actual_long3 <- rm_ws("\\begin{aligned}\\operatorname{score}_{i}&\\simN\\left(\\alpha_{j[i],k[i],l[i]}+\\beta_{1j[i],k[i],l[i]}(\\operatorname{wave}),\\sigma^2\\right)\\\\\\left(\\begin{array}{c}\\begin{aligned}&\\alpha_{j}\\\\&\\beta_{1j}\\end{aligned}\\end{array}\\right)&\\simN\\left(\\left(\\begin{array}{c}\\begin{aligned}&\\gamma_{0}^{\\alpha}+\\gamma_{1k[i]}^{\\alpha}(\\operatorname{group}_{\\operatorname{low}})+\\gamma_{2k[i]}^{\\alpha}(\\operatorname{group}_{\\operatorname{medium}})+\\gamma_{3k[i],l[i]}^{\\alpha}(\\operatorname{treatment}_{\\operatorname{1}})\\\\&\\mu_{\\beta_{1j}}\\end{aligned}\\end{array}\\right),\\left(\\begin{array}{cc}\\sigma^2_{\\alpha_{j}}&\\rho_{\\alpha_{j}\\beta_{1j}}\\\\\\rho_{\\beta_{1j}\\alpha_{j}}&\\sigma^2_{\\beta_{1j}}\\end{array}\\right)\\right)\\text{,forsidj=1,}\\dots\\text{,J}\\\\\\left(\\begin{array}{c}\\begin{aligned}&\\alpha_{k}\\\\&\\beta_{1k}\\\\&\\gamma_{1k}\\\\&\\gamma_{2k}\\\\&\\gamma_{3k}\\end{aligned}\\end{array}\\right)&\\simN\\left(\\left(\\begin{array}{c}\\begin{aligned}&\\gamma_{0}^{\\alpha}+\\gamma_{1l[i]}^{\\alpha}(\\operatorname{prop\\_low})\\\\&\\mu_{\\beta_{1k}}\\\\&\\mu_{\\gamma_{1k}}\\\\&\\mu_{\\gamma_{2k}}\\\\&\\mu_{\\gamma_{3k}}\\end{aligned}\\end{array}\\right),\\left(\\begin{array}{ccccc}\\sigma^2_{\\alpha_{k}}&\\rho_{\\alpha_{k}\\beta_{1k}}&\\rho_{\\alpha_{k}\\gamma_{1k}}&\\rho_{\\alpha_{k}\\gamma_{2k}}&\\rho_{\\alpha_{k}\\gamma_{3k}}\\\\\\rho_{\\beta_{1k}\\alpha_{k}}&\\sigma^2_{\\beta_{1k}}&\\rho_{\\beta_{1k}\\gamma_{1k}}&\\rho_{\\beta_{1k}\\gamma_{2k}}&\\rho_{\\beta_{1k}\\gamma_{3k}}\\\\\\rho_{\\gamma_{1k}\\alpha_{k}}&\\rho_{\\gamma_{1k}\\beta_{1k}}&\\sigma^2_{\\gamma_{1k}}&\\rho_{\\gamma_{1k}\\gamma_{2k}}&\\rho_{\\gamma_{1k}\\gamma_{3k}}\\\\\\rho_{\\gamma_{2k}\\alpha_{k}}&\\rho_{\\gamma_{2k}\\beta_{1k}}&\\rho_{\\gamma_{2k}\\gamma_{1k}}&\\sigma^2_{\\gamma_{2k}}&\\rho_{\\gamma_{2k}\\gamma_{3k}}\\\\\\rho_{\\gamma_{3k}\\alpha_{k}}&\\rho_{\\gamma_{3k}\\beta_{1k}}&\\rho_{\\gamma_{3k}\\gamma_{1k}}&\\rho_{\\gamma_{3k}\\gamma_{2k}}&\\sigma^2_{\\gamma_{3k}}\\end{array}\\right)\\right)\\text{,forschoolk=1,}\\dots\\text{,K}\\\\\\left(\\begin{array}{c}\\begin{aligned}&\\alpha_{l}\\\\&\\beta_{1l}\\\\&\\gamma_{3l}\\\\&\\gamma_{1l}\\end{aligned}\\end{array}\\right)&\\simN\\left(\\left(\\begin{array}{c}\\begin{aligned}&\\mu_{\\alpha_{l}}\\\\&\\mu_{\\beta_{1l}}\\\\&\\mu_{\\gamma_{3l}}\\\\&\\mu_{\\gamma_{1l}}\\end{aligned}\\end{array}\\right),\\left(\\begin{array}{cccc}\\sigma^2_{\\alpha_{l}}&\\rho_{\\alpha_{l}\\beta_{1l}}&\\rho_{\\alpha_{l}\\gamma_{3l}}&\\rho_{\\alpha_{l}\\gamma_{1l}}\\\\\\rho_{\\beta_{1l}\\alpha_{l}}&\\sigma^2_{\\beta_{1l}}&\\rho_{\\beta_{1l}\\gamma_{3l}}&\\rho_{\\beta_{1l}\\gamma_{1l}}\\\\\\rho_{\\gamma_{3l}\\alpha_{l}}&\\rho_{\\gamma_{3l}\\beta_{1l}}&\\sigma^2_{\\gamma_{3l}}&\\rho_{\\gamma_{3l}\\gamma_{1l}}\\\\\\rho_{\\gamma_{1l}\\alpha_{l}}&\\rho_{\\gamma_{1l}\\beta_{1l}}&\\rho_{\\gamma_{1l}\\gamma_{3l}}&\\sigma^2_{\\gamma_{1l}}\\end{array}\\right)\\right)\\text{,fordistrictl=1,}\\dots\\text{,L}\\end{aligned}")
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
  tex_long4 <- rm_ws(extract_eq(long4))
  actual_long4 <- rm_ws("\\begin{aligned}\\operatorname{score}_{i}&\\simN\\left(\\alpha_{j[i],k[i],l[i]}+\\beta_{1j[i],k[i],l[i]}(\\operatorname{wave}),\\sigma^2\\right)\\\\\\left(\\begin{array}{c}\\begin{aligned}&\\alpha_{j}\\\\&\\beta_{1j}\\end{aligned}\\end{array}\\right)&\\simN\\left(\\left(\\begin{array}{c}\\begin{aligned}&\\gamma_{0}^{\\alpha}+\\gamma_{1}^{\\alpha}(\\operatorname{group}_{\\operatorname{low}})+\\gamma_{2}^{\\alpha}(\\operatorname{group}_{\\operatorname{medium}})+\\gamma_{3k[i]}^{\\alpha}(\\operatorname{treatment}_{\\operatorname{1}})\\\\&\\mu_{\\beta_{1j}}\\end{aligned}\\end{array}\\right),\\left(\\begin{array}{cc}\\sigma^2_{\\alpha_{j}}&\\rho_{\\alpha_{j}\\beta_{1j}}\\\\\\rho_{\\beta_{1j}\\alpha_{j}}&\\sigma^2_{\\beta_{1j}}\\end{array}\\right)\\right)\\text{,forsidj=1,}\\dots\\text{,J}\\\\\\left(\\begin{array}{c}\\begin{aligned}&\\alpha_{k}\\\\&\\beta_{1k}\\\\&\\gamma_{3k}\\end{aligned}\\end{array}\\right)&\\simN\\left(\\left(\\begin{array}{c}\\begin{aligned}&\\gamma_{0}^{\\alpha}+\\gamma_{1}^{\\alpha}(\\operatorname{prop\\_low})\\\\&\\mu_{\\beta_{1k}}\\\\&\\mu_{\\gamma_{3k}}\\end{aligned}\\end{array}\\right),\\left(\\begin{array}{ccc}\\sigma^2_{\\alpha_{k}}&\\rho_{\\alpha_{k}\\beta_{1k}}&\\rho_{\\alpha_{k}\\gamma_{3k}}\\\\\\rho_{\\beta_{1k}\\alpha_{k}}&\\sigma^2_{\\beta_{1k}}&\\rho_{\\beta_{1k}\\gamma_{3k}}\\\\\\rho_{\\gamma_{3k}\\alpha_{k}}&\\rho_{\\gamma_{3k}\\beta_{1k}}&\\sigma^2_{\\gamma_{3k}}\\end{array}\\right)\\right)\\text{,forschoolk=1,}\\dots\\text{,K}\\\\\\left(\\begin{array}{c}\\begin{aligned}&\\alpha_{l}\\\\&\\beta_{1l}\\end{aligned}\\end{array}\\right)&\\simN\\left(\\left(\\begin{array}{c}\\begin{aligned}&\\gamma_{0}^{\\alpha}+\\gamma_{1}^{\\alpha}(\\operatorname{dist\\_mean})\\\\&\\mu_{\\beta_{1l}}\\end{aligned}\\end{array}\\right),\\left(\\begin{array}{cc}\\sigma^2_{\\alpha_{l}}&\\rho_{\\alpha_{l}\\beta_{1l}}\\\\\\rho_{\\beta_{1l}\\alpha_{l}}&\\sigma^2_{\\beta_{1l}}\\end{array}\\right)\\right)\\text{,fordistrictl=1,}\\dots\\text{,L}\\end{aligned}")
  expect_equal(tex_long4, equation_class(actual_long4),
               label = "Group-level predictors, Longitudinal (level 4)")
})
data("sim_longitudinal", package = "equatiomatic")

test_that("Interactions work as expected", {
  # l1 interaction
  l1_hsb_int <- lmer(math ~ minority*female + (1|sch.id),
                     data = hsb)
  tex_l1_hsb_int <- rm_ws(extract_eq(l1_hsb_int))
  actual_l1_hsb_int <- rm_ws("\\begin{aligned}\\operatorname{math}_{i}&\\simN\\left(\\mu,\\sigma^2\\right)\\\\\\mu&=\\alpha_{j[i]}+\\beta_{1}(\\operatorname{minority})+\\beta_{2}(\\operatorname{female})+\\beta_{3}(\\operatorname{female}\\times\\operatorname{minority})\\\\\\alpha_{j}&\\simN\\left(\\mu_{\\alpha_{j}},\\sigma^2_{\\alpha_{j}}\\right)\\text{,forsch.idj=1,}\\dots\\text{,J}\\end{aligned}")
  expect_equal(tex_l1_hsb_int, equation_class(actual_l1_hsb_int),
               label = "Level 1 interaction")
  
  # l2 interaction
  l2_long_int <- lmer(score ~ treatment*group + (1|sid) + (treatment|school) + 
                        (treatment*group|district),
                      data = sim_longitudinal)
  tex_l2_long_int <- rm_ws(extract_eq(l2_long_int))
  actual_l2_long_int <- rm_ws("\\begin{aligned}\\operatorname{score}_{i}&\\simN\\left(\\alpha_{j[i],k[i],l[i]},\\sigma^2\\right)\\\\\\alpha_{j}&\\simN\\left(\\gamma_{0}^{\\alpha}+\\gamma_{1k[i],l[i]}^{\\alpha}(\\operatorname{treatment}_{\\operatorname{1}})+\\gamma_{2l[i]}^{\\alpha}(\\operatorname{group}_{\\operatorname{low}})+\\gamma_{3l[i]}^{\\alpha}(\\operatorname{group}_{\\operatorname{medium}})+\\gamma_{4l[i]}^{\\alpha}(\\operatorname{group}_{\\operatorname{low}}\\times\\operatorname{treatment}_{\\operatorname{1}})+\\gamma_{5l[i]}^{\\alpha}(\\operatorname{group}_{\\operatorname{medium}}\\times\\operatorname{treatment}_{\\operatorname{1}}),\\sigma^2_{\\alpha_{j}}\\right)\\text{,forsidj=1,}\\dots\\text{,J}\\\\\\left(\\begin{array}{c}\\begin{aligned}&\\alpha_{k}\\\\&\\gamma_{1k}\\end{aligned}\\end{array}\\right)&\\simN\\left(\\left(\\begin{array}{c}\\begin{aligned}&\\mu_{\\alpha_{k}}\\\\&\\mu_{\\gamma_{1k}}\\end{aligned}\\end{array}\\right),\\left(\\begin{array}{cc}\\sigma^2_{\\alpha_{k}}&\\rho_{\\alpha_{k}\\gamma_{1k}}\\\\\\rho_{\\gamma_{1k}\\alpha_{k}}&\\sigma^2_{\\gamma_{1k}}\\end{array}\\right)\\right)\\text{,forschoolk=1,}\\dots\\text{,K}\\\\\\left(\\begin{array}{c}\\begin{aligned}&\\alpha_{l}\\\\&\\gamma_{1l}\\\\&\\gamma_{2l}\\\\&\\gamma_{3l}\\\\&\\gamma_{4l}\\\\&\\gamma_{5l}\\end{aligned}\\end{array}\\right)&\\simN\\left(\\left(\\begin{array}{c}\\begin{aligned}&\\mu_{\\alpha_{l}}\\\\&\\mu_{\\gamma_{1l}}\\\\&\\mu_{\\gamma_{2l}}\\\\&\\mu_{\\gamma_{3l}}\\\\&\\mu_{\\gamma_{4l}}\\\\&\\mu_{\\gamma_{5l}}\\end{aligned}\\end{array}\\right),\\left(\\begin{array}{cccccc}\\sigma^2_{\\alpha_{l}}&\\rho_{\\alpha_{l}\\gamma_{1l}}&\\rho_{\\alpha_{l}\\gamma_{2l}}&\\rho_{\\alpha_{l}\\gamma_{3l}}&\\rho_{\\alpha_{l}\\gamma_{4l}}&\\rho_{\\alpha_{l}\\gamma_{5l}}\\\\\\rho_{\\gamma_{1l}\\alpha_{l}}&\\sigma^2_{\\gamma_{1l}}&\\rho_{\\gamma_{1l}\\gamma_{2l}}&\\rho_{\\gamma_{1l}\\gamma_{3l}}&\\rho_{\\gamma_{1l}\\gamma_{4l}}&\\rho_{\\gamma_{1l}\\gamma_{5l}}\\\\\\rho_{\\gamma_{2l}\\alpha_{l}}&\\rho_{\\gamma_{2l}\\gamma_{1l}}&\\sigma^2_{\\gamma_{2l}}&\\rho_{\\gamma_{2l}\\gamma_{3l}}&\\rho_{\\gamma_{2l}\\gamma_{4l}}&\\rho_{\\gamma_{2l}\\gamma_{5l}}\\\\\\rho_{\\gamma_{3l}\\alpha_{l}}&\\rho_{\\gamma_{3l}\\gamma_{1l}}&\\rho_{\\gamma_{3l}\\gamma_{2l}}&\\sigma^2_{\\gamma_{3l}}&\\rho_{\\gamma_{3l}\\gamma_{4l}}&\\rho_{\\gamma_{3l}\\gamma_{5l}}\\\\\\rho_{\\gamma_{4l}\\alpha_{l}}&\\rho_{\\gamma_{4l}\\gamma_{1l}}&\\rho_{\\gamma_{4l}\\gamma_{2l}}&\\rho_{\\gamma_{4l}\\gamma_{3l}}&\\sigma^2_{\\gamma_{4l}}&\\rho_{\\gamma_{4l}\\gamma_{5l}}\\\\\\rho_{\\gamma_{5l}\\alpha_{l}}&\\rho_{\\gamma_{5l}\\gamma_{1l}}&\\rho_{\\gamma_{5l}\\gamma_{2l}}&\\rho_{\\gamma_{5l}\\gamma_{3l}}&\\rho_{\\gamma_{5l}\\gamma_{4l}}&\\sigma^2_{\\gamma_{5l}}\\end{array}\\right)\\right)\\text{,fordistrictl=1,}\\dots\\text{,L}\\end{aligned}")
  expect_equal(tex_l2_long_int, equation_class(actual_l2_long_int),
               label = "Level 2 interaction")
  
  # cross-level interaction w/random at the level
  cl_long1 <- lmer(score ~ treatment*wave + (wave|sid) + (1|school) + 
                        (1|district),
                      data = sim_longitudinal)
  tex_cl_long1 <- rm_ws(extract_eq(cl_long1))
  actual_cl_long1 <- rm_ws("\\begin{aligned}\\operatorname{score}_{i}&\\simN\\left(\\alpha_{j[i],k[i],l[i]}+\\beta_{0j[i]}(\\operatorname{wave}),\\sigma^2\\right)\\\\\\left(\\begin{array}{c}\\begin{aligned}&\\alpha_{j}\\\\&\\beta_{0j}\\end{aligned}\\end{array}\\right)&\\simN\\left(\\left(\\begin{array}{c}\\begin{aligned}&\\gamma_{0}^{\\alpha}+\\gamma_{1}^{\\alpha}(\\operatorname{treatment}_{\\operatorname{1}})\\\\&\\gamma^{\\beta_{0}}_{0}+\\gamma^{\\beta_{0}}_{1}(\\operatorname{treatment}_{\\operatorname{1}})\\end{aligned}\\end{array}\\right),\\left(\\begin{array}{cc}\\sigma^2_{\\alpha_{j}}&\\rho_{\\alpha_{j}\\beta_{0j}}\\\\\\rho_{\\beta_{0j}\\alpha_{j}}&\\sigma^2_{\\beta_{0j}}\\end{array}\\right)\\right)\\text{,forsidj=1,}\\dots\\text{,J}\\\\\\alpha_{k}&\\simN\\left(\\mu_{\\alpha_{k}},\\sigma^2_{\\alpha_{k}}\\right)\\text{,forschoolk=1,}\\dots\\text{,K}\\\\\\alpha_{l}&\\simN\\left(\\mu_{\\alpha_{l}},\\sigma^2_{\\alpha_{l}}\\right)\\text{,fordistrictl=1,}\\dots\\text{,L}\\end{aligned}")
  expect_equal(tex_cl_long1, equation_class(actual_cl_long1),
               label = "Cross-level interaction (random at that level)")
  
  # cross-level interaction w/o random at the level
  cl_long2 <- lmer(score ~ treatment*wave + (1|sid) + (1|school) + 
                      (1|district),
                    data = sim_longitudinal)
  tex_cl_long2 <- rm_ws(extract_eq(cl_long2))
  actual_cl_long2 <- rm_ws("\\begin{aligned}\\operatorname{score}_{i}&\\simN\\left(\\alpha_{j[i],k[i],l[i]}+\\beta_{0}(\\operatorname{wave}),\\sigma^2\\right)\\\\\\alpha_{j}&\\simN\\left(\\gamma_{0}^{\\alpha}+\\gamma_{1}^{\\alpha}(\\operatorname{treatment}_{\\operatorname{1}})+\\gamma_{2}^{\\alpha}(\\operatorname{treatment}_{\\operatorname{1}}\\times\\operatorname{wave}),\\sigma^2_{\\alpha_{j}}\\right)\\text{,forsidj=1,}\\dots\\text{,J}\\\\\\alpha_{k}&\\simN\\left(\\mu_{\\alpha_{k}},\\sigma^2_{\\alpha_{k}}\\right)\\text{,forschoolk=1,}\\dots\\text{,K}\\\\\\alpha_{l}&\\simN\\left(\\mu_{\\alpha_{l}},\\sigma^2_{\\alpha_{l}}\\right)\\text{,fordistrictl=1,}\\dots\\text{,L}\\end{aligned}")
  expect_equal(tex_cl_long2, equation_class(actual_cl_long2),
               label = "Cross-level interaction (no random at that level)")
  
  # Multiple cross-level interactions
  cl_long3 <- lmer(score ~ wave*group*treatment + prop_low*treatment*wave +
                  (wave|sid) + (wave|school) +
                  (wave + treatment|district),
                sim_longitudinal)
  tex_cl_long3 <- rm_ws(extract_eq(cl_long3))
  actual_cl_long3 <- rm_ws("\\begin{aligned}\\operatorname{score}_{i}&\\simN\\left(\\alpha_{j[i],k[i],l[i]}+\\beta_{1j[i],k[i],l[i]}(\\operatorname{wave}),\\sigma^2\\right)\\\\\\left(\\begin{array}{c}\\begin{aligned}&\\alpha_{j}\\\\&\\beta_{1j}\\end{aligned}\\end{array}\\right)&\\simN\\left(\\left(\\begin{array}{c}\\begin{aligned}&\\gamma_{0}^{\\alpha}+\\gamma_{1}^{\\alpha}(\\operatorname{group}_{\\operatorname{low}})+\\gamma_{2}^{\\alpha}(\\operatorname{group}_{\\operatorname{medium}})+\\gamma_{3l[i]}^{\\alpha}(\\operatorname{treatment}_{\\operatorname{1}})+\\gamma_{4}^{\\alpha}(\\operatorname{group}_{\\operatorname{low}}\\times\\operatorname{treatment}_{\\operatorname{1}})+\\gamma_{5}^{\\alpha}(\\operatorname{group}_{\\operatorname{medium}}\\times\\operatorname{treatment}_{\\operatorname{1}})\\\\&\\gamma^{\\beta_{1}}_{0}+\\gamma^{\\beta_{1}}_{1}(\\operatorname{group}_{\\operatorname{low}})+\\gamma^{\\beta_{1}}_{2}(\\operatorname{group}_{\\operatorname{medium}})+\\gamma^{\\beta_{1}}_{3}(\\operatorname{treatment}_{\\operatorname{1}})+\\gamma^{\\beta_{1}}_{4}(\\operatorname{group}_{\\operatorname{low}}\\times\\operatorname{treatment}_{\\operatorname{1}})+\\gamma^{\\beta_{1}}_{5}(\\operatorname{group}_{\\operatorname{medium}}\\times\\operatorname{treatment}_{\\operatorname{1}})\\end{aligned}\\end{array}\\right),\\left(\\begin{array}{cc}\\sigma^2_{\\alpha_{j}}&\\rho_{\\alpha_{j}\\beta_{1j}}\\\\\\rho_{\\beta_{1j}\\alpha_{j}}&\\sigma^2_{\\beta_{1j}}\\end{array}\\right)\\right)\\text{,forsidj=1,}\\dots\\text{,J}\\\\\\left(\\begin{array}{c}\\begin{aligned}&\\alpha_{k}\\\\&\\beta_{1k}\\end{aligned}\\end{array}\\right)&\\simN\\left(\\left(\\begin{array}{c}\\begin{aligned}&\\gamma_{0}^{\\alpha}+\\gamma_{1}^{\\alpha}(\\operatorname{prop\\_low})+\\gamma_{2}^{\\alpha}(\\operatorname{prop\\_low}\\times\\operatorname{treatment}_{\\operatorname{1}})\\\\&\\gamma^{\\beta_{1}}_{0}+\\gamma^{\\beta_{1}}_{2}(\\operatorname{prop\\_low})+\\gamma^{\\beta_{1}}_{1}(\\operatorname{prop\\_low}\\times\\operatorname{treatment}_{\\operatorname{1}})\\end{aligned}\\end{array}\\right),\\left(\\begin{array}{cc}\\sigma^2_{\\alpha_{k}}&\\rho_{\\alpha_{k}\\beta_{1k}}\\\\\\rho_{\\beta_{1k}\\alpha_{k}}&\\sigma^2_{\\beta_{1k}}\\end{array}\\right)\\right)\\text{,forschoolk=1,}\\dots\\text{,K}\\\\\\left(\\begin{array}{c}\\begin{aligned}&\\alpha_{l}\\\\&\\beta_{1l}\\\\&\\gamma_{3l}\\end{aligned}\\end{array}\\right)&\\simN\\left(\\left(\\begin{array}{c}\\begin{aligned}&\\mu_{\\alpha_{l}}\\\\&\\mu_{\\beta_{1l}}\\\\&\\mu_{\\gamma_{3l}}\\end{aligned}\\end{array}\\right),\\left(\\begin{array}{ccc}\\sigma^2_{\\alpha_{l}}&\\rho_{\\alpha_{l}\\beta_{1l}}&\\rho_{\\alpha_{l}\\gamma_{3l}}\\\\\\rho_{\\beta_{1l}\\alpha_{l}}&\\sigma^2_{\\beta_{1l}}&\\rho_{\\beta_{1l}\\gamma_{3l}}\\\\\\rho_{\\gamma_{3l}\\alpha_{l}}&\\rho_{\\gamma_{3l}\\beta_{1l}}&\\sigma^2_{\\gamma_{3l}}\\end{array}\\right)\\right)\\text{,fordistrictl=1,}\\dots\\text{,L}\\end{aligned}")
  expect_equal(tex_cl_long3, equation_class(actual_cl_long3),
               label = "Multiple cross-level interactions")
})

# Random effect structures with no covars estimated
test_that("Alternate random effect VCV structures work", {
  hsb_varsonly <- lmer(math ~ minority*female + (minority*female || sch.id),
                       data = hsb)
  tex_hsb_varsonly <- rm_ws(extract_eq(hsb_varsonly))
  actual_hsb_varsonly <- rm_ws("\\begin{aligned}\\operatorname{math}_{i}&\\simN\\left(\\mu,\\sigma^2\\right)\\\\\\mu&=\\alpha_{j[i]}+\\beta_{1j[i]}(\\operatorname{minority})+\\beta_{2j[i]}(\\operatorname{female})+\\beta_{3j[i]}(\\operatorname{female}\\times\\operatorname{minority})\\\\\\left(\\begin{array}{c}\\begin{aligned}&\\alpha_{j}\\\\&\\beta_{1j}\\\\&\\beta_{2j}\\\\&\\beta_{3j}\\end{aligned}\\end{array}\\right)&\\simN\\left(\\left(\\begin{array}{c}\\begin{aligned}&\\mu_{\\alpha_{j}}\\\\&\\mu_{\\beta_{1j}}\\\\&\\mu_{\\beta_{2j}}\\\\&\\mu_{\\beta_{3j}}\\end{aligned}\\end{array}\\right),\\left(\\begin{array}{cccc}\\sigma^2_{\\alpha_{j}}&0&0&0\\\\0&\\sigma^2_{\\beta_{1j}}&0&0\\\\0&0&\\sigma^2_{\\beta_{2j}}&0\\\\0&0&0&\\sigma^2_{\\beta_{3j}}\\end{array}\\right)\\right)\\text{,forsch.idj=1,}\\dots\\text{,J}\\end{aligned}")
  expect_equal(tex_hsb_varsonly, equation_class(actual_hsb_varsonly),
               label = "Variance components only")
  
  suppressWarnings(
    hsb_doublegroup <- lmer(math ~ minority*female + 
                              (minority|sch.id) + (female|sch.id),
                            data = hsb)
  )
  tex_hsb_doublegroup <- rm_ws(extract_eq(hsb_doublegroup))
  actual_hsb_doublegroup <- rm_ws("\\begin{aligned}\\operatorname{math}_{i}&\\simN\\left(\\mu,\\sigma^2\\right)\\\\\\mu&=\\alpha_{j[i],k[i]}+\\beta_{1j[i]}(\\operatorname{minority})+\\beta_{2k[i]}(\\operatorname{female})+\\beta_{3}(\\operatorname{female}\\times\\operatorname{minority})\\\\\\left(\\begin{array}{c}\\begin{aligned}&\\alpha_{j}\\\\&\\beta_{1j}\\end{aligned}\\end{array}\\right)&\\simN\\left(\\left(\\begin{array}{c}\\begin{aligned}&\\mu_{\\alpha_{j}}\\\\&\\mu_{\\beta_{1j}}\\end{aligned}\\end{array}\\right),\\left(\\begin{array}{cc}\\sigma^2_{\\alpha_{j}}&\\rho_{\\alpha_{j}\\beta_{1j}}\\\\\\rho_{\\beta_{1j}\\alpha_{j}}&\\sigma^2_{\\beta_{1j}}\\end{array}\\right)\\right)\\text{,forsch.idj=1,}\\dots\\text{,J}\\\\\\left(\\begin{array}{c}\\begin{aligned}&\\alpha_{k}\\\\&\\beta_{2k}\\end{aligned}\\end{array}\\right)&\\simN\\left(\\left(\\begin{array}{c}\\begin{aligned}&\\mu_{\\alpha_{k}}\\\\&\\mu_{\\beta_{2k}}\\end{aligned}\\end{array}\\right),\\left(\\begin{array}{cc}\\sigma^2_{\\alpha_{k}}&\\rho_{\\alpha_{k}\\beta_{2k}}\\\\\\rho_{\\beta_{2k}\\alpha_{k}}&\\sigma^2_{\\beta_{2k}}\\end{array}\\right)\\right)\\text{,forsch.id.1k=1,}\\dots\\text{,K}\\end{aligned}")
  expect_equal(tex_hsb_doublegroup, equation_class(actual_hsb_doublegroup),
               label = "Double grouping (like cross-classified models)")
  
  
  long_mixed_ranef <- lmer(score ~ wave +
         (wave||sid) + (wave|school) + (1|school) + (wave||district),
         sim_longitudinal)
  tex_long_mixed_ranef <- rm_ws(extract_eq(long_mixed_ranef))
  actual_long_mixed_ranef <- rm_ws("\\begin{aligned}\\operatorname{score}_{i}&\\simN\\left(\\alpha_{j[i],k[i],l[i],m[i]}+\\beta_{1j[i],k[i],m[i]}(\\operatorname{wave}),\\sigma^2\\right)\\\\\\left(\\begin{array}{c}\\begin{aligned}&\\alpha_{j}\\\\&\\beta_{1j}\\end{aligned}\\end{array}\\right)&\\simN\\left(\\left(\\begin{array}{c}\\begin{aligned}&\\mu_{\\alpha_{j}}\\\\&\\mu_{\\beta_{1j}}\\end{aligned}\\end{array}\\right),\\left(\\begin{array}{cc}\\sigma^2_{\\alpha_{j}}&0\\\\0&\\sigma^2_{\\beta_{1j}}\\end{array}\\right)\\right)\\text{,forsidj=1,}\\dots\\text{,J}\\\\\\left(\\begin{array}{c}\\begin{aligned}&\\alpha_{k}\\\\&\\beta_{1k}\\end{aligned}\\end{array}\\right)&\\simN\\left(\\left(\\begin{array}{c}\\begin{aligned}&\\mu_{\\alpha_{k}}\\\\&\\mu_{\\beta_{1k}}\\end{aligned}\\end{array}\\right),\\left(\\begin{array}{cc}\\sigma^2_{\\alpha_{k}}&\\rho_{\\alpha_{k}\\beta_{1k}}\\\\\\rho_{\\beta_{1k}\\alpha_{k}}&\\sigma^2_{\\beta_{1k}}\\end{array}\\right)\\right)\\text{,forschoolk=1,}\\dots\\text{,K}\\\\\\alpha_{l}&\\simN\\left(\\mu_{\\alpha_{l}},\\sigma^2_{\\alpha_{l}}\\right)\\text{,forschool.1l=1,}\\dots\\text{,L}\\\\\\left(\\begin{array}{c}\\begin{aligned}&\\alpha_{m}\\\\&\\beta_{1m}\\end{aligned}\\end{array}\\right)&\\simN\\left(\\left(\\begin{array}{c}\\begin{aligned}&\\mu_{\\alpha_{m}}\\\\&\\mu_{\\beta_{1m}}\\end{aligned}\\end{array}\\right),\\left(\\begin{array}{cc}\\sigma^2_{\\alpha_{m}}&0\\\\0&\\sigma^2_{\\beta_{1m}}\\end{array}\\right)\\right)\\text{,fordistrictm=1,}\\dots\\text{,M}\\end{aligned}")
  expect_equal(tex_long_mixed_ranef, equation_class(actual_long_mixed_ranef),
               label = "Mixed random effect structures at diff levels")
  
})

test_that("Nested model syntax works", {
  expect_warning(
    nested_m1 <- lmer(score ~ 1 + (1|sid/school), sim_longitudinal)
  )
  tex_nested_m1 <- rm_ws(extract_eq(nested_m1))
  actual_nested_m1 <- rm_ws("\\begin{aligned}\\operatorname{score}_{i}&\\simN\\left(\\alpha_{j[i],k[i]},\\sigma^2\\right)\\\\\\alpha_{j}&\\simN\\left(\\mu_{\\alpha_{j}},\\sigma^2_{\\alpha_{j}}\\right)\\text{,forschool:sidj=1,}\\dots\\text{,J}\\\\\\alpha_{k}&\\simN\\left(\\mu_{\\alpha_{k}},\\sigma^2_{\\alpha_{k}}\\right)\\text{,forsidk=1,}\\dots\\text{,K}\\end{aligned}")
  expect_equal(tex_nested_m1, equation_class(actual_nested_m1),
               label = "Nested random effects 1")
  
  expect_warning(
    nested_m2 <- lmer(score ~ 1 + (1|sid/school/district), sim_longitudinal)
  )
  tex_nested_m2 <- rm_ws(extract_eq(nested_m2))
  actual_nested_m2 <- rm_ws("\\begin{aligned}\\operatorname{score}_{i}&\\simN\\left(\\alpha_{j[i],k[i],l[i]},\\sigma^2\\right)\\\\\\alpha_{j}&\\simN\\left(\\mu_{\\alpha_{j}},\\sigma^2_{\\alpha_{j}}\\right)\\text{,fordistrict:(school:sid)j=1,}\\dots\\text{,J}\\\\\\alpha_{k}&\\simN\\left(\\mu_{\\alpha_{k}},\\sigma^2_{\\alpha_{k}}\\right)\\text{,forschool:sidk=1,}\\dots\\text{,K}\\\\\\alpha_{l}&\\simN\\left(\\mu_{\\alpha_{l}},\\sigma^2_{\\alpha_{l}}\\right)\\text{,forsidl=1,}\\dots\\text{,L}\\end{aligned}")
  expect_equal(tex_nested_m2, equation_class(actual_nested_m2),
               label = "Nested random effects 2")
})
