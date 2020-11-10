# Install all required libraries

# Do not run, we haved switched to RENV. This file is solely a reminder what we use

if (FALSE) {
  install.packages(
    c(
      "tidyverse",
      "remotes",
      "Hmisc",
      "knitr",
      "glue",
      "osfr",
      "here",
      "apaTables",
      "sjlabelled",
      "ggvis",
      "sjmisc",
      "likert",
      "seminr"
    )
  )
  
  # Papaja
  # Install remotes package if necessary
  if (!"remotes" %in% rownames(installed.packages()))
    install.packages("remotes")
  
  # Install the stable development verions from GitHub
  remotes::install_github("crsh/papaja")
  
  # apa
  remotes::install_github("dgromer/apa")
  
  #apaStats
  remotes::install_github('achetverikov/apastats', subdir = 'apastats')
  remotes::install_github("dstanley4/apaTables")
  
  install.packages("sigr")
  
  install.packages("citr")
  
  
}