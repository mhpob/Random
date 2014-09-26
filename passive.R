library(rgdal); library(ggplot2); library(dplyr)

## Load shapefiles. Shapefiles downloaded from USGS.
york <- readOGR('p:/obrien/gis/shapefiles', 'YKPKRivs')

york@data$ID <- ifelse(york@data$FTYPE %in% c(364, 460), 'pk', 'yk')
york <- spChFIDs(york, paste0(york@data$ID, row.names(york)))

## fortify() to turn the object into a data frame suitable for 
# plotting with ggplot2
yk.df <- fortify(york)

## filter() out the points I don't want to have plotted.
yk.plot <- filter(yk.df, grepl('yk', group))
pk.plot <- filter(yk.df, grepl('pk', group))

## Detection data
pass.dat <- read.csv('p:/obrien/biotelemetry/csi/listening/activedata.csv',
                     header = T, stringsAsFactors = F)
pk.dat <- filter(pass.dat, grepl('PK', Site.ID))
yk.dat <- filter(pass.dat, grepl('YK', Site.ID))



cirselect <- function(cirpts, map){
  pts <- SpatialPoints(cirpts[,c('long','lat')], proj4string = map@proj4string)
  pts.over <- over(pts, map)
  # might need to change column to a different identifier
  # (just looking for NA, here)
  pts.bad <- rownames(pts.over[is.na(pts.over$ID),])
  cirpts[!(rownames(cirpts) %in% pts.bad), ]
}

cruise3 <- filter(pk.dat, Cruise == '2014_4')
circ1 <- TelemetryR::ptcirc(select(cruise3, DD.Long, DD.Lat), 900)
circ1 <- cirselect(circ1, york)
circ2 <- TelemetryR::ptcirc(select(cruise3, DD.Long, DD.Lat), 500)
circ2 <- cirselect(circ2, york)

ggplot() + geom_path(data = pk.plot, aes(x = long, y = lat, group = group)) +
  geom_polygon(data = circ1,
            aes(long, lat, group = circle), fill = 'red', alpha = 0.2) +
  geom_polygon(data = circ2,
            aes(long, lat, group = circle), fill = 'green', alpha = 0.3) +
  geom_point(data = cruise3, aes(x = DD.Long, y = DD.Lat))
