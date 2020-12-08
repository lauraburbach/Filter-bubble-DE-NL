# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
# This file upload all html output to the OSF repository
# Total time taken 8:12 mins

# Setup ----
library(osfr)
library(beepr)
library(rmarkdown)
osf_auth()

## Paramters ----
anon_folder <- "output/anonymized_html/"
normal_folder <- "output/html/"
normal_authors <- list(authors = "Hallo Wir")
anon_params <- list(authors = "Anonymized")

# Remove all html output ----
delfiles <- c(dir(anon_folder, patter = "*.html", full.names = TRUE),
              dir(normal_folder, patter = "*.html", full.names = TRUE))
unlink(delfiles)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
# Render files ----

# Which files to render?
rmds <-
  c(
    "OpenData/10_ParlGov.Rmd"
    #"15_Figure_Hilbert_Order.Rmd",
    #"20_Compare_Performance.Rmd",
    #"30_Spatial_Stability.Rmd",
    #"35_Spatial_Stability_Over_Time.Rmd",
    #"40_Demonstration.Rmd"
  )

# for testing purposes
#rmds  <- c("40_Demonstration.Rmd")

#render files in to versions
for (rmd in rmds) {
  rmarkdown::render(rmd, output_dir = anon_folder, params = anon_params)
  rmarkdown::render(rmd, output_dir = normal_folder, params = normal_authors)
  
}

beep(2)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
# Upload files to OSF ----

# Anonymized folder
node <- osf_retrieve_node("acfdj")
files <- dir(path = anon_folder, pattern = "*.html", full.names = TRUE)
osf_upload(x = node, path = files, progress = TRUE, conflicts = "overwrite")

# Normal folder
node <- osf_retrieve_node("mhsnc")
files <- dir(path = normal_folder, pattern = "*.html", full.names = TRUE)
osf_upload(x = node, path = files, progress = TRUE, conflicts = "overwrite")


beep(2)


message("All done...")

beepr::beep(2)
