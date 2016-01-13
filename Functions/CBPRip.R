

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


start = '1984-01-16'
end = Sys.Date()
geo.attribute = 'Station'
geo.ids = 1599
params = c(21,31)

data.<- CBPRip(start, end, geo.attribute, geo.ids, params)
