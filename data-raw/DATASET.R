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
