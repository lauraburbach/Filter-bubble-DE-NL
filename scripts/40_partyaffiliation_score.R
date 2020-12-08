#
#
# identify parties of countries with political alignment for all countries
library(logger)
library(tidyverse)
log_info("Calculating voting preferences...")


party_raw <- read_rds(here::here("data", "filterbubble_anonymized.rds"))
party_data <- read_rds(here::here("data", "party_data.rds"))

cleaned4 %>% select(starts_with("VOTE_NL")) %>% to_factor()



log_info("Done.")