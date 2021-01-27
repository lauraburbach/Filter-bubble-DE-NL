# Collect the data from the OSF Repository
#
library(logger)
library(tidyverse)
log_info("Downloading ParlGov Data...")

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



# ----- CONVERT SQLITE TO RDS ------

library(RSQLite)
library(DBI)
library(dbplyr)
library(lubridate)

con <- dbConnect(RSQLite::SQLite(), dbname = here::here("data","parlgov-development.db"))

#con %>% dbListTables()
positions <- tbl(con, "viewcalc_party_position") %>% collect()
elections <- tbl(con, "view_election") %>% collect()

party_data <- elections %>% left_join(positions) 

# Cleaning code? 

write_rds(here("data", "party_data.rds"), x = party_data)

dbDisconnect(con)


log_info("Done.")
