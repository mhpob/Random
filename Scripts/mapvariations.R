library(raster); library(ggplot2); library(dplyr); library(rgdal)
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

mapdat <- shapefile('p:/obrien/gis/shapefiles/ches shape/nhdm/Chesapeake.shp')
mapdat <- fortify(mapdat)

york <- filter(mapdat, long <= -76.3 & long >= -77.1 & lat <= 37.7 & lat >= 37.18)

map <- ggplot() + geom_path(data = york, aes(long, lat, group = group))
map + coord_map()





map <- 'c:/users/secor lab/downloads/12244/12244_1.kap'


j <- brick(map)
k <- as(j,'SpatialPoints')
jx <- as.numeric(xres(j))
jy <- as.numeric(yres(j))
k <- rectify(j, res =c(2e-2, 5e-2))



info <- GDALinfo(map)

test <- open.SpatialGDAL(map)
k<-readGDAL(fname = map, OVERRIDE_PROJ_DATUM_WITH_TOWGS84 = T)
