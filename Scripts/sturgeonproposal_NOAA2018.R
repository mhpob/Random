library(TelemetryR); library(lubridate);library(dplyr)

tags <- read.csv('p:/obrien/biotelemetry/nanticoke/dnr vemco codes.csv',
                 stringsAsFactors = F)
data <- vemsort('p:/obrien/biotelemetry/detections/dnr') %>% 
  right_join(tags, by = c('transmitter' = 'VEMCO.codes'))



# p_min <- data %>% 
#   mutate(yr = year(date.local)) %>%
#   filter(year.tagged != yr,
#          yr != 2015,
#          grepl('brookview ', station, ignore.case = T)) %>% 
#   group_by(transmitter, yr, year.tagged) %>% 
#   summarize(min = min(date.local)) %>% 
#   mutate(doy = yday(min))

# p_min <- data %>% 
#   mutate(yr = year(date.local)) %>%
#   filter(year.tagged != yr,
#          yr != 2015,
#          grepl('brookview ', station, ignore.case = T)) %>% 
#   group_by(transmitter, yr, year.tagged) %>% 
#   summarize(min = min(date.local)) %>% 
#   mutate(doy = yday(min))

# Walnut landing
p_min <- data %>% 
  mutate(yr = year(date.local)) %>%
  filter(year.tagged != yr,
         grepl('4.6 ', station, ignore.case = T)) %>% 
  group_by(transmitter, yr, year.tagged) %>% 
  summarize(min = min(date.local)) %>% 
  mutate(doy = yday(min))

library(ggplot2)
ggplot() +
  stat_ecdf(data = p_min, aes(x = doy, color = as.factor(yr)), lwd = 1.5) +
  scale_x_continuous(
    breaks = yday(c('2017-08-01', '2017-09-01', '2017-10-01')),
    labels = month.abb[8:10]) +
  geom_vline(xintercept = yday(c('2017-08-15', '2017-09-07'))) +
  labs(x = NULL, y = 'Proportion detected', color = 'Year') +
  theme_bw()


p_max <- data %>% 
  mutate(yr = year(date.local)) %>%
  filter(year.tagged != yr,
         grepl('4.6 ', station, ignore.case = T)) %>% 
  group_by(
    year.tagged,
    transmitter, yr) %>% 
  summarize(max = max(date.local)) %>% 
  mutate(doy = yday(max))

library(ggplot2)
ggplot() +
  stat_ecdf(data = p_max, aes(x = doy, color = as.factor(yr)), lwd = 1.5) +
  scale_x_continuous(
    breaks = yday(c('2017-08-01', '2017-09-01', '2017-10-01')),
    labels = month.abb[8:10]) +
  geom_vline(xintercept = yday(c('2017-08-15', '2017-09-07'))) +
  labs(x = NULL, y = 'Proportion detected', color = 'Year') +
  theme_bw()



# ----
j <- data %>% 
  filter(grepl('brookview ', station, ignore.case = T),
         yday(date.local) >= yday('2017-08-15'),
         yday(date.local) <= yday('2017-09-07')) %>% 
  mutate(yr = year(date.local)) %>% 
  group_by(transmitter, yr) %>%
  summarize(n = n()) 

ggplot() +
  geom_histogram(data = j, aes(x = n, color = yr)) +
  # scale_y_continuous(breaks = seq(0, 10, 2)) +
  labs(x = 'Number of detections (log)', y = 'Number of Fish') +
  scale_x_log10()+
  theme_bw()

# ----
k <- data %>% 
  mutate(yr = year(date.local),
         dy = yday(date.local)) %>%
  filter(
    year.tagged != yr,
    grepl('4.6', station, ignore.case = T),
         yday(date.local) >= yday('2017-08-01'),
         yday(date.local) <= yday('2017-09-30')) %>% 
  distinct(transmitter, yr, dy) 

ggplot() + geom_raster(data= k, aes(x = dy, y = transmitter)) +
  scale_x_continuous(breaks = yday(c('2017-07-01', '2017-08-01',
                                     '2017-09-01', '2017-10-01')),
                     labels = month.abb[7:10]) +
  labs(x = NULL, y = 'Transmitter') +
  facet_wrap(~yr, ncol = 1) +
  theme_bw()

kk <- k %>%
  group_by(transmitter, yr) %>%
  summarize(n = n())

ggplot() +
  geom_bar(data = kk, aes(x = n, fill = as.factor(yr)),
           position = position_dodge2(preserve = 'single')) +
  # scale_x_continuous(breaks = seq(1, 15, 5)) +
  # scale_y_continuous(breaks = seq(0, 17, 2)) +
  labs(x = 'Days detected at Walnut Landing', y = 'Number of Fish', fill = 'Year') +
  theme_bw()



# Map----
library(sf)

far <- st_read('c:/users/secor/desktop/gis products/natural earth/10m coastline',
               'ne_10m_land')
far_states <- st_read('c:/users/secor/desktop/gis products/natural earth/50m statelines',
                      'ne_50m_admin_1_states_provinces_lines')
sites <- read.csv('p:/obrien/randomr/2018section6_receivers.csv',
                  stringsAsFactors = F)

library(ggplot2); library(ggsn)
far_plot <- ggplotGrob(
  ggplot() +
  geom_sf(data = far) +
  geom_sf(data = far_states) +
  geom_point(data = sites, aes(x = long, y = lat,
                               color = group, shape = type), size = 0.5) +
  coord_sf(xlim = c(-77, -75), ylim = c(37, 39.5), datum = NA) +
  annotate('rect', xmin = -76, xmax = -75.56, ymin = 38.25, ymax = 38.69,
           color = 'red', fill = NA) +
  labs(x = NULL, y = NULL) +
  theme_bw() +
  theme(legend.position = 'none')
)

close <- st_read('c:/users/secor/desktop/gis products/chesapeake/midatlantic',
                 'matl_states_land') %>%
  st_transform(4326)

marshy <- st_read('c:/users/secor/desktop/gis products/nanticoke2015',
                  'MarshNan') %>%
  st_transform(4326)



close_plot <- ggplot() +
  geom_sf(data = close) +
  geom_sf(data = marshy, fill = 'white') +
  geom_point(data = sites, aes(x = long, y = lat,
                               color = group, shape = type), size = 2) +
  coord_sf(xlim = c(-76, -75.56), ylim = c(38.25, 38.69), datum = NA) +
  scalebar(x.min = -75.8, x.max = -75.57,
           y.min = 38.25, y.max = 38.5,
           dist = 5, dd2km = T, model = 'WGS84') +
  labs(x = NULL, y = NULL, color = NULL, shape = NULL) +
  theme_bw() +
  theme(legend.justification = c(1, 0), legend.position = c(1, 0.1))


j <- close_plot +
  annotation_custom(grob = far_plot, xmin = -76.02, xmax = -75.83,
                               ymin = 38.49, ymax = 38.7)
north2(j, x = 0.1, symbol = 3)



library(sf)
j <- read_sf('c:/users/secor/desktop/gis products/usgs nhd/NHD_02080109_Nanticoke_HU8/nhdwaterbody.shp') %>%
  st_transform(4326)
plot(j$geometry)
k <- st_crop(j, xmin = -76.1, xmax = -75.4, ymin = 38.2, ymax = 38.8)
plot(k$geometry)
