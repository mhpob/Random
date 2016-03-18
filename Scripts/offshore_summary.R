library(TelemetryR); library(dplyr)
dets <- vemsort('p:/obrien/biotelemetry/detections/offshore')

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

# n_dets_201507 <- dets %>% 
#   filter(date.local > lubridate::ymd('20150422', tz = "America/New_York"),
#          date.local <= lubridate::ymd('20150709', tz = "America/New_York")) %>% 
#   group_by(station) %>% 
#   summarize(a = n_distinct(transmitter))

# n_dets_201509 <- dets %>% 
#   filter(date.local > lubridate::ymd('20150709', tz = "America/New_York"),
#          date.local <= lubridate::ymd('20150918', tz = "America/New_York")) %>% 
#   group_by(station) %>% 
#   summarize(a = n_distinct(transmitter))

# n_dets_201512 <- dets %>% 
#   filter(date.local > lubridate::ymd('20150918', tz = "America/New_York"),
#          date.local <= lubridate::ymd('20151209', tz = "America/New_York")) %>% 
#   group_by(station) %>% 
#   summarize(a = n_distinct(transmitter))

n_dets_201602 <- dets %>% 
  filter(date.local > lubridate::ymd('20151208', tz = "America/New_York"),
         date.local <= lubridate::ymd('20160228', tz = "America/New_York")) %>% 
  group_by(station) %>% 
  summarize(a = n_distinct(transmitter))

# Detections in wind energy area.
load('ACTactive.rda')
species <- left_join(data.frame(dets), ACTactive,
                     by = c('transmitter' = 'Tag.ID.Code.Standard'))

n_spec_all <- species %>% group_by(station, Common.Name) %>% 
  distinct(station, transmitter) %>% 
  summarize(n = n())

# Note that the following were double-tagged by K. Dunton:
# 27721/22456
# 27725/22461
# 27731/22465
# 27744/22468

# n_spec_201504 <- species %>%
#   filter(date.local <= lubridate::ymd('20150422', tz = "America/New_York")) %>%
#   group_by(station, Common.Name) %>% 
#   distinct(station, transmitter) %>% 
#   summarize(n = n())

# n_spec_201507 <- species %>% 
#   filter(date.local > lubridate::ymd('20150422', tz = "America/New_York"),
#          date.local <= lubridate::ymd('20150709', tz = "America/New_York")) %>%
#   group_by(station, Common.Name) %>% 
#   distinct(station, transmitter) %>% 
#   summarize(n = n())

# n_spec_201509 <- species %>% 
#   filter(date.local > lubridate::ymd('20150709', tz = "America/New_York"),
#          date.local <= lubridate::ymd('20150918', tz = "America/New_York")) %>%
#   group_by(station, Common.Name) %>% 
#   distinct(station, transmitter) %>% 
#   summarize(n = n())

# n_spec_201512 <- species %>% 
#   filter(date.local > lubridate::ymd('20150918', tz = "America/New_York"),
#          date.local <= lubridate::ymd('20151209', tz = "America/New_York")) %>%
#   group_by(station, Common.Name) %>% 
#   distinct(station, transmitter) %>% 
#   summarize(n = n())

n_spec_201602 <- species %>% 
  filter(date.local > lubridate::ymd('20151208', tz = "America/New_York"),
         date.local <= lubridate::ymd('20160228', tz = "America/New_York")) %>%
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

# PI_201507 <- species %>% 
#   filter(date.local > lubridate::ymd('20150422', tz = "America/New_York"),
#          date.local <= lubridate::ymd('20150709', tz = "America/New_York")) %>%
#   group_by(Common.Name, Release.Location, Primary.Researcher,
#            Primary.Tagging.Organization) %>% 
#   distinct(transmitter) %>%
#   summarize(n = n())

# PI_201509 <- species %>% 
#   filter(date.local > lubridate::ymd('20150709', tz = "America/New_York"),
#          date.local <= lubridate::ymd('20150918', tz = "America/New_York")) %>%
#   group_by(Common.Name, Release.Location, Primary.Researcher,
#            Primary.Tagging.Organization) %>% 
#   distinct(transmitter) %>%
#   summarize(n = n())

# PI_201512 <- species %>% 
#   filter(date.local > lubridate::ymd('20150918', tz = "America/New_York"),
#          date.local <= lubridate::ymd('20151209', tz = "America/New_York")) %>%
#   group_by(Common.Name, Release.Location, Primary.Researcher,
#            Primary.Tagging.Organization) %>% 
#   distinct(transmitter) %>%
#   summarize(n = n())

PI_201602 <- species %>% 
  filter(date.local > lubridate::ymd('20151208', tz = "America/New_York"),
         date.local <= lubridate::ymd('20160228', tz = "America/New_York")) %>%
  group_by(Common.Name, Release.Location, Primary.Researcher,
           Primary.Tagging.Organization) %>% 
  distinct(transmitter) %>%
  summarize(n = n())

# Species in wind energy area.
WEA_species <- filter(species, station == 'A-5C')
levels(factor(WEA_species$Common.Name))
