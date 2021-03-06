# Anonymization of raw data
library(tidyverse)
library(logger)
log_info("Anonymizing data...")


cleaned <- read_rds(file = here::here("data", "clean_unanoymized.rds"))

# remove IP address and timing
cleaned <- cleaned %>% select(-ip_address, date_created, date_modified)


# check free form entries for possible de-anonymization
cleaned %>% select(
  education_NL_other,
  education_DE_other,
  education_UK_other,
  education_FR_other,
  education_PL_other,
  questions_remarks,
  filterbubble_prevention_method,
  vote_NL_other_party,
  vote_DE_other_party,
  vote_UK_other_party,
  vote_FR_other,
  vote_PL_other_party
) %>%
  unite("all", education_NL_other:vote_PL_other_party, sep = "") %>% 
  filter(!all == "") %>% 
  write_excel_csv(here::here("output", "check_anonymity.csv"))


write_rds(file = here::here("data", "filterbubble_anonymized.rds"), x = cleaned)

log_info("Done.")