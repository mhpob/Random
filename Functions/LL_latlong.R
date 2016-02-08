
LL_latlong <- function(ll_xml){
  library(XML)
  light_list <- xmlTreeParse(ll_xml)
  light_list <- xmlRoot(light_list)
  
  # Get ready for XPath
  lat <- as.character(grep('Latitude', names(light_list[[2]][[1]]), value = T))
  lat <- paste0('//', lat)
  
  long <- as.character(grep('Longitude', names(light_list[[2]][[1]]), value = T))
  long <- paste0('//', long)
  
  # XPath to pull out Lat/Long
  lat <- getNodeSet(light_list, lat)
  long <- getNodeSet(light_list, long)
  
  # Grab values
  lat <- sapply(lat, xmlSApply, xmlValue)
  long <- sapply(long, xmlSApply, xmlValue)
  
  # Bind info
  buoys <- data.frame(lat = lat, long = long, stringsAsFactors = F)
  
  # Light list Lat/Long to decimal degrees
  buoys$lat.spl <- strsplit(buoys[, 'lat'],'-|N')
  buoys$long.spl <- strsplit(buoys[, 'long'],'-|W')
  
  buoys$lat.spl <- lapply(buoys[,'lat.spl'], as.numeric)
  buoys$long.spl <- lapply(buoys[,'long.spl'], as.numeric)
  
  ll2dd <- function(x){
    sapply(x, '[[', 1) +
      sapply(x, '[[', 2)/60 +
      sapply(x, '[[', 3)/3600
  }
  
  buoys$lat <- ll2dd(buoys[,'lat.spl'])
  buoys$long <- ll2dd(buoys[, 'long.spl'])
  
  buoys <- buoys[, 1:2]
  buoys
}

