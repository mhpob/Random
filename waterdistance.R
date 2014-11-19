library(marmap); library(gdistance); library(raster); library(dplyr)
library(rgdal)
# From marmap package, but bathymetric data doesn't go as far inland as needed.
# hudson <- getNOAA.bathy(-75.6, -73.6, 38.7, 42.7, 1)

# Will now try to use custom shapefile
midstates <- shapefile('p:/obrien/gis/shapefiles/midatlantic/matl_states_land.shp')

# Create nonsense raster file to clip shapefile
ras.back <- raster(extent(-75.6, -73.6, 38.7, 42), ##CHANGE TO ACCOMODATE ALL SITES!!!!!!!
                   resolution = 1/720, #Half arc-second grids
                   vals = 1,
                   crs = proj4string(midstates))
# Also need to clip out a large portion of what will be ocean for memory
mem.crop <- cbind(c(-75.8, -69.8, -69.8, -75.8), c(37, 37, 41.2, 37))
mem.crop <- SpatialPolygons(list(Polygons(list(Polygon(mem.crop)),
                                          'Memory-Wasting Ocean')),
                            proj4string = CRS(proj4string(midstates)))

ras.tri <- mask(ras.back, mem.crop, inverse = T)

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

all.mean <- allsites %>%
  mutate(Longitude = ifelse(Longitude >= 0, -Longitude, Longitude)) %>%
  select(Station.Name, Latitude, Longitude) %>%
  group_by(Station.Name) %>%
  summarize(Lat = mean(Latitude), Lon = mean(Longitude)) %>%
  as.data.frame()

row.names(all.mean) <- all.mean[, 1]
all.mean <- all.mean[, c(3, 2)]


# Calculate paths using lc.dist() from marmap (iterative calc of multiple paths)
paths <- lc.dist(hud.geo16, all.mean, res = "path")
# Calculate distances of paths. Note that distances are in rounded km.
distances <- lc.dist(hud.geo16, all.mean, res = 'dist')

# Check that the paths worked
plot(ras.water, col = 'grey')
lines(paths[[1]][,1], paths[[1]][,2], col = 'red', lwd = 2)
points(uec.mean, col = 'blue')

# Create GEarth KML paths
k <- lapply(paths, cbind, 0)

for(i in seq(1,length(k))){ 
cat('<?xml version="1.0" encoding="UTF-8"?>\n<kml xmlns="http://earth.google.com/kml/2.1">\n<Document>\n<Placemark>\n<name>Path A</name>\n<LineString>\n<tessellate>1</tessellate>\n<coordinates>\n',
    file = paste0('output',i,'.kml'))
write.table(k[[i]], row.names = F, col.names = F, sep = ',',
            file = paste0('output',i,'.kml'), append = T)
cat('</coordinates>\n</LineString>\n</Placemark>\n</Document>\n</kml>',
    file = paste0('output',i,'.kml'), append = T)
}
