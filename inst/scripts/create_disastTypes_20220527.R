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


unique_emdat_events_df <- 
  clean_emdat %>% 
  select(Source,event_id, state, incident_type) %>% 
  unique()

table(unique_emdat_events_df$incident_type)

a <- unique_emdat_events_df %>%
  mutate(
    incident_type_un = str_replace_all(
      incident_type, cambio
    
    )
  )

cambio <- 
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
  "Storm:Extra-tropical storm:NA " = "METEOROLOGICAL and HYDROLOGICAL", 
  "Storm:Tropical cyclone:NA" = "METEOROLOGICAL and HYDROLOGICAL", 
  " Wildfire:Land fire (Brush, Bush, Pasture):NA" = "ENVIRONMENTAL", 
  "Earthquake:Ground movement:NA" = "GEOHAZARD", 
  "Epidemic:Viral disease:NA" = "BIOLOGOCAL", 
  "Extreme temperature:Heat wave:NA" = "METEOROLOGICAL and HYDROLOGICAL", 
  "Flood:Flash flood:NA" = "METEOROLOGICAL and HYDROLOGICAL",
  "Flood:Riverine flood:NA" = "METEOROLOGICAL and HYDROLOGICAL", 
  "Landslide:Mudslide:NA" = "METEOROLOGICAL and HYDROLOGICAL", 
  "Storm:Convective storm:Hail" = "METEOROLOGICAL and HYDROLOGICAL", 
  
  
  
  
  
  
  
  
  )
