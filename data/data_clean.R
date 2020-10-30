# This file changes the raw data into a usable format
library(sjlabelled)


cleaned1 <- raw %>% 
  mutate_at(c("nationality", "awareness"),  sjlabelled::as_factor)



# Change everything to factors

cleaned2 <- cleaned1 %>%  rename(b5_o1n = personality_01,
         b5_a1 = personality_02)


# rename variable to match scales



# helper function to read labels
cleaned %>% select(starts_with("personality")) %>% map(get_label)



# identify parties of countries with political alignment for all countries



#save file

cleaned <- cleaned2

