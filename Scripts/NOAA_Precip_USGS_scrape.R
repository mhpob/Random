
# Pull data from CO-OPS (NOAA Tides and Currents) -------------------------
## Visit http://tidesandcurrents.noaa.gov/api/ for full API

## Water Level ----
### Treated differently from other products due to datum specification

### Build URLs to ping water level data
datum <- c('MLW', 'MSL', 'MHW')
WL.urls <- paste('http://tidesandcurrents.noaa.gov/api/datagetter?range=24',
                 '&station=8577330&product=water_level&datum=', datum,
                 '&units=metric&time_zone=lst_ldt&application=UMCES&format=csv',
                 sep = '')

### Read each datum into a component of a list
### Name each component according to its datum
WL.data <- lapply(WL.urls, read.csv)

### Rewrite column names (but not Date.Time) to identify the water level datum
for(i in seq(1, length(datum))){
  names(WL.data[[i]])[!names(WL.data[[i]]) == 'Date.Time'] <- 
    paste(datum[i],
          names(WL.data[[i]])[!names(WL.data[[i]]) == 'Date.Time'],
          sep = '.')
}

### Merge the list
WL.data <- Reduce(merge, WL.data)

## Other products ----
product <- c('air_temperature', 'water_temperature', 'wind', 'air_pressure')
other.urls <- paste('http://tidesandcurrents.noaa.gov/api/datagetter?range=24',
                    '&station=8577330&product=', product,
                    '&units=metric&time_zone=lst_ldt&application=UMCES&format=csv',
                    sep = '')
other.data <- lapply(other.urls, read.csv)

### Rewrite column names (but not Date.Time) to identify the X/N/R columns
for(i in seq(1, length(product))){
  names(other.data[[i]])[grepl('X|N|R', names(other.data[[i]]))] <-
    paste(names(other.data[[i]])[2],
          grep('X|N|R', names(other.data[[i]]), value = T),
          sep = '.')
}

other.data <- Reduce(merge, other.data)

## Combine products, format time class using lubridate package ----
data <- merge(other.data, WL.data)
library(lubridate, warn.conflicts = F)
data$Date.Time <- ymd_hm(data$Date.Time, tz = 'America/New_York')

## Aggregate to 15 min intervals
data$Date.Time <- floor_date(data$Date.Time, unit = '15 minutes')
data <- aggregate(. ~ Date.Time, data = data, mean)

## Clean up the effects of aggregating characters
data[, grep('Quality', names(data), value = T)] <- 'P'
data <- data[, names(data) != 'Direction.1']

## If one of the 6-min QA/QC measures were marked as "1", label the 15-min
## interval as 1
data[, grep('.[XNROFL]$', names(data), value = T)] <-
  ifelse(data[, grep('.[XNROFL]$', names(data), value = T)] != 0, 1, 0)

### Clear some memory
rm(list = setdiff(ls(), 'data'))


# Pull rain data from station at CBL Visitor's Center ---------------------
## Use rvest (https://github.com/hadley/rvest) to scrape data
library(rvest, quietly = T)
CBLVC.str <- read_html('http://facwebsrv1.cbl.umces.edu/weather/daily.htm') %>%
  html_nodes(xpath = '/html/body/pre[8]') %>% 
  html_text()

## Translate scraped HTML into table, pulling the date for later used
date <- read.table(file = textConnection(CBLVC.str), nrows = 1)
CBLVC <- read.table(file = textConnection(CBLVC.str), skip = 3,
                    allowEscapes = T, stringsAsFactors = F)

## Sort out the dates
CBLVC <- cbind(date, CBLVC[c('V1', 'V16')])
CBLVC$Date.Time <- paste(CBLVC[, 1], CBLVC[, 2])
CBLVC$Date.Time <- mdy_hm(CBLVC$Date.Time, tz = 'America/New_York')

## Convert rainfall from in/hr to mm/hr
CBLVC$Rain.mm <- CBLVC$V16 * 25.4
CBLVC <- CBLVC[, c('Date.Time', 'Rain.mm')]

## Combine products, clear some memory
data <- merge(data, CBLVC, all = T)
rm(list = setdiff(ls(), 'data'))
detach('package:rvest', unload = T)



# Scrape discharge from USGS Bowie Patuxent Gauge -------------------------
## Pull from https://waterdata.usgs.gov/usa/nwis/uv?01594440
## Visit https://help.waterdata.usgs.gov/faq/automated-retrievals#RT for API
## Created the URL below through paste just so  it can be seen without scrolling
USGS.url <- paste('https://waterservices.usgs.gov/nwis/iv/?format=rdb',
                  '&sites=01594440&period=P1D&parameterCd=00060',
                  sep = '')

USGS <- read.delim(USGS.url, comment.char = '#', stringsAsFactors = F)
USGS <- USGS[-1, c(3,5,6)]
names(USGS) <- c('Date.Time', 'Discharge_m3s', 'Discharge_cd')

## Convert from ft^3/s to m^3/s
USGS$Discharge_m3s <- as.numeric(USGS$Discharge_m3s) * 0.028317

## Sort out the dates, round to the nearest 6min using lubridate package.
USGS$Date.Time <- ymd_hm(USGS$Date.Time, tz = 'America/New_York')

## Combine products, clear some memory
data <- merge(data, USGS, all = T)


write.csv(data, file = paste(
  file.path('C:/Users/secor/Desktop',
            format(Sys.time(), "%Y%m%d %HH%MM%SS")), '.csv', sep = ''),
  row.names = F)
