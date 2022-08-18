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
#  first as the broad hazard type and then sub-classified them in the hazard 
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
    "Epidemic:Parasitic disease:NA" = "Infectious diseases (human and animal)", 
    "Extreme temperature:Severe winter conditions:Snow/Ice" = "Precipitation-related", 
    "Flood:NA:NA" = "Flood", 
    "Landslide:Landslide:NA" = "Shallow geohazard", 
    "Storm:Convective storm:Derecho" = "Wind-related", 
    "Storm:Convective storm:Lightning/Thunderstorms" = "Convective-related", 
    "Storm:Convective storm:Sand/Dust storm" = "Lithometeors", 
    "Storm:Convective storm:Tornado" = "Wind-related", 
    "Storm:Extra-tropical storm:NA" = "Pressure-related", 
    "Storm:Tropical cyclone:NA" = "Wind-related", 
    "Wildfire:Land fire (Brush, Bush, Pasture):NA" = "Environmental degradation (Forestry)",
    "Earthquake:Ground movement:NA" = "Seismogenic (earthquakes)", 
    "Epidemic:Viral disease:NA" = "Infectious diseases (human and animal)", 
    "Extreme temperature:Heat wave:NA" = "Temperature-related", 
    "Flood:Flash flood:NA" = "Flood",
    "Flood:Riverine flood:NA" = "Flood", 
    "Landslide:Mudslide:NA" = "Terrestrial",
    "Storm:Convective storm:Hail" = "Precipitation-related", 
    "Storm:Convective storm:NA" = "Convective-related", 
    "Storm:Convective storm:Severe storm" = "Convective-related",
    "Storm:Convective storm:Winter storm/Blizzard" = "Precipitation-related", 
    "Storm:NA:NA" = "Precipitation-related", 
    # 2007-0663-USA, 2007-0581-USA, 2018-0129-USA, 2003-0829-USA
    #  Classified as precipitation though several events with this category
    #  Are related to hail, snow and floods. 
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
    "Chemical" = "CHEMICAL", 
    "Dam/Levee Break" = "TECHNOLOGICAL", 
    "Earthquake" = "GEOHAZARD", 
    "Fire" = "ENVIRONMENTAL", 
    "Flood" = "METEOROLOGICAL and HYDROLOGICAL",
    "Hijacking" = "SOCIETAL", 
    "Hostage Taking (Kidnapping)" = "SOCIETAL",
    "Hurricane" = "METEOROLOGICAL and HYDROLOGICAL", 
    "Other" = "OTHER", 
    "Severe Storm(s)" = "METEOROLOGICAL and HYDROLOGICAL", 
    "Terrorist" = "SOCIETAL", 
    "Toxic Substances" = "CHEMICAL", 
    "Unarmed Assault" = "SOCIETAL", 
    "Bombing/Explosion" = "SOCIETAL", 
    "Coastal Storm" = "METEOROLOGICAL and HYDROLOGICAL", 
    "Drought" = "METEOROLOGICAL and HYDROLOGICAL",
    "Facility/Infrastructure Attack" = "SOCIETAL", 
    "Fishing Losses" =  "ENVIRONMENTAL", 
  # Ii is not categorized under chemical or biological given that the reasons
  #  related to the fishing loss are toxic algae and "El nino" (warmer than 
  #  normal sea surface temperatures)
    "Freezing" = "METEOROLOGICAL and HYDROLOGICAL",
    "Hostage Taking (Barricade Incident)" = "SOCIETAL",
    "Human Cause" = "SOCIETAL", 
  # The examples found on the data set show that the human cause disasters 
  #  belong to the societal category given its relationship with conflict 
  #  situations. 
  # The cases are two bombings and the mariel boatlift. Information about
  #  the events are depicted in the following three links
  # https://www.fbi.gov/history/famous-cases/oklahoma-city-bombing
  # https://www.state.gov/1993-world-trade-center-bombing/
  # https://www.fema.gov/disaster/3079
    "Mud/Landslide" = "GEOHAZARD", 
    "Severe Ice Storm" = "METEOROLOGICAL and HYDROLOGICAL",
    "Snow" = "METEOROLOGICAL and HYDROLOGICAL",
    "Tornado" = "METEOROLOGICAL and HYDROLOGICAL",
    "Tsunami" = "GEOHAZARD", 
    "Volcano" = "GEOHAZARD")
    
rename_hazard_cluster_fema <- 
  c("Armed Assault" = "Conflict", # Chceck 
    "Chemical" = "Other chemical hazards and toxins", 
    "Dam/Levee Break" = "Construction/ Structural failure", 
    "Earthquake" = "Seismogenic (earthquakes)", 
    "Fire" = "Environmental degradation (Forestry)", 
    "Flood" = "Flood",
    "Hijacking" = "Behavioural", # Chceck
    "Hostage Taking (Kidnapping)" = "Behavioural", # Chceck
    "Hurricane" = "Pressure-related", 
    "Other" = "OTHER", 
    # Other is not a category in the technical report. 
    #  The events that are under the other category in FEMA vary from the loss
    #  of the space shuttle Columbia to power outwage, therefore I believe
    #  leaving this category open is fine. 
    "Severe Storm(s)" = "Precipitation-related", 
    # The events are all related to rain, flooding and ice, so it 
    #  is alright to categorize it as precipitation related 
    "Terrorist" = "Conflict", 
    "Toxic Substances" = "Other chemical hazards and toxins", 
    "Unarmed Assault" = "Conflict", 
    "Bombing/Explosion" = "Behavioural", 
    "Coastal Storm" = "Wind-related", 
    # The examples on the data set are tropical storms such as 
    #  "Tropical Storm Barry", "Tropical Storm Fay" 
    "Drought" = "Precipitation-related",
    "Facility/Infrastructure Attack" = "Behavioural", 
    "Fishing Losses" =  "Environmental degradation", 
    "Freezing" = "Temperature-related",
    "Hostage Taking (Barricade Incident)" = "Behavioural",
    "Human Cause" = "Behavioural", 
    "Mud/Landslide" = "Shallow geohazard", 
    "Severe Ice Storm" = "Precipitation-related",
    "Snow" = "Precipitation-related",
    "Tornado" = "Wind-related",
    "Tsunami" = "Shallow geohazard", 
    "Volcano" = "Volcanogenic (volcanoes and geothermal)")

# Create a codebook for classifying societal problems, mention this as a 
#  recommendation in the paper. 

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

