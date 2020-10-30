# Collect the data from the OSF Repository
#



library(osfr)
data_folder <- "data"
osf_name <- "j4gtz"
osf_name_anon <- "???????"


# This variable determines whehter unanonymized data should be pulled from 
# a private OSF repository.

author_of_study <- TRUE  ## TODO: SET TO FALSE BEFORE PUBLICATION

if (author_of_study) {
  osf_name <- "j4gtz"
  
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
