bear2latlon <- function(lat, long, dist, bearing, radians = F){
  #lat/long is the basis point
  
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
  
  output <- cbind(lat2, long2)
  
  if(radians == F){
    output <- output * (180/pi)
  }
  return(output)
}

## VPS ----
# 100m lateral spacing
la_line <- lapply(c(350, 250, 150, 50, -50, -150, -250),
                      function(x) bear2latlon(38.223405, -74.756277, x, 300))
west_line <- lapply(la_line[3:7],
                     function(x) bear2latlon(x[1], x[2], 100, 240))
east_line <- lapply(la_line[3:7],
                     function(x) bear2latlon(x[1], x[2], 100, 360))


# 150m lateral spacing
la_line_150 <- lapply(c(375, 225, 75, -75, -225, -375),
                  function(x) bear2latlon(38.223405, -74.756277, x, 300))
west_line_150 <- lapply(la_line_150[2:6],
                    function(x) bear2latlon(x[1], x[2], 150, 240))
east_line_150 <- lapply(la_line_150[2:6],
                    function(x) bear2latlon(x[1], x[2], 150, 360))


# 200m lateral spacing
la_line_200 <- lapply(c(500, 300, 100, -100, -300, -500),
                      function(x) bear2latlon(38.223405, -74.756277, x, 300))
west_line_200 <- lapply(la_line_200[2:6],
                        function(x) bear2latlon(x[1], x[2], 200, 240))
east_line_200 <- lapply(la_line_200[2:6],
                        function(x) bear2latlon(x[1], x[2], 200, 360))


## Vessel runs ----
line0 <- lapply(c(1000, -1000),
                function(x) bear2latlon(38.223405, -74.756277, x, 300))
line100 <- lapply(line0,
                  function(x) bear2latlon(x[1], x[2], 100, 30))
line500 <- lapply(line0,
                  function(x) bear2latlon(x[1], x[2], 500, 30))

line1000 <- lapply(line0,
                  function(x) bear2latlon(x[1], x[2], 1000, 30))

# S avoidance point
bear2latlon(line0[[2]][1], line0[[2]][2], 1000, 210)
