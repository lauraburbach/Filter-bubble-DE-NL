#
#
# identify parties of countries with political alignment for all countries
library(logger)
library(tidyverse)
library(lubridate)
log_info("Calculating voting preferences...")


party_raw <- read_rds(here::here("data", "filterbubble_anonymized.rds"))  %>% 
  # Duplicate name: SP in poland and Netherlands - SP is meaningless in poland (few election votes, remove?)
  mutate(vote_PL_sp_pol = vote_PL_sp)
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
cat("NL party_name_short:")
party_data %>% filter(country_name == "Netherlands") %>% pull(party_name_short) 
# our data
cat("name_vote")
party_raw %>% select(starts_with("VOTE_NL")) %>% names() %>% str_remove("vote_NL_") 

# output both at the same time for ease of creation
cat("DE party_name_short:")
party_data %>% filter(country_name == "Germany") %>% pull(party_name_short) 
# our data
cat("name_vote")
party_raw %>% select(starts_with("VOTE_DE")) %>% names() %>% str_remove("vote_NL_") 


# output both at the same time for ease of creation
cat("PL party_name_short:")
party_data %>% filter(country_name == "Poland") %>% pull(party_name_short) 

# our data
cat("name_vote")
party_raw %>% select(starts_with("VOTE_PL")) %>% names() %>% str_remove("vote_PL_") 

# output both at the same time for ease of creation
cat("FR party_name_short:")
party_data %>% filter(country_name == "France") %>% pull(party_name_short) 
# our data
cat("name_vote")
party_raw %>% select(starts_with("VOTE_FR")) %>% names() %>% str_remove("vote_NL_") 

# output both at the same time for ease of creation
cat("UK party_name_short:")
party_data %>% filter(country_name == "United Kingdom") %>% pull(party_name_short) 
# our data
cat("name_vote")
party_raw %>% select(starts_with("VOTE_UK")) %>% names() %>% str_remove("vote_NL_") 


party_raw %>% select(starts_with("vote_PL")) %>% labelled::var_label()



