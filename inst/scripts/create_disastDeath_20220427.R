# Create Table of Disaster Mortality
# Catalina Cañizares and Gabriel Odom
# 04/27/2022

# Now that we have a unique key for all events (by state, year, and month), we
#   will create a table of the mortality for each event

library(tidyDisasters)
library(tidyverse)

allEventsMap_df <- readRDS(
  file = "inst/extdata/key_fema_emdat.RDS"
)
# 36,224,806 x 5

data("clean_emdat")
# 3101152 x 9


###  Map All death data to Unique Key  ###
data("allKeys_df")
disastMortality_df <- 
  clean_emdat %>% 
  rename(emdatID = region_id) %>% 
	left_join(allKeys_df, clean_emdat, by = "emdatID") %>% 
	select(eventKey, nkill) %>% 
	distinct()
# 279,149 x 3

usethis::use_data()


