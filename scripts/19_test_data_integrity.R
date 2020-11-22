# This file should verify that no mistakes have happend in preparing the data in SPSS


library(testthat)
library(tidyverse)
library(haven)
library(glue)



raw <- read_sav(here::here("data", "filterbubble.sav"))


raw$education_PL %>% unique()

# Write test for individual columns, add as necessary
# Test factor levels example

levels_edu_PL <- c(
  "bez wykształcenia",
  "podstawowe",
  "gimnayjalne",
  "zawodowe",
  "średnie (techniczne)",
  "średnie (policealne)",
  "licencjat/inzynier",
  "magister",
  "tytuł doktora",
  "other (please specify)"
)

testthat::expect_true( all.equal(raw$education_PL %>% 
                          as_factor() %>% 
                          get_labels(), 
                          levels_edu_PL) )


# Test that only one education column is filled

# function to test whether a column name contains a string and not another
select_not <- function(df, searchstring, exclusion_string = "_other") {
  names(df) %>% as_tibble() %>% 
    filter(str_starts(value, searchstring)) %>% 
    filter(!str_detect(value, exclusion_string)) %>% 
    pull(value)
  
    }

# function that test, whether all supplied columns are only filled once
check_no_multiple_column_entries <- function(df, selector) {
  df %>% unite(tmp, selector, na.rm = TRUE, remove = TRUE, sep = "@") %>% 
    pull(tmp) %>% 
    str_detect("@") %>% 
    any()
}

expect_false( check_no_multiple_column_entries(raw, select_not(raw, "education")) )



###

check_vote_fields <- function(df, prefix1, prefix2) {
  res <- NULL
  try(
  df %>% 
    select(-contains("other")) %>% 
    pivot_longer(cols = (starts_with(prefix1)), names_to = "name1", values_to = "value1")  %>% 
    pivot_longer(cols = (starts_with(prefix2)), names_to = "name2", values_to = "value2")  %>% 
    select(value1, value2) %>% 
    na.omit() %>% 
    nrow() %>% 
  expect_equal(0) -> res
  )
  
  res
}

vote_fields <- c("vote_UK", "vote_DE", "vote_PL", "vote_FR", "vote_NL")

all_combinations <- expand.grid(vote_fields, vote_fields) %>% filter(!Var1 == Var2) %>% mutate_all(as.character)

error_idx <- NULL
for (i in 1:nrow(all_combinations)) {
  error_idx <- i
  v1 <- as.character(all_combinations[i,]$Var1)
  v2 <- as.character(all_combinations[i,]$Var2)
  res <- raw %>% check_vote_fields(v1, v2)
  print(glue("Checking at {error_idx}, {all_combinations[error_idx,]$Var1} with {all_combinations[error_idx,]$Var2}"))
}




# Helper to look at problems
raw %>% select(starts_with("vote_UK"), starts_with("vote_DE")) %>% 
  filter(!is.na(vote_UK_con)) %>% 
  View()


raw %>% select(select_not(., "vote")) %>% View()




# Test kram


qualtrics_data <- read_sav("20190606_filterbubbles_multinational/qualtrics.sav")


temp <- qualtrics_data %>% select(respondent_id, vote_DE) %>% na.omit() %>% inner_join(
qualtrics_data %>% select(respondent_id, vote_PL) %>% na.omit() ) 


temp %>% View()


library(haven)
qualtrics_raw <- read_sav("20190606_filterbubbles_multinational/qualtrics_raw.sav")
View(qualtrics_raw)

qualtrics_raw %>% select(ResponseId, vote_DE_prob_1) %>% na.omit() %>% inner_join(
  qualtrics_raw %>% select(ResponseId, Q50) %>% na.omit() ) 


names(qualtrics_raw)

