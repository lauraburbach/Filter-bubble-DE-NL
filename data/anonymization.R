# Anonymization of raw data

library(haven)


raw <- read_sav(here::here("data", "filterbubble.sav"))



# data transformation 
# match scale and constructs

source("data/data_clean.R")



write_rds(file = here::here("data", "filterbubble_anonymized.rds"), x = cleaned)

