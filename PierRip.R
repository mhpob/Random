# This function rips water quality data from the CBL Pier Storm Central Water Log site
# https://stormcentral.waterlog.com/SiteDetails.php?a=88&site=1&pa=CBLPier
# between specified dates/times in ymd_hms format

cblpier <- function(stdate = '2014-03-04 00:00:00', enddate = as.character(Sys.time())){
  library(lubridate)
  tounix <- function(x){
    as.numeric(
      ymd_hms(
        ifelse(nchar(x) <= 14, paste(unlist(strsplit(x,' '))[1], '00:00:00'), x)
      ))
  }
  
  stdate <- tounix(stdate)
  enddate <- tounix(enddate)
  
  range <- enddate - stdate
  
  url <- paste0('https://stormcentral.waterlog.com/xml/SiteDetailsSiteData.php?',
                'Site=1&Acct=88&Start=', stdate, '&Range=', range)
  
  xmltree <- readLines(url)
  
  datacode <- unlist(strsplit(xmltree[3], '<SiteData>'))[2]
  datacode <- unlist(strsplit(datacode, '</SiteData>'))[1]
  pierdata <- read.csv(paste0('https://stormcentral.waterlog.com/download.php/data/',
                      datacode, '-d.csv?filename=thisdoesntmatter'),
                      skip = 1, header = T, 
                      na.strings = c('NA', '-99.99'), stringsAsFactors = F)
  
  # Drop short-lived second sonde if in data
  if(T %in% grepl('EXO2_2', names(pierdata))) {
    pierdata <- pierdata[,-(3:8)]
  }
  
  # Drop empty samples
  pierdata <- pierdata[rowSums(is.na(pierdata)) != 8,]
  
  # Formatting
  pierdata$Date <- mdy_hms(paste(pierdata$Date, pierdata$Time))
  pierdata <- pierdata[, -2]
  row.names(pierdata) <- NULL
  names(pierdata)[2:9] <- c('Temp', 'SpCond', 'Turb', 'DO_pct',
                            'DO_con', 'Depth', 'Sal', 'Batt')
  units <- list(Temp = 'Degrees Celsius', SpCond = 'microSeimens/centimeter',
           Turb = 'Nephelometric Turbidity Units', DO_pct = 'Percent Saturation',
           DO_con = 'milligrams/Liter', Depth = 'Meters', Sal = '', Batt = 'Volts')
  
  list(units, pierdata)
}


# Using RCurl, XML packages
# xmltree <- getURL('https://stormcentral.waterlog.com/xml/SiteDetailsSiteData.php?Site=1&Acct=88&Start=0&Range=864000000', ssl.verifypeer = F)
# root <- xmlRoot(xmlTreeParse(xmltree, getDTD = F))
# datacode <- xmlSApply(root[[1]], xmlValue)[1]
#
# Then continue with 'pierdata <- read.csv(...)'



