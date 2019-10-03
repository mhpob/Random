library(ggplot2); library(dplyr); library(sf)

# Load data ----
# Land and WEA outlines using sf package, pull out MD and DE
coast <- st_read('c:/users/secor/desktop/gis products/geopackage files/atlcoast.gpkg') %>% 
  filter(STATE_ABBR %in% c('MD', 'DE'))
wea <- st_read('c:/users/secor/desktop/gis products/geopackage files/boem_lease.gpkg') %>% 
  filter(State %in% c('Maryland', 'Delaware'))

# Load sites
met_tower <- c(-74.753546, 38.352747)
mamm <- data.frame(Type = rep('Mamm', 3),
                   Trip = rep('Mamm', 3),
                   Site.ID = c('T-1', 'T-2', 'T-3'),
                   Lat = c(38.303, 38.336, 38.336),
                   Long = c(-74.949, -74.505, -74.350))
sites <- read.csv('p:/obrien/biotelemetry/ocmd-bsb/log4map.csv') %>% 
  filter(Trip == 'BSB17',
         Type == 'Tag') %>% 
  rbind(mamm) %>% 
  mutate(Type = case_when(Type == 'Tag' ~ 'Black Sea Bass',
                          T ~ 'Marine Mammal'))

# Plotting ----
ggplot() + 
  geom_sf(data = coast) +
  geom_sf(data = wea, fill = NA) +
  geom_point(aes(x = met_tower[1], y = met_tower[2]), pch = 8, size = 3) +
  geom_point(data = sites, aes(x = Long, y = Lat, col = Type),
             size = 3) +
  coord_sf(xlim = c(-75.22, -74.35), ylim = c(38.12, 38.56)) +
  labs(x = NULL, y = NULL, color = 'Monitoring Sites') +
  theme_bw() +
  theme(legend.position = c(0.85, 0.1)) 

# Save map
ggsave('BSB_Mamm_Tower_Map.jpg')
