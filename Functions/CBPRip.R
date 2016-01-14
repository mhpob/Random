## Pull waater quality data from Chesapeake Bay Program's DataHub
## http://data.chesapeakebay.net/WaterQuality
## 
## Inputs
## start   start date in yyyy-mm-dd format. Default is first day of available
##         data (1984-01-16).
## end     end date in yyyy-mm-dd format. Default is today's date.
## geo.attribute     Level of geographic aggregation.
##                   "HUC8" = Hydrologic unit
##                   "HUC12" = Small watershed
##                   "FIPS" = County/City
##                   "CBSeg2003" = Monitoring segment
##                   "SegmentShed2009" = Monitoring segment/shed
##                   "Station" = Monitoring station
## geo.ids     vector of station IDs within provided geo.attribute
## params    vector of parameter IDs
## 
## M. O'Brien  20160113
## obrien@umces.edu

CBPRip <- function(start = '1984-01-16', end = Sys.Date(), geo.attribute,
                   geo.ids, params){
  date.seq <- seq(as.Date(start), as.Date(end), by = '5 year')
  
  # Make sure end date is within sequence. If not, add it.
  if(date.seq[length(date.seq)] < as.Date(end)){
    date.seq <- c(date.seq, as.Date(end))
  }
  
  # Make URLs.
  urls <- NULL
  for(i in seq(1, length(date.seq) - 1)){
    urls <- c(urls,
            paste('http://data.chesapeakebay.net/api.CSV/WaterQuality/WaterQuality',
                  date.seq[i], date.seq[i + 1],
                  '2,4,6/12,13,14,15,2,3,11,7,23,24,16',
                  geo.attribute,
                  paste(geo.ids, collapse = ','),
                  paste(params, collapse = ','),
                  sep = '/'))
  }
  
  # This function just adds a progress bar. Pretty, but not important.
  lapply_pb <- function(X, FUN, ...){
    env <- environment()
    pb_Total <- length(X)
    counter <- 0
    pb <- txtProgressBar(min = 0, max = pb_Total, style = 3)
  
    # wrapper around FUN
    wrapper <- function(...){
      curVal <- get("counter", envir = env)
      assign("counter", curVal +1 ,envir=env)
      setTxtProgressBar(get("pb", envir=env), curVal +1)
      FUN(...)
    }
    res <- lapply(X, wrapper, ...)
    close(pb)
    res
  }
  
  # Data has a footer which prevents class identification. This function removes
  # the footer before class identification occurs.
  read.csv_nofooter <- function(X){
    data.loc <- url(X)
    data <- suppressWarnings(textConnection(head(readLines(data.loc), -1)))
    data <- read.csv(data, stringsAsFactors = F)
    close(data.loc)
    data
  }
  
  # Use functions created above to import into list.
  data <- lapply_pb(urls, read.csv_nofooter)
  # Merge list into a data frame.
  data <- do.call(rbind.data.frame, data)
  data
}

## Example usage:
# st.date = '1987-02-20'
# end.date = '2005-12-31'
# level = 'Station'
# stations = 1599
# wq.variables = c(21,31)
# 
# data <- CBPRip(start = start.date, end = end.date,
#                geo.attribute = level, geo.ids = stations,
#                params = wq.variables)
