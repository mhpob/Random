library(raster); library(ggplot2); library(dplyr)
midstates <- shapefile('c:/users/secor/desktop/gis products/chesapeake/midatlantic/matl_states_land.shp')
pot <- midstates[midstates$STATE_ABBR %in% c('MD', 'VA', 'DC', 'DE'),]

pot <- fortify(pot)
stations <- read.csv('p:/obrien/biotelemetry/receivers/temp_rec.csv',
                     stringsAsFactors = F)

pdf('p:/obrien/biotelemetry/csi/MD SeaGrant.pdf')
ggplot() + geom_polygon(data = pot, fill = 'white', color = 'black',
                        aes(long,lat, group = group)) +
  coord_map(xlim = c(-77.4, -75.2), ylim = c(37.8, 39.6))  +
  geom_point(data = stations,
             aes(Long, Lat), shape = 21, color = 'black', fill = 'yellow', size = 5) +
  labs(x = '', y = '') + theme_bw()+
  theme(axis.ticks = element_blank(),
        axis.text = element_blank(),
        panel.background = element_rect(fill = 'lightblue'),
        panel.grid = element_blank())
dev.off()