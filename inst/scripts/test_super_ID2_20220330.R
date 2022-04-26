# Serting our super ID to identify each event
# Catalina Cañizares and Gabriel Odom
# 03/30/2022

# To move the project forward and obtain functional tables from the merge of
#  FEMA and EMDAT we need to create a key. Dr. Odom and Catalina have agreed
#  upon creating a key that will contain the beginning year, month, state and
#  a 4 random number at the end that will identify the same event although it
#  touches different counties.


library(lubridate)
library(tidyverse)

allEventsMap_df <- readRDS(
  file = "data_processed/database_key_fema_emdat_20211027.RDS"
)

allEventsMap2_df <-
  allEventsMap_df %>%
  group_by(femaID) %>%
  fill(emdatID, .direction = "updown") %>%
  ungroup() %>%
  replace_na( list(femaID = "", emdatID = "") ) %>%
  mutate(femaID_trunc = str_remove(femaID, pattern = "_[^.]*$")) %>%
  mutate(smashedID = paste0(femaID_trunc, "_", emdatID)) %>%
  select(-femaID_trunc)

allKeys_df <-
  allEventsMap2_df %>%
  group_by(smashedID) %>%
  summarise(
    startDate = min(Day),
    state = unique(state)
  ) %>%
  ungroup() %>%
  mutate(ym = format(startDate, format = "%Y_%m")) %>%
  group_by(ym, state) %>%
  # Add a counter for the number of events in each state in each month
  mutate(rowNum = as.character(1:n())) %>%
  mutate(rowNum = str_pad(rowNum, width = 2, side = "left", pad = "0")) %>%
  select(-startDate) %>%
  # smush them all together
  mutate(eventKey = paste0(ym, "_", state, "_", rowNum)) %>%
  ungroup() %>%
  select(smashedID, eventKey) %>%
  # Our key will not be able to match back to the FEMA ids in the current form,
  #   so we need to map between the abbreviated FEMA ids and the full ones
  left_join(
    allEventsMap2_df %>%
      select(smashedID, femaID, emdatID),
    by = "smashedID"
  ) %>%
  select(femaID, emdatID, eventKey) %>%
  distinct() %>%
  arrange(eventKey)

saveRDS(allKeys_df, file = "data_processed/all_keys_20220330.rds")

