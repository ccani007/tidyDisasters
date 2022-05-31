# Create Table of Type of Disasters
# Catalina Cañizares and Gabriel Odom
# 05/27/2022

# Now that we have a unique key for all events (by state, year, and month), we
#  will create a table of the type of disasters based on the classification 
#  of the Hazard Definition and Classification Review Technical Report
#  published by the UN Office for Disaster Risk Reduction (2020)
#  (https://www.undrr.org/publication/hazard-definition-and-classification-review)

library(tidyDisasters)
library(tidyverse)


data("clean_emdat")
# 3101152 x 9
data("allKeys_df")
# 498,188 x 4
clean_fema <- readRDS(
  file = "inst/extdata/clean_fema.RDS"
)
# 32,938,843 x 8

##### EMDAT ######
# We created the list of unique type of events in the EMDAT to categorize them
#  according to the Hazard Definition and Classification Review Technical Report
#  first as the broad hazard type and then sun-classified them in the hazard 
#  cluster. 

unique_emdat_events_df <- 
  clean_emdat %>% 
  select(emdatID = event_id, incident_type) %>% 
  distinct()
# 549 x 2

# I created a list pairing the type of disaster according to EMDAT and 
#  the technical report, to then use it in the `str_replace_all` function

rename_hazard_type <- 
  c("Drought:Drought:NA" = "METEOROLOGICAL and HYDROLOGICAL", 
    "Extreme temperature:Cold wave:NA" = "METEOROLOGICAL and HYDROLOGICAL", 
    "Epidemic:Parasitic disease:NA" = "BIOLOGOCAL", 
    "Extreme temperature:Severe winter conditions:Snow/Ice" = "METEOROLOGICAL and HYDROLOGICAL", 
    "Flood:NA:NA" = "METEOROLOGICAL and HYDROLOGICAL", 
    "Landslide:Landslide:NA" = "GEOHAZARD",
    "Storm:Convective storm:Derecho" = "METEOROLOGICAL and HYDROLOGICAL", 
    "Storm:Convective storm:Lightning/Thunderstorms" = "METEOROLOGICAL and HYDROLOGICAL", 
    "Storm:Convective storm:Sand/Dust storm" = "METEOROLOGICAL and HYDROLOGICAL", 
    "Storm:Convective storm:Tornado" = "METEOROLOGICAL and HYDROLOGICAL", 
    "Storm:Extra-tropical storm:NA" = "METEOROLOGICAL and HYDROLOGICAL", 
    "Storm:Tropical cyclone:NA" = "METEOROLOGICAL and HYDROLOGICAL", 
    "Wildfire:Land fire (Brush, Bush, Pasture):NA" = "ENVIRONMENTAL", 
    "Earthquake:Ground movement:NA" = "GEOHAZARD", 
    "Epidemic:Viral disease:NA" = "BIOLOGOCAL", 
    "Extreme temperature:Heat wave:NA" = "METEOROLOGICAL and HYDROLOGICAL", 
    "Flood:Flash flood:NA" = "METEOROLOGICAL and HYDROLOGICAL",
    "Flood:Riverine flood:NA" = "METEOROLOGICAL and HYDROLOGICAL", 
    "Landslide:Mudslide:NA" = "METEOROLOGICAL and HYDROLOGICAL", 
    "Storm:Convective storm:Hail" = "METEOROLOGICAL and HYDROLOGICAL", 
    "Storm:Convective storm:NA" = "METEOROLOGICAL and HYDROLOGICAL", 
    "Storm:Convective storm:Severe storm" = "METEOROLOGICAL and HYDROLOGICAL",
    "Storm:Convective storm:Winter storm/Blizzard" = "METEOROLOGICAL and HYDROLOGICAL", 
    "Storm:NA:NA" = "METEOROLOGICAL and HYDROLOGICAL", 
    "Wildfire:Forest fire:NA" = "ENVIRONMENTAL",
    "Wildfire:NA:NA" = "ENVIRONMENTAL")

