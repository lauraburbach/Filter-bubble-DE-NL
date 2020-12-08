#
#
# identify parties of countries with political alignment for all countries
library(logger)
library(tidyverse)
library(lubridate)
log_info("Calculating voting preferences...")


party_raw <- read_rds(here::here("data", "filterbubble_anonymized.rds")) %>% head(100)
party_data <- read_rds(here::here("data", "party_data.rds"))

# Prepare and select voting results
election_dates <- list()
election_dates[["Germany"]] <- ymd("2019-05-26")
election_dates[["Netherlands"]] <- ymd("2019-05-23")
election_dates[["France"]] <- ymd("2019-05-26")
election_dates[["United Kingdom"]] <- ymd("2019-05-23")
election_dates[["Poland"]] <- ymd("2019-05-26")


names(election_dates)
earliest_vote <- min(election_dates %>% unlist() %>% as_date())
latest_vote <- max(election_dates %>% unlist() %>% as_date())


party_data <- party_data %>% filter(country_name %in% names(election_dates)) %>% 
  mutate(election_date = ymd(election_date)) %>% 
  filter(election_date >= earliest_vote) %>% 
  filter(election_type == "ep")



nl_names <- party_raw %>% select(starts_with("VOTE_NL")) %>% names()
de_names <- party_raw %>% select(starts_with("VOTE_DE")) %>% names()


p1 <- party_data %>% filter(country_name == "Netherlands") %>% pull(party_name_short) %>% str_to_lower() %>% sort()
p2 <- nl_names %>% str_remove("vote_NL_") %>% str_to_lower() %>% sort()

p2 %in% p1

p1 <- party_data %>% filter(country_name == "Germany") %>% pull(party_name_short) %>% str_to_lower() %>% sort()
p2 <- de_names %>% str_remove("vote_DE_") %>% str_to_lower() %>% sort()

p2 %in% p1



log_info("Done.")