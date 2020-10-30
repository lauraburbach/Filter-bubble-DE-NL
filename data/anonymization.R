# Anonymization of raw data

library(haven)


raw <- read_sav(here::here("data", "filterbubble.sav"))



# data transformation 
# match scale and constructs

source("data/data_clean.R")



write_sav(here::here("data", "filterbubble_anonymized.sav"))

