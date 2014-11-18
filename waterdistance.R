library(marmap); library(gdistance); library(raster); library(dplyr)
library(rgdal)
# From marmap package, but bathymetric data doesn't go as far inland as needed.
# hudson <- getNOAA.bathy(-75.6, -73.6, 38.7, 42.7, 1)

# Will now try to use custom shapefile
midstates <- shapefile('p:/obrien/gis/shapefiles/midatlantic/matl_states_land.shp')
midstates <- midstates[midstates@data$STATE_ABBR %in% c('NY','CT','NJ','DE','PA'),]

# Create nonsense raster file to clip shapefile
ras.back <- raster(extent(-75.6, -73.6, 38.7, 42),
                   resolution = 1/720, #Half arc-second grids
                   vals = 1,
                   crs = proj4string(midstates))
# Create clipped raster from the shapefile-- Rasterize the water, drop the land
ras.water <- mask(ras.back, midstates, inverse = T)
# Transition matrix
hud.trans16 <- transition(ras.water, transitionFunction = function(x){1}, 16)
# Geographic correction
hud.geo16 <- geoCorrection(hud.trans16, type = 'c')

#Import site locations
uecsites <- read.csv(
  'c:/users/secor lab/desktop/hbailey/nyharbour_datafile_uec.csv',
  header = T, stringsAsFactors = F)
lecsites <- read.csv(
  'c:/users/secor lab/desktop/hbailey/nyharbour_datafile_lec.csv',
  header = T, stringsAsFactors = F)
allsites <- rbind(uecsites, lecsites)

uec.mean <- uecsites %>%
  mutate(Longitude = ifelse(Longitude >= 0, -Longitude, Longitude)) %>%
  select(Station.Name, Latitude, Longitude) %>%
  group_by(Station.Name) %>%
  summarize(Lat = mean(Latitude), Lon = mean(Longitude)) %>%
  filter(Lat <= 42, Lat >= 38.7, Lon <= -73.6, Lon >= -75.6) %>%
  sample_n(10) %>%
  as.data.frame()

row.names(uec.mean) <- uec.mean[,1]
testsites <- uec.mean[,c(3,2)]


# Calculate paths using lc.dist() from marmap (iterative calc of multiple paths)
paths <- lc.dist(hud.geo, testsites, res = "path")
# Calculate distances of paths. Note that distances are in rounded km.
distances <- lc.dist(hud.geo, testsites, res = 'dist')

# Check that the paths worked
plot(ras.water, col = 'grey')
lines(paths[[1]][,1], paths[[1]][,2], col = 'red', lwd = 2)
points(uec.mean, col = 'blue')

# Create GEarth KML paths
k <- lapply(paths, cbind, 0)

for(i in length(k)){ 
cat('<?xml version="1.0" encoding="UTF-8"?>\n<kml xmlns="http://earth.google.com/kml/2.1">\n<Document>\n<Placemark>\n<name>Path A</name>\n<LineString>\n<tessellate>1</tessellate>\n<coordinates>\n',
    file = paste0('output',i,'.kml'))
write.table(k[[i]], row.names = F, col.names = F, sep = ',',
            file = paste0('output',i,'.kml'), append = T)
cat('</coordinates>\n</LineString>\n</Placemark>\n</Document>\n</kml>',
    file = paste0('output',i,'.kml'), append = T)
}
