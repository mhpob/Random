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
pass.dat$Detections <- as.factor(pass.dat$Detections)


det.plot <- function(system, cruise, circ.filt = F){
  map <- if(grepl('p', system, ignore.case = T)){
    pk.plot
  } else{
    yk.plot
  }
  
  sys.title <- ifelse(grepl('p', system, ignore.case = T), 'Pamunkey', 'York')
  sys.title <- paste(sys.title, cruise, sep = ' ')
  
  system <- if(grepl('p', system, ignore.case = T)){
    filter(pass.dat, grepl('PK', Site.ID))
  } else{
    filter(pass.dat, grepl('YK', Site.ID))
  }
  cruise <- filter(system, Cruise == cruise)


  circ.9 <- TelemetryR::ptcirc(select(cruise, DD.Long, DD.Lat), 900)
  circ.5 <- TelemetryR::ptcirc(select(cruise, DD.Long, DD.Lat), 500)
  if(circ.filt == T){
    cirselect <- function(cirpts, map){
      pts <- SpatialPoints(cirpts[,c('long','lat')],
                           proj4string = map@proj4string)
      pts.over <- over(pts, map)
      # might need to change column to a different identifier
      # (just looking for NA, here)
      pts.bad <- rownames(pts.over[is.na(pts.over$ID),])
      cirpts[!(rownames(cirpts) %in% pts.bad), ]
    }
    circ.9 <- cirselect(circ.9, york)
    circ.5 <- cirselect(circ.5, york)
  }
  
  
  ggplot() + geom_path(data = map, aes(x = long, y = lat, group = group)) +
    geom_polygon(data = circ.9,
                 aes(long, lat, group = circle), fill = 'red', alpha = 0.2) +
    geom_polygon(data = circ.5,
                 aes(long, lat, group = circle), fill = 'green', alpha = 0.3) +
    geom_point(data = cruise, aes(x = DD.Long, y = DD.Lat, size = Detections)) +
    scale_size_manual(values = c(1,3,5,7), breaks = c('0','1','2','3')) +
    labs(x = 'Longitude', y = 'Latitude', title = sys.title) 
}

det.plot('yk', '2014_1')
det.plot('yk', '2014_2')
det.plot('yk', '2014_3')
det.plot('yk', '2014_4')
det.plot('yk', '2014_5')

env.plot <- function(system, cruise, env.var, type = 'B'){
  map <- if(grepl('p', system, ignore.case = T)){
    pk.plot
  } else{
    yk.plot
  }
  sys.title <- ifelse(grepl('p', system, ignore.case = T), 'Pamunkey', 'York')
  sys.title <- paste(sys.title, cruise, sep = ' ')
  
  system <- if(grepl('p', system, ignore.case = T)){
    filter(pass.dat, grepl('PK', Site.ID))
  } else{
    filter(pass.dat, grepl('YK', Site.ID))
  }
  
  cruise <- filter(system, Cruise == cruise, Type == type)
  
  plot.call <-
    substitute(ggplot() +
    geom_path(data = map, aes(x = long, y = lat, group = group)) +
    geom_point(data = cruise,
               aes(x = DD.Long, y = DD.Lat, color = VAR),
               size = 10) +
    scale_color_gradient(low = 'blue', high = 'pink') +
    geom_point(data = cruise,
               aes(x = DD.Long, y = DD.Lat, size = Detections)) +
    scale_size_manual(values = c(1,3,5,7), breaks = c('0','1','2','3')) +
    labs(x = 'Longitude', y = 'Latitude', title = sys.title),
    list(VAR = as.name(env.var)))
  eval(plot.call)
}
  
env.plot('yk', '2014_5', 'Temp','S')
