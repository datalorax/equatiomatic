# link-functions.R

link_name <- c("logit",
               'inverse',
               # '1/mu^2', # inverse gaussian; removed until we're certain
               'log',
               'identity') # this isn't necessary as extract_eq() does this by default

# not sure how to address this one: quasi(link = "identity", variance = "constant")

link_formula <- c("log\\left[ \\frac { P( y ) }{ 1 - P( y ) }  \\right]",
                  "\\frac { 1 }{ P( y ) }",
                  # "\\frac { 1 }{ 1/{ y }^{ 2 } } ", # inverse gaussian - correct?
                  "\\log ( { y )} ",
                  "y") # are the parentheses italicized here?

link_function_df <- data.frame(link_name, link_formula,
                               stringsAsFactors = FALSE)

# how to find the link function and distribution family
# counts <- c(18,17,15,20,10,20,25,13,12)
# outcome <- gl(3,1,9)
# treatment <- gl(3,3)
# print(d.AD <- data.frame(treatment, outcome, counts))
# glm.D93 <- glm(counts ~ outcome + treatment, family = poisson())
#
# glm.D93$family$link
# glm.D93$family$family
