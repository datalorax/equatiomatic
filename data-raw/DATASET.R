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
