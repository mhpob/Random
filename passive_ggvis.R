library(rgdal); library(ggplot2); library(ggvis); library(dplyr)

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
pass.dat$Detections <- as.factor(pass.dat$Detections)
yk.dat <- filter(pass.dat, grepl('YK', Site.ID))


ggvis(yk.dat, x = ~DD.Long, y = ~DD.Lat) %>%
  filter(Cruise == eval(input_select(choices = unique(yk.dat$Cruise)))) %>%
  layer_points(fill = ~Sal,
               size := 150) %>%
  scale_numeric('fill', range=c('blue','pink')) %>%
  layer_points(size = ~Detections) %>%
  scale_ordinal('size', domain = c(0, 1)) %>%
  layer_paths(x = ~long, y = ~lat, data = group_by(yk.plot, group))
  
