# This pings an applet provided by http://www.nearby.org.uk/google.html
# to create a circle fixed around a point in KML. Your browser will download all
# files, open them to add them to your Google Earth library.
#
# Code uses degree, minute, seconds to allow copy/paste from Google Earth. Make
# sure the degree and prime symbols are removed before running (see example).
# Radius should be in kilometers, but the code can be adjusted for different units.

GEcircles <- function (lat, long, radius, color) {
  DDlong <- function (x){
    d <- as.numeric(substr(x, 2, 3))
    m <- as.numeric(substr(x, 5, 6)) / 60
    s <- as.numeric(substr(x, 8, 15)) / 3600
    -d - m - s
  }
  DDlat <- function(x){
    d <- as.numeric(substr(x, 1, 2))
    m <- as.numeric(substr(x, 4, 5)) / 60
    s <- as.numeric(substr(x, 7, 15)) / 3600
    d + m + s
  }
  
  dmslat <- DDlat(lat) 
  dmslong <- DDlong(long)
  
  # Converts color to KML color code
  circ.col <- col2rgb(color)
  circ.col <- rgb(circ.col[1], circ.col[2], circ.col[3], 255, maxColorValue = 255)
  circ.col <- paste0(substr(circ.col, 8, 9), substr(circ.col, 6, 7),
                     substr(circ.col, 4, 5), substr(circ.col, 2, 3))
  
  urls <- paste0("http://www.nearby.org.uk/google/circle.kml.php?radius=", radius,
                "km&lat=", dmslat, "&long=", dmslong, "&geomColor=", circ.col)
  
  invisible(sapply(urls, shell.exec))
}

## Example usage:
# buoys <- data.frame(rbind(c('38 19 1.71', '-76 27 4.07'),
#                           c('38 18 40.44', '-76 18 40.81'),
#                           c('38 18 56.44', '-76 17 3.80'),
#                           c('38 18 27.13', '-76 19 55.57')), stringsAsFactors = F)
# names(buoys) <- c('lat','long')
# 
# GEcircles(buoys$lat, buoys$long, 0.9, 'red')