rename_hazard_cluster <- 
  c("Drought:Drought:NA" = "Precipitation-related", 
    "Extreme temperature:Cold wave:NA" = "Temperature-related", 
    "Epidemic:Parasitic disease:NA" = "Infectious diseases (human and animal)", # CHECK
    "Extreme temperature:Severe winter conditions:Snow/Ice" = "Precipitation-related", 
    "Flood:NA:NA" = "Flood", 
    "Landslide:Landslide:NA" = "Shallow geohazard", # CHECK
    "Storm:Convective storm:Derecho" = "Wind-related", 
    "Storm:Convective storm:Lightning/Thunderstorms" = "Convective-related", 
    "Storm:Convective storm:Sand/Dust storm" = "Lithometeors", 
    "Storm:Convective storm:Tornado" = "Wind-related", 
    "Storm:Extra-tropical storm:NA" = "Pressure-related", # CHECK
    "Storm:Tropical cyclone:NA" = "Wind-related", 
    "Wildfire:Land fire (Brush, Bush, Pasture):NA" = "Environmental degradation (Forestry)",
    "Earthquake:Ground movement:NA" = "Seismogenic (earthquakes)", 
    "Epidemic:Viral disease:NA" = "Infectious diseases (human and animal)", # CHECK
    "Extreme temperature:Heat wave:NA" = "Temperature-related", 
    "Flood:Flash flood:NA" = "Flood",
    "Flood:Riverine flood:NA" = "Flood", 
    "Landslide:Mudslide:NA" = "Shallow geohazard", # CHECK
    "Storm:Convective storm:Hail" = "Precipitation-related", 
    "Storm:Convective storm:NA" = "Convective-related", 
    "Storm:Convective storm:Severe storm" = "Convective-related",
    "Storm:Convective storm:Winter storm/Blizzard" = "Precipitation-related", 
    "Storm:NA:NA" = "Precipitation-related", # Check
    "Wildfire:Forest fire:NA" = "Environmental degradation (Forestry)",
    "Wildfire:NA:NA" = "Environmental degradation (Forestry)")

# Crated the new data set with the new categories according to the technical 
#  report, just for EMDAT. 

emdat_hazard_cluster_df <- 
  unique_emdat_events_df %>%
  mutate(incident_type = str_remove(incident_type, pattern = "\\("), 
         incident_type = str_remove(incident_type, pattern = "\\)")
  ) %>% 
  mutate(
    hazard_type = str_replace_all(
      incident_type, rename_hazard_type 
    )
  ) %>% 
  mutate(
    hazard_cluster = str_replace_all(
      incident_type, rename_hazard_cluster
    )
  ) 

# Checked with tables if the tranformation was done correctly
table(emdat_hazard_cluster_df$hazard_type)
table(emdat_hazard_cluster_df$hazard_cluster)

##### FEMA ######
# We created the list of unique type of events in the FEMA to categorize them
#  according to the Hazard Definition and Classification Review Technical Report
#  first as the broad hazard type and then sub-classified them in the hazard 
#  cluster. 

unique_fema_events_df <- 
  clean_fema %>%
  mutate(EventUniqueId = substr(event_id, 1, 6)) %>% 
  select(femaID = EventUniqueId, incident_type) %>%
  distinct() 
# 816 * 2

