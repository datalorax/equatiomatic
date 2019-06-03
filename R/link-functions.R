# link-functions.R

name <- c("logit",
          'inverse',
          '1/mu^2', # inverse gaussian
          'log')

# not sure how to address this one: quasi(link = "identity", variance = "constant")

greek_symbol <- c("log\\left[ \\frac { y }{ 1\\quad -\\quad y }  \\right]",
                  "\\frac { 1 }{ y }",
                  "\\frac { 1 }{ 1/{ \\mu  }^{ 2 } } ", # inverse gaussian - correct?
                  "\\log ( { y )} ") # are the parentheses italicized here?

link_function_frame <- data.frame(name, greek_symbol)

# how to find the link function and distribution family
# counts <- c(18,17,15,20,10,20,25,13,12)
# outcome <- gl(3,1,9)
# treatment <- gl(3,3)
# print(d.AD <- data.frame(treatment, outcome, counts))
# glm.D93 <- glm(counts ~ outcome + treatment, family = poisson())
#
# glm.D93$family$link
# glm.D93$family$family
