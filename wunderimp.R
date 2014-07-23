###############################################################################
## Import archived meteorological data from wunderground.com
##
## station = station name or airport code (in quotes)
## start = start date (ymd, in quotes)
## end = end date (ymd, in quotes)
##
## Example: data <- wunderimp('KWAL', '1999-01-10', '2005-10-15')
###############################################################################
## Frequently used airport codes:
## Ocean City, MD == KOXB
## Wallops Island, MD  == KWAL
## PAX NAS == KNHK
###############################################################################

if(('lubridate' %in% installed.packages()) == F) install.packages('lubridate')
library(lubridate)

wunderimp <- function (station, start, end = Sys.Date()) {
  end <- ymd(end)
  startyr <- year(seq(ymd(start), end, by = 'year'))
  
  url <- paste0("http://www.wunderground.com/history/airport/", station, "/",
                startyr, "/", month(start), "/", day(start),
                "/CustomHistory.html?dayend=", day(end), "&monthend=", month(end),
                "&yearend=", year(end), "&format=1")
  
  data <- lapply(url, read.csv)
  
  # rbind() will not work unless all colnames are the same. If start and end
  # time zones are different, this is reflected in Wundergrounds colnames.
  for(i in seq(1:length(data))){
    names(data[[i]])[1] <- 'Date'
  }

  data <- do.call(rbind.data.frame, data)
  date <- unique(data)
  
  # Remove HTML breaks from final column
  data[,23] <- as.numeric(do.call(rbind, strsplit(as.character(data[, 23]), '<br />')))
  names(data)[23]<- "WindDirDeg"
  
  data
}