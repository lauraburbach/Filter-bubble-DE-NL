# Anonymization of raw data

library(haven)


raw <- read_sav(here::here("data", "filterbubble.sav"))



# data transformation 
# match scale and constructs

source("data/data_clean.R")


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
  View()


write_rds(file = here::here("data", "filterbubble_anonymized.rds"), x = cleaned)




print(names(cleaned))