mapping <- tribble(
  ~name_vote, ~party_name_short,
  # Netherlands
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
  # Germany
  "cdu", "CDU",
  "csu", "CSU",
  "spd", "SPD",
  "fdp", "FDP",
  "gruen", "B90/Gru",
  "afd", "AfD", 
  "linke", "PDS|Li",
  "piratenpartei", "Pi",
  # Poland
  "pis", "PiS",
  "po", "PO",
  "wio", "WIO",
  "k", "K",
  "razem", "Razem",
  "korwin", "KORWIN",
  #"sp_pol", "SP",
  #"sld", "WIO" und "Razem",
  # France
  "fi", "FI",
  "pcf", "PCF",
  "eelv", "V",
  "ps", "PS",
  "lrem", "REM",
  #"modem", "",
  "lr", "UMP|LR",
  "dlf", "DLR|DLF",
  "fn",  "FN",
  # UK
  "con", "Con",
  "lab", "Lab",
  "ld", "Lib",
  "ind", "CUK",
  #"cl", "" # classic liberals ?
   "grn", "GP",
  "inp", "SF",
  #"lole", ""  # loyalist league
  #"lp", "" #liberterian party
  # "nb", "" #new britain
  #"pap", # peoples action party (singapore?=)
  "pc", "Plaid",
  #"ukf", 
  "brexit", "BP",
  "scottish", "SNP",
  "ukip", "UKIP"
   
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
  #other values to lower case to simplify identifcation
  mutate(temp = str_to_lower(labelled::to_character(vote_PL_other_party))) %>% 
  mutate(temp_vote = labelled::to_character(vote_PL_other_party_value)) %>% 
  # WIOSNA
  mutate(vote_PL_wio = case_when(str_detect(temp,"wiosna") ~ temp_vote,
                                  TRUE ~ "")) %>%
#  mutate(vote_PL_wio = as.factor(vote_PL_wio)) %>% 
  relocate(vote_PL_wio, .after = vote_PL_wis) %>% 
  # K
  mutate(vote_PL_k = case_when(str_detect(temp, "kukiz 15") ~ temp_vote,
                                 TRUE ~ "")) %>%
 # mutate(vote_PL_k = as.factor(vote_PL_k)) %>% 
  relocate(vote_PL_k, .after = vote_PL_wis) %>% 
  # Razem
  mutate(vote_PL_razem = case_when(str_detect(temp, "razem") ~ temp_vote,
                               TRUE ~ "")) %>%
  #mutate(vote_PL_razem = as.factor(vote_PL_razem)) %>% 
  relocate(vote_PL_razem, .after = vote_PL_wis) %>% 
  # Korwin
  mutate(vote_PL_korwin = case_when(str_detect(temp, "korwin") ~ temp_vote,
                               TRUE ~ "")) %>%
  #mutate(vote_PL_korwin = as.factor(vote_PL_korwin)) %>% 
  relocate(vote_PL_korwin, .after = vote_PL_wis) %>% 
  select(-temp, -temp_vote) %>% 
  # UK missing parties
  mutate(temp = str_to_lower(labelled::to_character(vote_UK_other_party))) %>% 
  mutate(temp_vote = labelled::to_character(vote_UK_other_party_value)) %>% 
  mutate(vote_UK_brexit = case_when((temp %in% c("brexit", "brexit party", "brixit party", "brixit" )) ~ temp_vote,
                                   TRUE ~ "")) %>%
  relocate(vote_UK_brexit, .after = vote_UK_ukf) %>% 
  mutate(vote_UK_scottish = case_when(str_detect(temp,"snp") ~ temp_vote,
                                    TRUE ~ "")) %>%
  relocate(vote_UK_scottish, .after = vote_UK_brexit) %>% 
  mutate(vote_UK_ukip = case_when(str_detect(temp, c("ukip")) ~ temp_vote,
                                      TRUE ~ "")) %>%
  #mutate(vote_PL_razem = as.factor(vote_PL_razem)) %>% 
  relocate(vote_UK_ukip, .after = vote_UK_scottish) %>% 
  # chante all votes to characters
  mutate_at(vars(vote_NL_cda:vote_NL_piratenpartij, 
                 vote_DE_cdu:vote_DE_npd, 
                 vote_PL_pis:vote_PL_korwin, 
                 vote_FR_fi:vote_FR_fn,
                 vote_UK_con:vote_UK_ukip), labelled::to_character) %>% 
  # pivot all parties
  pivot_longer(
  cols = c(vote_NL_cda:vote_NL_piratenpartij, 
           vote_DE_cdu:vote_DE_npd, 
           vote_PL_pis:vote_PL_korwin,
           vote_FR_fi:vote_FR_fn,
           vote_UK_con:vote_UK_ukip), 
  names_to = c("name_vote"), 
  names_prefix = "vote_",
  values_to = "value_vote") %>% 
  # remove country
  mutate(name_vote = str_sub(name_vote, 4)) %>%
  left_join(mapping) %>% 
  left_join(party_data) ->
  partys_mapped



# This gives us the ranges of potentially votable parties for each user and their LR placements
partys_mapped %>% filter(value_vote == "would vote for" | value_vote == "would potentially vote for") %>% 
  group_by(respondent_id) %>% 
  summarize(lrm = mean(left_right, na.rm = TRUE),
            lrsd = sd(left_right, na.rm = TRUE)) -> lrmeans





# TODO: get labels from vote_PL, vote_NL, vote_UK, vote_FR
# then compare to party_data, shortnames and create mapping

# Who do they plan to vote for? ----
party_raw %>% select(vote_UK) %>% labelled::val_labels()
# Now we map the real votes
mapping <- tribble(
  ~name_vote, ~party_name_short,
  #Netherlands
  "CDA", "CDA",
  "CU", "CU",
  "D66", "D66",
  "GL", "GL",
  "PvdA", "PvdA",
  "PvdD", "PvdD",
  "PVV", "PVV",
  "SGP", "", 
  "SP", "SP",
  "VVD", "VVD",
  "50+", "50+",
  "Denk", "DENK",
  "FVD", "FvD",
  "Piratenpartij", "",
  # Es gibt noch: VN

  #Germany
  "cdu", "CDU",
  "csu", "CSU",
  "spd", "SPD",
  "fdp", "FDP",
  "bündnis 90/die grünen", "B90/Gru",
  "afd", "AfD",
  "die linke", "PDS|Li",
  "piratenpartei", "Pi",
  "die partei", "PARTEI",
  "freie wähler", "FW", #TODO: hier müssen die Parteien rein, links so wie wir sie genannt haben (party_raw %>% select(vote_PL) so sind die Daten, wie wir sie genannt haben) und rechts so wie in party_data (im Datensatz nachsehen)
  
  # Poland
  "Prawo i Sprawiedliwość (PiS)", "PiS",
  "Platforma Obywatelska (PO)", "PO",
  "Polskie Stronnictwo Ludowe (PSL)", "",
  "Solidarna Polska (SP)", "",
  "Sojusz Lewicy Demokratycznej (SLD)", "", 
  "Ruch Narodowy (RN)", "",
  "Wolni i Solidarni (WiS)", "",
  "Unia Pracy (UP)", "",
  "Biało-Czerwoni (BC)", "",
  "Wiosna", "WIO",
  "Kukiz 15", "K",
  "Razem", "Razem",
  #WIOSNA
  
  # France
  "La France insoumise (FI)", "FI",
  "Parti communiste francais (PCF)", "PCF",
  "Europe Écologie-Les Verts (EELV)", "V",
  "Parti socialiste (PS)", "PS",
  "La République En Marche (LREM", "REM",
  "Mouvement démocrate (MoDem)", "REM",
  "Les Républicains (LR)", "UMP|LR", # Hier nochmal nachsehen, ob so oder nur LR
  "Debout la France (DLF)", "DLR|DLF", # nachsehen
  "Front National (FN)", "FN",
  "PA", "PA",
  "Gs", "Gs",
  # gibt noch ein paar mehr
  
  # UK
  "Conservative and Unionist Party", "Con", # in Liste als Conservatives angegeben 
  "Labour Party", "Lab",
  "Liberal Democrats", "Lib", #Alliance Party of Northern Ireland; In der britischen Politik orientiert sich die Partei an den Liberal Democrats
  "Change UK - The Independent Group", "CUK",
  "Classic Liberals", "APoNI", # in Liste als Liberals angegeben
  "Green Party", "GP", 
  "Irish National Party", "SF", #? die einzige politische Partei, die sowohl im Norden als auch im Süden Irlands bedeutend aktiv ist
  "Loyalist League", "",
  "Libertarian Party UK", "",
  "New Britain", "",
  "Peoples Action Party", "",
  "Plaid Cymru", "Plaid",
  "UK First", "BP",       # Das ist wohl etwas weit hergeholt.
)


# CONVERT MISSING VOTES FROM OTHER----

# helpers
nop <- function(x)x
simpleString <- function(x) {
  x %>% str_to_lower() %>% 
    str_replace_all("[[:space:]]", "") %>% 
    str_replace_all(",|\\.|\\?", "") %>% 
    stringi::stri_trans_general("Latin-ASCII")
}

# Find Missing PL Party Wiosna  
wiosna_voters <- party_raw %>% filter(str_detect(tolower(vote_PL_other), "wiosna")) %>% pull(respondent_id)

# Add missing Party labels
party_votes_fixed <- party_raw %>% 
  #filter(!is.na(vote_PL)) %>% 
  #select(vote_PL) %>% 
  mutate(vote_PL = labelled::to_character(vote_PL)) %>%  # chagen PL
  mutate(vote_PL = ifelse(str_detect(simpleString(vote_PL_other), "wiosna"),
                          "Wiosna",
                          vote_PL)) %>% 
  mutate(vote_PL = ifelse(str_detect(simpleString(vote_PL_other), "kukiz15"),
                          "Kukiz 15",
                          vote_PL))  %>%
  mutate(vote_PL = ifelse(str_detect(simpleString(vote_PL_other), "razem"),
                          "Razem",
                          vote_PL))  %>%  
  mutate(vote_PL = factor(vote_PL)) %>% 
  mutate(vote_DE = labelled::to_character(vote_DE)) %>%    # change DE
  mutate(vote_DE = ifelse(str_detect(simpleString(vote_DE_other), "diepartei"),
                          "Die Partei",
                          vote_DE)) %>% 
  mutate(vote_DE = ifelse(str_detect(simpleString(vote_DE_other), "freiewahler"),
                          "Freie Wähler",
                          vote_DE)) %>% 
  mutate(vote_DE = factor(vote_DE)) %>% 
  mutate(vote_FR = labelled::to_character(vote_FR)) %>%  # change FR
  mutate(vote_FR = ifelse(str_detect(simpleString(vote_FR_other), "partianimaliste"),
                          "PA",
                          vote_FR)) %>% 
  mutate(vote_FR = ifelse(str_detect(simpleString(vote_FR_other), "generations"),
                          "Gs",
                          vote_FR)) %>% 
  mutate(vote_FR = ifelse(str_detect(simpleString(vote_FR_other), "generation(s)"),
                          "Gs",
                          vote_FR)) %>% 
  mutate(vote_FR = factor(vote_FR)) 
  #%>%   group_by(vote_PL) %>% count()


## VERIFY OUR VOTING COUNTS ----

# Check the original vote 
party_data %>% 
  filter(country_name %in% c("France", "Germany", "Netherlands", "Poland","United Kingdom")) %>%
  group_by(country_name) %>% 
  summarise(vote_share = sum(vote_share))

# Check whether our mapping reaches similar vote coverage
# this measures the total share of votes covered in our survey

mapping %>% 
  inner_join(party_data) %>% 
  group_by(country_name) %>% 
  summarise(vote_share = sum(vote_share))



# Step 1: What vote share is missing?
party_data %>% 
  left_join(mapping) %>%
  filter(is.na(name_vote)) %>% 
  arrange(desc(vote_share)) %>% 
  filter(country_name_short == "POL") %>% 
  head(15) %>% 
  nop()


# Can we find it in the other party?
party_votes_fixed %>% 
  mutate(name_vote = simpleString(labelled::to_character(vote_PL_other))) %>%  # fix country here if necessary
  group_by(name_vote) %>% 
  summarise(n = n()) %>% 
  arrange(desc(n)) %>% head(20)
#if yes fix where party_votes_fixed is created
# fixed: PL: Wiosna, kukiz15

# find votes per party in our data
party_votes_fixed %>% 
  mutate(name_vote = str_to_lower(labelled::to_character(vote_PL))) %>% 
  group_by(name_vote) %>% 
  summarise(n = n()) %>% 
  na.omit() %>% 
  ungroup() %>% 
  mutate(perc = n / sum(n)) %>% 
  arrange(desc(n))


party_votes_fixed %>% 
  select(-starts_with("vote_DE_")) %>% 
  select(-starts_with("vote_UK_")) %>% 
  select(-starts_with("vote_NL_")) %>% 
  select(-starts_with("vote_PL_")) %>% 
  select(-starts_with("vote_FR_")) %>% 
  left_join(lrmeans) %>% 
  mutate(name_vote = str_to_lower(labelled::to_character(vote_DE))) %>% 
  left_join(mapping)  %>% 
  left_join(party_data) -> lrvergleich



# Get actual vote + LR Rating

# Compare voting results in reality with our group

party_votes_fixed %>% 
  filter(nationality == "France") %>% 
  filter(!(vote_FR == "other (please specify)")) %>% 
  mutate(name_vote = str_to_lower(labelled::to_character(vote_FR))) %>% 
  group_by(name_vote) %>% 
  summarise(n = n()) %>% 
  na.omit() %>% 
  ungroup() %>% 
  mutate(perc = n / sum(n)) %>% 
  arrange(desc(n)) %>% 
  left_join(mapping %>% mutate(name_vote = str_to_lower(name_vote))) %>% 
  left_join(party_data %>% select(party_name_short, vote_share, party_name)) %>% 
  mutate(vote_share = vote_share/100) %>% 
  pivot_longer(cols = c(perc, vote_share)) %>% 
  ggplot() +
  aes(x = fct_reorder(party_name, value), y = value, fill = name) +
  geom_col(position = "dodge") +
  coord_flip() +
  scale_y_continuous(label = scales::percent_format(accuracy = 1)) +
  labs(x = NULL, y = "Percent")


party_votes_fixed %>% 
  filter(nationality == "Germany") %>% 
  filter(!(vote_DE == "other (please specifiy)")) %>% 
  filter(!(vote_DE == "NPD")) %>% 
  mutate(name_vote = str_to_lower(labelled::to_character(vote_DE))) %>% 
  group_by(name_vote) %>% 
  summarise(n = n()) %>% 
  na.omit() %>% 
  ungroup() %>% 
  mutate(perc = n / sum(n)) %>% 
  arrange(desc(n)) %>% 
  left_join(mapping %>% mutate(name_vote = str_to_lower(name_vote))) %>% 
  left_join(party_data %>% select(party_name_short, vote_share, party_name)) %>% 
  mutate(vote_share = vote_share/100) %>% 
  pivot_longer(cols = c(perc, vote_share)) %>% 
  ggplot() +
  aes(x = fct_reorder(party_name, value), y = value, fill = name) +
  geom_col(position = "dodge") +
  coord_flip() +
  scale_y_continuous(label = scales::percent_format(accuracy = 1)) +
  labs(x = NULL, y = "Percent")  


party_votes_fixed %>% 
  filter(nationality == "Netherlands") %>%  
  mutate(name_vote = str_to_lower(labelled::to_character(vote_NL))) %>% 
  filter(!(name_vote == "other (please specifiy)")) %>% 
  filter(!(name_vote == "piratenpartij")) %>% 
  group_by(name_vote) %>% 
  summarise(n = n()) %>% 
  na.omit() %>% 
  ungroup() %>% 
  mutate(perc = n / sum(n)) %>% 
  arrange(desc(n)) %>% 
  left_join(mapping %>% mutate(name_vote = str_to_lower(name_vote))) %>% 
  left_join(party_data %>% select(party_name_short, vote_share, party_name)) %>% 
  mutate(vote_share = vote_share/100) %>% 
  pivot_longer(cols = c(perc, vote_share)) %>% 
  ggplot() +
  aes(x = fct_reorder(party_name, value), y = value, fill = name) +
  geom_col(position = "dodge") +
  coord_flip() +
  scale_y_continuous(label = scales::percent_format(accuracy = 1)) +
  labs(x = NULL, y = "Percent")  


party_votes_fixed %>% 
  filter(nationality == "UK") %>%  
  mutate(name_vote = str_to_lower(labelled::to_character(vote_UK))) %>% 
  filter(!(name_vote == "other (please specifiy)")) %>% 
  filter(!(name_vote == "new britain")) %>% 
  filter(!(name_vote == "peoples action party")) %>% 
  group_by(name_vote) %>% 
  summarise(n = n()) %>% 
  na.omit() %>% 
  ungroup() %>% 
  mutate(perc = n / sum(n)) %>% 
  arrange(desc(n)) %>% 
  left_join(mapping %>% mutate(name_vote = str_to_lower(name_vote))) %>% 
  left_join(party_data %>% select(party_name_short, vote_share, party_name)) %>% 
  mutate(actual_vote = vote_share/100) %>% 
  pivot_longer(cols = c(perc, actual_vote)) %>% 
  ggplot() +
  aes(x = fct_reorder(party_name, value), y = value, fill = name) +
  geom_col(position = "dodge") +
  coord_flip() +
  scale_y_continuous(label = scales::percent_format(accuracy = 1)) +
  labs(x = NULL, y = "Percent")  


party_votes_fixed %>% 
  filter(nationality == "Poland") %>%  
  mutate(name_vote = str_to_lower(labelled::to_character(vote_PL))) %>% 
  filter(!(name_vote == "other (please specifiy)")) %>% 
  filter(!(name_vote == "sojusz lewicy demokratycznej (sld)")) %>% # Parties we asked for that we don't see data in reality, damn
  filter(!(name_vote == "polskie stronnictwo ludowe (psl)")) %>% 
  filter(!(name_vote == "ruch narodowy (rn)")) %>% 
  filter(!(name_vote == "unia pracy (up)")) %>% 
  filter(!(name_vote == "solidarna polska (sp)")) %>% 
  filter(!(name_vote == "biało-czerwoni (bc)")) %>% 
  filter(!(name_vote == "wolni i solidarni (wis)")) %>% 
  group_by(name_vote) %>% 
  summarise(n = n()) %>% 
  na.omit() %>% 
  ungroup() %>% 
  mutate(perc = n / sum(n)) %>% 
  arrange(desc(n)) %>% 
  left_join(mapping %>% mutate(name_vote = str_to_lower(name_vote))) %>% 
  left_join(party_data %>% select(party_name_short, vote_share, party_name)) %>% 
  mutate(actual_vote = vote_share/100) %>% 
  pivot_longer(cols = c(perc, actual_vote)) %>% 
  ggplot() +
  aes(x = fct_reorder(party_name, value), y = value, fill = name) +
  geom_col(position = "dodge") +
  coord_flip() +
  scale_y_continuous(label = scales::percent_format(accuracy = 1)) +
  labs(x = NULL, y = "Percent")  




log_info("Done.")
