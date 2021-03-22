# After bringing all the data into one data frame, we conduct some basic data cleaning.
# This includes removing uncompleted responses, etc.

library(logger)
library(tidyverse)
library(lubridate)
log_info("Cleaning Data...")

dat <- read_rds(here::here("data", "final_data.rds"))


message("There are some rows where the facebook question was unanswered.")
message("However they do provide answers for other facebook related field, we assume 'yes'.")
dat %>% filter(is.na(facebook)) %>% select(facebook, facebook_friends)

dat <- dat %>% 
  mutate(facebook = ifelse(is.na(facebook), "yes", facebook)) 

write_rds(dat, here::here("data", "final_data.rds"))
