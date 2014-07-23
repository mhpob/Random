library(raster); library(ggplot2)
source('circle.pts.R')

## Download map via raster package
hh <- getData("GADM", country = "USA", level = 1)
hh <- hh[hh$NAME_1 %in% c("Maryland", 'Virginia', 'Delaware', "District of Columbia", "Pennsylvania"),]

#geom_path and geom_polygon do different things, try both
ggplot() + geom_path(data = hh, aes(long,lat, group = group)) +
  coord_map(xlim = c(-77.5, -75.6), ylim = c(36.5, 39.75)) + theme_bw() +
  geom_path(data = circle.pts(c(-76.3113361, 38.3112333), 1000), aes(long,lat))

# # Use a shapefile:
# k<-shapefile('p:/obrien/gis/shapefiles/10m coastline_natural earth/ne_10m_land.shp')
# ggplot() + geom_path(data = k, aes(long, lat, group = group)) +
#   coord_map(xlim = c(-77.5, -69), ylim = c(36.5, 42)) + theme_bw()

