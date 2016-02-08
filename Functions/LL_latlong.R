
LL_latlong <- function(ll_xml){
  library(XML)
  pb <- txtProgressBar(0, 100)
  setTxtProgressBar(pb, 1)
  
  light_list <- xmlTreeParse(ll_xml)
  light_list <- xmlRoot(light_list)
  
  setTxtProgressBar(pb, 10)
  # Get ready for XPath
  lat <- as.character(grep('Latitude', names(light_list[[2]][[1]]), value = T))
  lat <- paste0('//', lat)
  
  setTxtProgressBar(pb, 15)

  long <- as.character(grep('Longitude', names(light_list[[2]][[1]]), value = T))
  long <- paste0('//', long)
  
  setTxtProgressBar(pb, 20)
  
  # XPath to pull out Lat/Long
  lat <- getNodeSet(light_list, lat)
  setTxtProgressBar(pb, 45)
  
  long <- getNodeSet(light_list, long)
  setTxtProgressBar(pb, 70)
  
  # Grab values
  lat <- sapply(lat, xmlSApply, xmlValue)
  setTxtProgressBar(pb, 80)
  long <- sapply(long, xmlSApply, xmlValue)
  setTxtProgressBar(pb, 90)
  
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
  setTxtProgressBar(pb, 100)
  buoys
  
}

