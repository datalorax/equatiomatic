## code to prepare `DATASET` dataset goes here
polls <- rio::import(here::here("data-raw", "polls.dta"),
                     setclass = "tbl_df")
polls <- dplyr::select(polls, state:weight, bush)
polls <- dplyr::mutate(polls, 
                       edu = factor(edu,
                                    levels = 1:4,
                                    labels = c("No High School",
                                               "High School Grad",
                                               "Some College",
                                               "College Grad"),
                                    ordered = TRUE),
                       age = factor(age,
                                    levels = 1:4,
                                    labels = c("18-29", "30-44",
                                               "45-64", "65+")))

usethis::use_data(polls, overwrite = TRUE)

###
arrests <- readr::read_delim("http://www.stat.columbia.edu/~gelman/arm/examples/police/frisk_with_noise.dat",
                             skip = 6,
                             delim = " ")

library(tidyverse)
arrests <- arrests %>% 
  group_by(precinct, eth) %>% 
  summarize(stops = sum(stops),
            arrests = sum(past.arrests)) %>% 
  mutate(eth = factor(eth,
                      levels = 1:3,
                      labels = c("black", "hispanic", "white")))

usethis::use_data(arrests, overwrite = TRUE)

library(tidyverse)
library(lme4)
library(equatiomatic)

#make some fake data
(
  expand_grid(
    session = factor(c(1,2))
    , task = factor(c('n','x'))
    , warning = factor(c('lo','hi'))
    , cuing = factor(c('invalid','valid'))
    , trial = 1:2
    , id = factor(1:2)
  )
) -> test_data

#set contrasts
contrasts(test_data$warning) = contr.sum
contrasts(test_data$cuing) = contr.sum

# specify the contrast matrix
(
  test_data
  %>% ungroup()
  %>% mutate(
    obs_row = 1:n()
  )
  %>% group_by(session,task)
  %>% group_modify(
    .f = function(x,y){
      (
        x
        #get the contrast matrix (wrapper on stats::model.matrix)
        %>% model.matrix(
          object = ~ (warning+cuing)
        )
        #convert to tibble
        %>% as_tibble(.name_repair='unique')
        %>% rename(intercept=`(Intercept)`)
      ) -> out
      names(out) = paste0(paste0(y$task[1],y$session[1]),'_',names(out))
      out$obs_row = x$obs_row
      return(out)
    }
  )
  %>% mutate(
    across(everything(), ~replace_na(.x, 0))
  )
  %>% ungroup()
  %>% arrange(obs_row)
  %>% select(-obs_row,-session,-task)
) -> W

(test_data
  %>% dplyr::ungroup()
  %>% dplyr::select(id)
  %>% dplyr::mutate(
    rt = rnorm(n())
  )
  %>% bind_cols(W)
) -> test_data 

usethis::use_data(test_data, internal = TRUE, overwrite = TRUE)
