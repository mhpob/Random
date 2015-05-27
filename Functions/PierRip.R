# This function rips water quality data from the CBL Pier Storm Central Water Log site
# http://stormcentral.waterlog.com/SiteDetails.php?a=88&site=2&pa=CBLPier
# between specified dates/times in ymd_hms format


cblpier <- function(stdate = '2015-03-31 00:00:00',
                    enddate = as.character(Sys.time())){
  library(lubridate)
  tounix <- function(x){
    as.numeric(
      lubridate::ymd_hms(
        ifelse(nchar(x) <= 14, paste(unlist(strsplit(x, ' '))[1], '00:00:00'), x)
      ))
  }
  
  stdate <- tounix(stdate)
  enddate <- tounix(enddate)
  
  range <- enddate - stdate
  
  url <- paste0('http://stormcentral.waterlog.com/xml/SiteDetailsSiteData.php?',
                'Site=2&Acct=88&Start=', stdate, '&Range=', range)
  
  xmltree <- readLines(url)
  
  datacode <- unlist(strsplit(xmltree[3], '<SiteData>'))[2]
  datacode <- unlist(strsplit(datacode, '</SiteData>'))[1]
  pierdata <- read.csv(
    paste0('http://stormcentral.waterlog.com/download.php/data/',
           datacode, '-d.csv?filename=thisdoesntmatter'),
    skip = 1, header = T,
    na.strings = c('NA', '-99.99'), stringsAsFactors = F)
  
  # Drop short-lived second sonde if in data
  if(T %in% grepl('EXO2_2', names(pierdata))) {
    pierdata <- pierdata[, -(3:8)]
  }
  
  # Drop empty samples
  pierdata <- pierdata[rowSums(is.na(pierdata)) != 13,]
  
  # Formatting
  pierdata$Date <- mdy_hms(paste(pierdata$Date, pierdata$Time))
  pierdata <- pierdata[, -2]
  row.names(pierdata) <- NULL
  names(pierdata)[2:12] <- lapply(strsplit(names(pierdata)[2:12], '[.]'), '[', 2)
  
  pierdata
}