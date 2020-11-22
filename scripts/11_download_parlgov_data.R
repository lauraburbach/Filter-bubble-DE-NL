# Collect the data from the OSF Repository
#

library(osfr)
data_folder <- "data"
osf_name <- "vpsxn"
osf_name_anon <- "???????"


# This variable determines whehter unanonymized data should be pulled from 
# a private OSF repository.

author_of_study <- TRUE  ## TODO: SET TO FALSE BEFORE PUBLICATION

if (author_of_study) {
  osf_name <- "vpsxn"
  
  # use this command to edit your .Renviron file
  # usethis::edit_r_environ()
  # add a OSF_PAT=asodkjasldkaslkdjasldkjasd
  # then restart R to init OSF
  osf_auth()
  
  osf_retrieve_file(osf_name) %>% 
    osf_download(path = data_folder, conflicts = "overwrite")
  
} else {
  osf_retrieve_file(osf_name_anon) %>%
    osf_download(path = data_folder, conflicts = "overwrite")
}

# Read in the database

library(RSQLite)
library(tidyverse)
library(DBI)
library(dbplyr)
library(lubridate)

con <- dbConnect(RSQLite::SQLite(), dbname = "data/parlgov-development.db")

con %>% dbListTables()

positions <- tbl(con, "viewcalc_party_position") %>% collect()


tbl(con, "view_election") %>% collect() %>% pull(country_name) %>% unique()


tbl(con, "view_election") %>% collect() %>% 
  mutate(election_date = ymd(election_date)) %>% 
  filter(country_name %in% c("Germany", "France", "Poland", "United Kingdom", "Netherlands")) %>% 
  group_by(country_name, election_date) %>% 
  summarise(lr = mean(vote_share * left_right, na.rm = TRUE),
            lr_split = sd(vote_share / 100 * left_right, na.rm = TRUE)) %>% 
  ggplot() +
  aes(x = election_date) +
  aes(y = lr) +
  aes(size = lr_split) +
  aes(colour = lr_split) +
  aes(group = country_name) +
  geom_point() +
  geom_line(alpha = 0.5) +
  scale_y_continuous(limits = c(0, 100)) +
  scale_x_date() +
  scale_color_viridis_c(option = "B") +
  facet_wrap(~country_name)




tbl(con, "view_election") %>% collect() %>% 
  mutate(election_date = ymd(election_date)) %>% 
  filter(country_name %in% c("Germany", "France", "Poland", "United Kingdom", "Netherlands")) %>% 
  group_by(country_name, election_date) %>% 
  summarise(lr = weighted.mean(left_right, vote_share, na.rm = TRUE),
            lr_split = sqrt(Hmisc::wtd.var(left_right, vote_share, na.rm = TRUE))) %>% 
  ggplot() +
  aes(x = election_date) +
  aes(y = lr) +
  aes(size = lr_split) +
  aes(colour = lr_split) +
  aes(group = country_name) +
  geom_point() +
  geom_line(alpha = 0.5) +
  scale_y_continuous(limits = c(0, 10)) +
  scale_x_date() +
  scale_color_viridis_c(option = "B") +
  facet_wrap(~country_name)




