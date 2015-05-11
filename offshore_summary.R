library(TelemetryR); library(dplyr)
dets <- vemsort('p:/obrien/biotelemetry/detections')

dets <- filter(dets, grepl('v-|t-|a-', dets$station, ignore.case = T))
# levels(factor(dets$transmitter))

# Number of unique fish detected, per station
num_dets <- dets %>% 
  group_by(station) %>% 
  summarize(a = n_distinct(transmitter))

# Detections in wind energy area.
species <- left_join(dets, ACTtrans, by = c('transmitter' = 'Tag.ID.Code.Standard'))

num_species <- species %>% group_by(station, Common.Name) %>% 
  distinct(station, transmitter) %>% 
    summarize(n = n())

# Species in wind energy area.
WEA_species <- filter(species, station == 'T-2C')
levels(factor(species$Common.Name))
