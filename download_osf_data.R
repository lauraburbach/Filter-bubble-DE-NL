# Collect the data from the OSF Repository

library(osfr)
data_folder <- "data"
osf_name <- "j4gtz"

# use this command to edit your .Renviron file
# usethis::edit_r_environ(  )
# add a OSF_PAT=asodkjasldkaslkdjasldkjasd
# then restart R to init OSF
osfr::osf_auth()

osfr::osf_retrieve_file(osf_name) %>% osf_download(path = data_folder, conflicts = "overwrite")

