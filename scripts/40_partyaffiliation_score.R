#
#
# identify parties of countries with political alignment for all countries
library(logger)
library(tidyverse)
library(lubridate)
log_info("Calculating voting preferences...")


party_raw <- read_rds(here::here("data", "filterbubble_anonymized.rds")) 
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
pl_names <- party_raw %>% select(starts_with("VOTE_PL")) %>% names()
fr_names <- party_raw %>% select(starts_with("VOTE_FR")) %>% names()
uk_names <- party_raw %>% select(starts_with("VOTE_UK")) %>% names()



# We need to merge data regarding parties from two data.frames
# NL DATA ---- 
#govparl data
# Needs manual mapping
# output both at the same time for ease of creation
cat("party_name_short:")
party_data %>% filter(country_name == "Netherlands") %>% pull(party_name_short) 
# our data
cat("name_vote")
party_raw %>% select(starts_with("VOTE_NL")) %>% names() %>% str_remove("vote_NL_") 

# output both at the same time for ease of creation
cat("party_name_short:")
party_data %>% filter(country_name == "Germany") %>% pull(party_name_short) 
# our data
cat("name_vote")
party_raw %>% select(starts_with("VOTE_DE")) %>% names() %>% str_remove("vote_NL_") 


# output both at the same time for ease of creation
cat("party_name_short:")
party_data %>% filter(country_name == "Poland") %>% pull(party_name_short) 
# our data
cat("name_vote")
party_raw %>% select(starts_with("VOTE_PL")) %>% names() %>% str_remove("vote_PL_") 

# output both at the same time for ease of creation
cat("party_name_short:")
party_data %>% filter(country_name == "France") %>% pull(party_name_short) 
# our data
cat("name_vote")
party_raw %>% select(starts_with("VOTE_FR")) %>% names() %>% str_remove("vote_NL_") 

# output both at the same time for ease of creation
cat("party_name_short:")
party_data %>% filter(country_name == "United Kingdom") %>% pull(party_name_short) 
# our data
cat("name_vote")
party_raw %>% select(starts_with("VOTE_UK")) %>% names() %>% str_remove("vote_NL_") 

party_raw %>% select(starts_with("vote_PL")) %>% labelled::var_label()



mapping <- tribble(
  ~name_vote, ~party_name_short,
  "50plus",   "50+",
  "cda",   "CDA",
  "cu",   "CU",
  "d66", "D66",
  "gl", "GL",
  "pvda", "PvdA",
  "pvdd", "PvdD",
  "pvv", "PVV",
  "sp", "SP",
  "vdd", "VDD",
  "denk", "DENK",
  "fvd", "FvD",
  "cdu", "CDU",
  "csu", "CSU",
  "spd", "SPD",
  "fdp", "FDP",
  "gruen", "B90/Gru",
  "afd", "AfD", 
  "linke", "PDS|Li",
  "piratenpartei", "Pi",
  "pis", "PiS",
  "po", "PO"
  #"sld", "WIO" und "Razem",
  # add newly created columns
  
)


# Since we had not used the correct party selection in the survey, 
# we manually map the field "other party"
# to a column that represents their value
# Luckily we asked for other parties, as well as their evaluation

# WIOSNA
# K 
# RAZEM
# KORWN
party_raw %>% 
  mutate(temp = str_to_lower(labelled::to_character(vote_PL_other_party))) %>% 
  mutate(temp_vote = labelled::to_character(vote_PL_other_party_value)) %>% 
  # WIOSNA
  mutate(vote_PL_wio = case_when((temp == "wiosna") ~ temp_vote,
                                  TRUE ~ "")) %>%
#  mutate(vote_PL_wio = as.factor(vote_PL_wio)) %>% 
  relocate(vote_PL_wio, .after = vote_PL_wis) %>% 
  # K
  mutate(vote_PL_k = case_when((temp == "kukiz 15") ~ temp_vote,
                                 TRUE ~ "")) %>%
 # mutate(vote_PL_k = as.factor(vote_PL_k)) %>% 
  relocate(vote_PL_k, .after = vote_PL_wis) %>% 
  # Razem
  mutate(vote_PL_razem = case_when((temp == "razem") ~ temp_vote,
                               TRUE ~ "")) %>%
  #mutate(vote_PL_razem = as.factor(vote_PL_razem)) %>% 
  relocate(vote_PL_razem, .after = vote_PL_wis) %>% 
  # Korwin
  mutate(vote_PL_korwin = case_when((temp == "kukiz 15") ~ temp_vote,
                               TRUE ~ "")) %>%
  #mutate(vote_PL_korwin = as.factor(vote_PL_korwin)) %>% 
  relocate(vote_PL_korwin, .after = vote_PL_wis) %>% 
  select(-temp, -temp_vote) %>% 
  mutate_at(vars(vote_NL_cda:vote_NL_piratenpartij, vote_DE_cdu:vote_DE_npd, vote_PL_pis:vote_PL_korwin), labelled::to_character) %>% 
  pivot_longer(
  cols = c(vote_NL_cda:vote_NL_piratenpartij, vote_DE_cdu:vote_DE_npd, vote_PL_pis:vote_PL_korwin), 
  names_to = c("name_vote"), 
  names_prefix = "vote_",
  values_to = "value_vote") %>% 
  mutate(name_vote = str_sub(name_vote, 4)) %>%
  left_join(mapping) %>% 
  left_join(party_data) %>% View()

# TODO

# Duplicate name: SP in poland and Netherlands - SP is meaningless in poland (few election votes, remove?)



log_info("Done.")