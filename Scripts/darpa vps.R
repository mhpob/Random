bear2latlon <- function(lat, long, dist, bearing, radians = F){
  rad <- pi/180
  
  #Earth's radius in meters
  r <- 6378100
  
  #bearing in radians
  bearing <- bearing * rad
  
  lat <- lat * rad
  long <- long * rad
  
  lat2 <- asin(sin(lat) * cos(dist / r) + cos(lat) * sin(dist / r) * cos(bearing))
  long2 <- long + atan2(sin(bearing) * sin(dist / r) * cos(lat),
                          cos(dist / r) - sin(lat) * sin(lat2))
  
  output <- c(lat2, long2)
  
  if(radians == F){
    output <- output * (180/pi)
  }
  return(output)
}


center_line <- lapply(c(250, 150, 50, -50, -150, -250),
                      function(x) bear2latlon(38.223405, -74.756277, x, 300))
south_line <- lapply(center_line[2:6],
                     function(x) bear2latlon(x[1], x[2], 100, 240))
north_line <- lapply(center_line[2:6],
                     function(x) bear2latlon(x[1], x[2], 100, 360))



