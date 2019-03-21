# Install all required libraries
install.packages(c("tidyverse", "Hmisc", "apastats", "plotly", "knitr", 
                   "devtools", "purrr", "forcats", "glue", "googledrive",
                   "haven", "here", "apaTables", "xTable", "sjlabelled", 
                   "ggthemes", "esquisse", "ggvis", "sjmisc", "likert"))

# Papaja
# Install devtools package if necessary
if(!"devtools" %in% rownames(installed.packages())) install.packages("devtools")

# Install the stable development verions from GitHub
devtools::install_github("crsh/papaja")

# apa 
devtools::install_github("dgromer/apa")

#apaStats
devtools::install_github('achetverikov/apastats',subdir='apastats')
devtools::install_github("dstanley4/apaTables")

install.packages("sigr")

install.packages("citr")