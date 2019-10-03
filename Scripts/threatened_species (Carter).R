library(TelemetryR); library(dplyr)

dets <- vemsort('p:/obrien/biotelemetry/detections/cedar pt')
detscbl <- vemsort('p:/obrien/biotelemetry/detections/cbl pier')
detspp <- vemsort('p:/obrien/biotelemetry/detections/piney pt')
dets <- rbind(dets, detspp, detscbl)

# ACTupdate(local.ACT = 'ACTactive.rda')
load('p:/obrien/randomr/ACTall.rda')

species <- left_join(data.frame(dets), ACTall,
                     by = c('transmitter' = 'Tag.ID.Code.Standard')) %>%
  mutate(month = lubridate::floor_date(date.local, 'month'),
         common = case_when(grepl('not', Common.Name) ~ 'atlantic sturgeon',
                            T ~ tolower(Common.Name)),
         array = case_when(grepl('Cedar', station) ~ 'Cedar Pt',
                           grepl('Piney', station) ~ 'Piney Pt',
                           grepl('CBL', station) ~ 'Patuxent mouth')) %>%
  filter(grepl('sturgeon|turtle|not', common)) %>%
  distinct(transmitter, common, month, array, Primary.Researcher)

xtabs(~month + common, data = species)
xtabs(~month + common + array, data = species)
