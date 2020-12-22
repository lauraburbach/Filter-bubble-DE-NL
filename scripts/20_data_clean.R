# This file changes the raw data into a usable format
#
library(logger)
log_info("Cleaning data...")

library(sjlabelled)
library(labelled)
library(tidyverse)
library(haven)



# Load the raw data 
raw <- read_sav(here::here("data", "filterbubble.sav"))


# change everything to factors----
cleaned1 <- raw %>% 
  mutate_at(c("gender",
              "education_NL",
              "facebook",
              "filterbubble",
              "filterbubble_prevention",
              "nationality", 
              "education_DE",
              "education_UK", 
              "education_FR",
              "education_PL", 
              "completed", 
              "measured_filter_bubble", 
              "awareness", 
              "implicit_awareness"
  ),  to_character)


# rename variable to match scales----
cleaned2 <- cleaned1 %>%  rename(b5_e1n = personality_01,
                                 b5_a1 = personality_02,
                                 b5_c1n = personality_03,
                                 b5_n1n = personality_04,
                                 b5_o1n = personality_05,
                                 b5_e2 = personality_06,
                                 b5_a2 = personality_07,
                                 b5_c2 = personality_08,
                                 b5_n2 = personality_09,
                                 b5_o2 = personality_10, 
                                 
                                 freq_paper_on = media_frequency_01,
                                 freq_paper_off = media_frequency_02, 
                                 freq_internet = media_frequency_03,
                                 freq_radio = media_frequency_04, 
                                 freq_television = media_frequency_05, 
                                 freq_social_media = media_frequency_06, 
                                 freq_facebook = media_frequency_07, 
                                 
                                 imp_internet = media_importance_02,
                                 imp_paper = media_importance_03,
                                 imp_radio = media_importance_04, 
                                 imp_television = media_importance_01, 
                                 imp_social_media = media_importance_06, 
                                 imp_facebook = media_importance_05, 
                                 imp_conversation = media_importance_07,
                                 
                                 fb_read = facebook_use_01, 
                                 fb_share = facebook_use_02, 
                                 fb_like = facebook_use_03,
                                 fb_comment = facebook_use_04)


# helper function to read labels----
cleaned2 %>% select(starts_with("personality")) %>% map(get_label)


## map Education to high and low----
# We want one column for education low and high (no-highschool, university and above) ISCED as reference

# add remove dupliacte entries for PL/DE
cleaned3 <-
  cleaned2 %>% unite(
    education_comb,
    c(
      "education_NL",
      "education_DE",
      "education_FR",
#      "education_PL",  # is mapped on qualtrics using translation and not path switching
      "education_UK"
    ),
    na.rm = TRUE,
    remove = FALSE
  )



cleaned4 <- cleaned3 %>% mutate(education = fct_collapse(education_comb, 
                                               low = c(## Dutch education system low
                                                       #"no education/uncompleted primary school", # unused level
                                                       "primary school",
                                                       "secondary school without diploma",
                                                       "secondary school with diploma",
                                                       "MBO diploma",
                                                       
                                                       ## German education system low
                                                       "no education",
                                                       "Haupt-/Volksschulabschluss",
                                                       "qualifizierter Hauptschulabschluss",
                                                       "Realschulabschluss",
                                                       "Fachabitur",
                                                       "Abitur",
                                                       
                                                       ## French education system low
                                                       # "no education",
                                                       "diplôme national du Brevet",
                                                       "baccalauréat professionnel",
                                                       "baccalauréat",
                                                       
                                                       ## Polish education system low
                                                       # "bez wykształcenia", #unused level
                                                       #"podstawowe",
                                                       #"gimnayjalne",
                                                       #"zawodowe",
                                                       #"średnie (techniczne)",
                                                       #"średnie (policealne)", 
                                                       
                                                       ## British education system low
                                                       #"no education", 
                                                       #"primary school", 
                                                       "lower secondary school",
                                                       "upper secondary school",
                                                       "post-secondary education (level 4)"
                                                       ),
                                               high = c(## Dutch education system high
                                                        "HBO diploma", 
                                                        "university bachelors degree",
                                                        "university masters degree",
                                                        "university specialised degree (doctor legal)",
                                                        
                                                        ## German education system high
                                                        # "university bachelors degree", 
                                                        # "university masters degree",
                                                        "doctorate",
                                                        
                                                        ## French education system high
                                                        "Licence, bac+3",
                                                        "Master, bac+5",
                                                        #"Doctorat",            # not present in data
                                                        
                                                        ## Polish education system high
                                                        #"licencjat/inzynier",
                                                        #"magister",
                                                        #"tytuł doktora",
                                                        
                                                        ## British education system high
                                                        "post-secondary education (level 5)",
                                                        #"university bachelors degree",
                                                        #"university masters degree",
                                                        "doctoral"),
                                               other_level = c("other (please specify)")))



# Overview over education
cleaned4$education %>% qplot()

#Rename Parties to match ParlGov Data
# Add individual labels
cleaned4 %>% rename(vote_DE_afd = vote_DE_afd,
                    `vote_DE_b90/gru` = vote_DE_gruen)

cleaned4$vote_DE_other_party

#save file
write_rds(cleaned4, here::here("data", "clean_unanoymized.rds"))

log_info("Done.")
