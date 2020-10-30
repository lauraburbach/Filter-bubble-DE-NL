# This file changes the raw data into a usable format
library(sjlabelled)


cleaned1 <- raw %>% 
  mutate_at(c("nationality", "awareness",
              "education_NL"),  sjlabelled::as_factor)



# Change everything to factors

cleaned2 <- cleaned1 %>%  rename(b5_o1n = personality_01,
         b5_a1 = personality_02)


# rename variable to match scales



# helper function to read labels
cleaned %>% select(starts_with("personality")) %>% map(get_label)



## Map Education to high and low
cleaned$education_NL

cleaned$education_DE

cleaned$education_FR_other

cleaned$education_UK



# identify parties of countries with political alignment for all countries



#save file

cleaned <- cleaned2

