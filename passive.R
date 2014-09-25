library(rgdal); library(maptools); library(ggplot2); library(dplyr)

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

c1 <- filter(yk.dat, Cruise == '2014_1')
circ1 <- circle.pts(select(c1, DD.Long, DD.Lat), 1609.34)


ggplot() + geom_path(data = yk.plot, aes(x = long, y = lat, group = group))+
  geom_point(data = c1, aes(x = DD.Long, y = DD.Lat)) +
  geom_polygon(data = circ1,
            aes(long, lat, group = circle), color = 'green')

# Selecting parts of the circle within shapefile doesn't work quite yet.
# inLoc <-point.in.polygon(circ1[,1],circ1[,2], c1[,7],c1[,6])
# circ1 <- circ1[inLoc == 1,]


