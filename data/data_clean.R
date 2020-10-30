# This file changes the raw data into a usable format
library(sjlabelled)


cleaned1 <- raw %>% 
  mutate_at(c("nationality", "awareness",
              "education_NL",
              "education_DE"),  sjlabelled::as_label)



# Change everything to factors

cleaned2 <- cleaned1 %>%  rename(b5_o1n = personality_01,
         b5_a1 = personality_02)


# rename variable to match scales



# helper function to read labels
cleaned %>% select(starts_with("personality")) %>% map(get_label)



## Map Education to high and low

# We want one column for education low and high (no-highschool, university and above) ISCED as reference




cleaned3 <- cleaned2 %>% mutate(education = fct_collapse(education_NL, 
                                             low = c("no education/uncompleted primary school",
                                                     "primary school"),
                                             high = c("HBO diploma", 
                                                      "university bachelors degree"),
                                             other_level = c("other (please specify)"))) %>% 
  mutate(education = fct_collapse(education_DE, 
                                  low = c("no education",
                                          "Haupt-/Volksschulabschluss"),
                                  high = c("university bachelors degree", 
                                           "university masters degree"),
                                  other_level = c("other (please specify)")))


cleaned3$education

### 

cleaned2$education_NL

cleaned$education_DE

cleaned$education_FR_other

cleaned$education_UK

cleaned %>% filter(education_FR == 0) %>% nrow()


# identify parties of countries with political alignment for all countries



#save file

cleaned <- cleaned2

