library(dplyr); library(gdistance); library(raster); library(rgdal)

# Use custom shapefile
midstates <- shapefile('p:/obrien/gis/shapefiles/midatlantic/matl_states_land.shp')

# Create nonsense raster file to clip shapefile
ras.back <- raster(extent(-76.4, -69.89, 36.9, 42.7),
                   resolution = 1/360, #5 arc-second grids = 720, 10 = 360
                   vals = 1,
                   crs = proj4string(midstates))

# Also need to clip out a large portion of what will be ocean to save memory
mem.crop <- cbind(c(-75.8, -69.89, -69.89, -75.8), c(36.9, 36.9, 41.2, 36.9))
mem.crop <- SpatialPolygons(list(Polygons(list(Polygon(mem.crop)),
                                          'Memory-Wasting Ocean')),
                            proj4string = CRS(proj4string(midstates)))

# Create clipped raster from the shapefile-- Rasterize the water, drop the land
ras.water <- mask(mask(ras.back, mem.crop, inverse = T),
                  midstates, inverse = T)

rm(midstates, ras.back, mem.crop)

# Transition matrix between raster cells
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

rm(hud.trans16, uecsites, lecsites, allsites)

# Calculate paths using lc.dist() from marmap (iterative calc of multiple paths)
paths <- marmap::lc.dist(hud.geo16, all.mean, res = "path")
# Calculate distances of paths. Note that distances are in rounded km.
distances <- marmap::lc.dist(hud.geo16, all.mean, res = 'dist')

# Quick check that the paths worked
plot(ras.water, col = 'grey')
lines(paths[[1]][,1], paths[[1]][,2], col = 'red', lwd = 2)
points(all.mean, col = 'blue')

# Create GEarth KML paths
paths <- lapply(paths, cbind, 0)

for(i in seq(1,length(k))){ 
cat('<?xml version="1.0" encoding="UTF-8"?>\n<kml xmlns="http://earth.google.com/kml/2.1">\n<Document>\n<Placemark>\n<name>Path A</name>\n<LineString>\n<tessellate>1</tessellate>\n<coordinates>\n',
    file = paste0('path',i,'.kml'))
write.table(k[[i]], row.names = F, col.names = F, sep = ',',
            file = paste0('path',i,'.kml'), append = T)
cat('</coordinates>\n</LineString>\n</Placemark>\n</Document>\n</kml>',
    file = paste0('path',i,'.kml'), append = T)
}
