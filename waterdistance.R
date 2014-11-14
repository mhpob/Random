library(marmap); library(gdistance); library(raster); library(dplyr)
library(rgdal)
# From marmap package, but bathymetric data doesn't go as far inland as needed.
# hudson <- getNOAA.bathy(-75.6, -73.6, 38.7, 42.7, 1)

# Will now try to use custom shapefile
midstates <- shapefile('p:/obrien/gis/shapefiles/midatlantic/matl_states_land.shp')

# Create nonsense raster file to clip shapefile
ext <- extent(-75.6, -73.6, 38.7, 42.7)
xy <- abs(apply(as.matrix(bbox(ext)), 1, diff))
ras <- function(xy, n) raster(ext, ncol = xy[1] * n, nrow = xy[2] * n)
ras.back <- ras(xy, 800)
ras.back[] <- 1
proj4string(ras.back) <- proj4string(midstates)
# Create clipped raster from the shapefile
ras.mid <- rasterize(midstates, ras.back)
# Rasterize the water, drop the land
ras.water <- mask(ras.back, ras.mid, inverse = T)
# Make NAs 0 for least-distance calculation
# Might not need to do this. Should check.
ras.water[is.na(ras.water)] <- 0


hud.trans <- transition(ras.water, transitionFunction=function(x){1}, 4)
# Should use geoCorrection here
sites <- read.csv('c:/users/secor lab/downloads/nyharbour_datafile_uec.csv',
                  header = T, stringsAsFactors = F)

sites <- sites %>%
  mutate(Longitude = ifelse(Longitude >= 0, -Longitude, Longitude)) %>%
  select(Station.Name, Latitude, Longitude) %>%
  group_by(Station.Name) %>%
  summarize(Lat = mean(Latitude), Lon = mean(Longitude)) %>%
  filter(Lat <= 42) %>%
  as.data.frame()

row.names(sites) <- sites[,1]
sites <- sites[,c(3,2)]

#sites1 <- data.frame(x = c(-73.9407, -74.2181), y = c(41.1905, 40.4950))
out <- lc.dist(hud.trans, sites, res = "path")

lc.dist(trans1, sites, res = 'dist')

map <- getData("GADM", country = "USA", level = 1)
map <- map[map$NAME_1 %in% c("New York", "New Jersey"),]
plot(map, xlim = c(-74.4, -73.5), ylim = c(40.35, 41.25), col = 'grey')
lines(out[[1]][,1], out[[1]][,2], col = 'red', lwd = 2)
points(sites, col = 'blue')

# #create values for GEarth KML object
# k <- cbind(out1[[1]], 0)
# write.csv(k, "c:/users/secor lab/desktop/hold.csv", quote = F, row.names = F, col.names = F)

# hudmap <- shapefile('c:/users/secor lab/desktop/gis products/hr_morphology/dfw_hudson_river_morphology.shp')
# hudlat <- spTransform(hudmap, CRS('+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0'))
# hudlat
# plot(hudlat)

