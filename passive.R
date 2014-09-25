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

ggplot()+geom_path(data=pk.plot, aes(x=long, y=lat, group=group))+
  geom_point(data=yk.dat, aes(DD.Long,DD.Lat))





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
