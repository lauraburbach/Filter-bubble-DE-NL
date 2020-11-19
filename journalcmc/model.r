# This will contain the initial model


filename <- here::here("data", "filterbubble_anonymized.rds")

#dataset = read.spss(filename,
#                    use.value.labels = FALSE,
#                    to.data.frame = TRUE)



# create a file for use in SmartPLS
tmp <- read_rds(filename) 

tmp %>% select(-education_NL_other, -education_DE_other, -education_UK_other, -education_FR_other,
               -education_PL_other, -questions_remarks, -filterbubble_prevention_method,
               -vote_NL_other_party,
               -vote_DE_other_party,
               -vote_UK_other_party,
               -vote_FR_other,
               -vote_PL_other_party) %>% write_csv("filterbubble.csv") 

dataset <- tmp


ggstatsplot::ggbetweenstats(dataset, nationality, age)

names(dataset)