rename_hazard_type_fema <- 
  c("Armed Assault" = "SOCIETAL", 
    "Chemical" = "SOCIETAL", # Check 
    "Dam/Levee Break" = "METEOROLOGICAL and HYDROLOGICAL", # Check
    "Earthquake" = "GEOHAZARD", 
    "Fire" = "ENVIRONMENTAL", 
    "Flood" = "METEOROLOGICAL and HYDROLOGICAL",
    "Hijacking" = "SOCIETAL", 
    "Hostage Taking (Kidnapping)" = "SOCIETAL",
    "Hurricane" = "METEOROLOGICAL and HYDROLOGICAL", 
    "Other" = "OTHER", # Check
    "Severe Storm(s)" = "METEOROLOGICAL and HYDROLOGICAL", 
    "Terrorist" = "SOCIETAL", 
    "Toxic Substances" = "CHEMICAL", # Check
    "Unarmed Assault" = "SOCIETAL", 
    "Bombing/Explosion" = "SOCIETAL", 
    "Coastal Storm" = "METEOROLOGICAL and HYDROLOGICAL", 
    "Drought" = "METEOROLOGICAL and HYDROLOGICAL",
    "Facility/Infrastructure Attack" = "SOCIETAL", 
    "Fishing Losses" =  "ENVIRONMENTAL", # Check
    "Freezing" = "METEOROLOGICAL and HYDROLOGICAL",
    "Hostage Taking (Barricade Incident)" = "SOCIETAL",
    "Human Cause" = "SOCIETAL", # Check
    "Mud/Landslide" = "GEOHAZARD", 
    "Severe Ice Storm" = "METEOROLOGICAL and HYDROLOGICAL",
    "Snow" = "METEOROLOGICAL and HYDROLOGICAL",
    "Tornado" = "METEOROLOGICAL and HYDROLOGICAL",
    "Tsunami" = "GEOHAZARD", 
    "Volcano" = "GEOHAZARD")
    
rename_hazard_cluster_fema <- 
  c("Armed Assault" = "Conflict", # Chceck 
    "Chemical" = "Conflict", # Check 
    "Dam/Levee Break" = "Flood", # Check
    "Earthquake" = "Seismogenic (earthquakes)", 
    "Fire" = "Environmental degradation (Forestry)", 
    "Flood" = "Flood",
    "Hijacking" = "Behavioural", # Chceck
    "Hostage Taking (Kidnapping)" = "Behavioural", # Chceck
    "Hurricane" = "Pressure-related", 
    "Other" = "OTHER", # Check
    "Severe Storm(s)" = "Precipitation-related", # Check 
    "Terrorist" = "Conflict", # Check 
    "Toxic Substances" = "Other chemical hazards and toxins", # Check
    "Unarmed Assault" = "Conflict", 
    "Bombing/Explosion" = "Behavioural", 
    "Coastal Storm" = "Flood", # Check
    "Drought" = "Precipitation-related",
    "Facility/Infrastructure Attack" = "Behavioural", 
    "Fishing Losses" =  "Environmental degradation", # Check
    "Freezing" = "Temperature-related",
    "Hostage Taking (Barricade Incident)" = "Behavioural",
    "Human Cause" = "Behavioural", # Check
    "Mud/Landslide" = "Shallow geohazard", 
    "Severe Ice Storm" = "Precipitation-related",
    "Snow" = "Precipitation-related",
    "Tornado" = "Wind-related",
    "Tsunami" = "Shallow geohazard", 
    "Volcano" = "Volcanogenic (volcanoes and geothermal)")

fema_hazard_cluster_df <- 
  unique_fema_events_df %>%
  mutate(incident_type = str_remove(incident_type, pattern = "\\("), 
         incident_type = str_remove(incident_type, pattern = "\\)")
  ) %>% 
  mutate(
    hazard_type = str_replace_all(
      incident_type, rename_hazard_type_fema 
    )
  ) %>% 
  mutate(
    hazard_cluster = str_replace_all(
      incident_type, rename_hazard_cluster_fema
    )
  )


table(fema_hazard_cluster_df$hazard_type)
table(fema_hazard_cluster_df$hazard_cluster)

#####  Map All disaster types data to Unique Key  ###

# I do not know how!! 

disastType1_df <- 
  emdat_hazard_cluster_df %>% 
  left_join(allKeys_df, by = "emdatID")
# 549 x 3

