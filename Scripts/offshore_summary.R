library(TelemetryR); library(dplyr)
dets <- vemsort('p:/obrien/biotelemetry/detections')

dets <- filter(dets, grepl('v-|t-|a-', dets$station, ignore.case = T))
# levels(factor(dets$transmitter))

# Number of unique fish detected, per station
n_dets_all <- dets %>% 
  group_by(station) %>% 
  summarize(a = n_distinct(transmitter))

# n_dets_201504 <- dets %>% 
#   filter(date.local <= lubridate::ymd('20150422', tz = "America/New_York")) %>% 
#   group_by(station) %>% 
#   summarize(a = n_distinct(transmitter))

n_dets_201507 <- dets %>% 
  filter(date.local > lubridate::ymd('20150422', tz = "America/New_York"),
         date.local <= lubridate::ymd('20150709', tz = "America/New_York")) %>% 
  group_by(station) %>% 
  summarize(a = n_distinct(transmitter))

# Detections in wind energy area.
species <- left_join(dets, ACTtrans, by = c('transmitter' = 'Tag.ID.Code.Standard'))

n_spec_all <- species %>% group_by(station, Common.Name) %>% 
  distinct(station, transmitter) %>% 
  summarize(n = n())

# n_spec_201504 <- species %>%
#   filter(date.local <= lubridate::ymd('20150422', tz = "America/New_York")) %>%
#   group_by(station, Common.Name) %>% 
#   distinct(station, transmitter) %>% 
#   summarize(n = n())

n_spec_201507 <- species %>% 
  filter(date.local > lubridate::ymd('20150422', tz = "America/New_York"),
         date.local <= lubridate::ymd('20150709', tz = "America/New_York")) %>%
  group_by(station, Common.Name) %>% 
  distinct(station, transmitter) %>% 
  summarize(n = n())

# Species, Institution, PI
PI_all <- species %>% 
  group_by(Common.Name, Release.Location, Primary.Researcher,
           Primary.Tagging.Organization) %>% 
  distinct(transmitter) %>%
  summarize(n = n())

# PI_201504 <- species %>%
#   filter(date.local <= lubridate::ymd('20150422', tz = "America/New_York")) %>%
#   group_by(Common.Name, Release.Location, Primary.Researcher,
#            Primary.Tagging.Organization) %>% 
#   distinct(transmitter) %>%
#   summarize(n = n())

PI_201507 <- species %>% 
  filter(date.local > lubridate::ymd('20150422', tz = "America/New_York"),
         date.local <= lubridate::ymd('20150709', tz = "America/New_York")) %>%
  group_by(Common.Name, Release.Location, Primary.Researcher,
           Primary.Tagging.Organization) %>% 
  distinct(transmitter) %>%
  summarize(n = n())

# Species in wind energy area.
WEA_species <- filter(species, station == 'A-5C')
levels(factor(WEA_species$Common.Name))
