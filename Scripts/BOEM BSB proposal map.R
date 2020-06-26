library(dplyr);library(sf)

blocks <- read_sf('boem_lease.gpkg')
blocks <- blocks %>% 
  filter(grepl('Mar|Del', State))


land <- read_sf('p:/obrien/midatlantic/matl_states_land.shp') %>% 
  filter(!is.na(STATE_NAME))


sites <- readxl::read_excel('p:/obrien/biotelemetry/ocmd-bsb/experimental sites and corresponding wrecks.xlsx',
                            skip = 1) %>% 
  filter(!is.na(`Lat DD`) & !grepl('African', Name)) %>% 
  st_as_sf(coords = c('Long DD', 'Lat DD'),
           crs = st_crs(blocks))


library(ggplot2)

ggplot() +
  geom_sf(data = land, size = 1) + 
  geom_sf(data = blocks, fill = NA, size = 1) +
  geom_sf(data = sites, color = 'red', size = 5) +
  coord_sf(xlim = c(-75.2, -74.52), ylim = c(38.15, 38.55)) +
  scale_x_continuous(breaks = seq(-75.2, -74.52, by = 0.2)) +
  geom_sf_text(data = sites, aes(label = Name),
               nudge_x = c(0.1, -0.2),
               size = 16 / .pt) +
  annotate('text', label = 'italic("Ocean City Inlet")', parse = T,
           x = -75.015, y = 38.325) +
  labs(x = NULL, y = NULL) +
  theme_minimal() +
  theme(axis.text = element_text(size = 12),
        axis.text.y = element_text(angle = 90, hjust = 0.5))

