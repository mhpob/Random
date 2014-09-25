library(rgdal); library(maptools); library(ggplot2); library(dplyr)

## Load shapefiles. Shapefiles downloaded from USGS.
pam <- readOGR('c:/users/secor lab/downloads/nhd_02080106_pamunkey_hu8',
               'NHDArea')
york <- readOGR('c:/users/secor lab/downloads/nhd_02080107_york_hu8','NHDArea')
ches <- readOGR('c:/users/secor lab/downloads/nhd_02080101_lower_chesapeake_bay_hu8','NHDWaterbody')

## Change feature IDs so that the shapefiles can be bound together
# (to use rbind, there can not be duplicate IDs)
# IDs are usually "0" to (length of the shapefile) - 1
# View say, the first ID using something like: pam@polygons[[1]]@ID
# Also, the Chesapeake shapefile must adjusted so the columns are the same.
pam <- spChFIDs(pam, paste0('pk', row.names(pam)))
york <- spChFIDs(york, paste0('yk', row.names(york)))
ches <- spChFIDs(ches, paste0('cb', row.names(ches)))
ches <- ches[,c(12,6,7,3,2,1,4,5,9,10,11)]

all.yk <- rbind(pam, york)
all.yk <- rbind(all.yk, ches)

## fortify() to turn the object into a data frame suitable for 
# plotting with ggplot2
yk.df <- fortify(all.yk)

## filter() out the points I don't want to have plotted.
yk.df <- filter(yk.df, long <= -76.3, long >= -77.2,
               lat <= 37.7, lat >= 37.18)
yk.df <- filter(yk.df, !(long >=-76.5 & lat >= 37.268))

# ggplot(data = yk.df, aes(long, lat, group = group)) + geom_polygon(fill = NA) +
#   geom_path(color = 'black')

pass.dat <- read.csv('p:/obrien/biotelemetry/csi/listening/activedata.csv',
                     header = T, stringsAsFactors = F)
pass.dat$Detections <- factor(pass.dat$Detections)


mapbase <- ggplot(yk.df) +
  geom_path(aes(long, lat, group = group), color = 'black') + theme_bw()

mapbase + geom_point(data = filter(pass.dat, Cruise == '2014_1'),
                     aes(DD.Long, DD.Lat, size = Detections),
                     color = 'red') +
  ggtitle('2014_1') + scale_size_manual(values = c(1,4,8,12),
                                        breaks = c(0,1,2,3))
  
mapbase + geom_point(data = filter(pass.dat, Cruise == '2014_2'),
                     aes(DD.Long, DD.Lat, size = Detections),
                     color = 'red') +
  ggtitle('2014_2') + scale_size_manual(values = c(1,4,8,12),
                                        breaks = c(0,1,2,3))
mapbase + geom_point(data = filter(pass.dat, Cruise == '2014_3'),
                     aes(DD.Long, DD.Lat, size = Detections),
                     color = 'red') +
  ggtitle('2014_3') + scale_size_area(limits = c(0,3),
                                      breaks = c(0,1,2,3))
mapbase + geom_point(data = filter(pass.dat, Cruise == '2014_4'),
                     aes(DD.Long, DD.Lat, size = Detections),
                     color = 'red') +
  ggtitle('2014_4') + scale_size_manual(values = c(1,4,6,8))
