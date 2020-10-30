# This file changes the raw data into a usable format
library(sjlabelled)


cleaned <- raw %>% 
  mutate_at(c("nationality", "awareness"),  sjlabelled::as_factor)



cleaned$nationality
cleaned$awareness

