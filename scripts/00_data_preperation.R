# This runs all data prep in one file
library(logger)

log_info("Starting Data Preperation")
library(here)
library(tidyverse)

source(here("scripts", "10_download_osf_data.R"))
source("scripts/11_download_parlgov_data.R")
source("scripts/20_data_clean.R")
source("scripts/30_anonymization.R")
source("scripts/40_partyaffiliation_score.R")