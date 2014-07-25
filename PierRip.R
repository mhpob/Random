# This script rips water quality data from the CBL Pier Storm Central Water Log site
# https://stormcentral.waterlog.com/SiteDetails.php?a=88&site=1&pa=CBLPier
# 
# In the future, I'd like to put in start/stop time arguments.
library(lubridate)

xmltree <- readLines('https://stormcentral.waterlog.com/xml/SiteDetailsSiteData.php?Site=1&Acct=88&Start=0&Range=864000000')

datacode <- unlist(strsplit(xmltree[3], '<SiteData>'))[2]
datacode <- unlist(strsplit(datacode, '</SiteData>'))[1]

pierdata <- read.csv(paste0('https://stormcentral.waterlog.com/download.php/data/',
                      datacode, '-d.csv?filename=thisdoesntmatter'),
                      skip = 1, header = T, 
                      na.strings = c('NA', '-99.99'), stringsAsFactors = F)

# Drop short-lived second sonde
pierdata <- pierdata[,-(3:8)]

# Drop empty samples
pierdata <- pierdata[rowSums(is.na(pierdata)) != 8,]

# Formatting
pierdata$Date <- mdy_hms(paste(pierdata$Date, pierdata$Time))
pierdata <- pierdata[, -2]

# Using RCurl, XML packages
# xmltree <- getURL('https://stormcentral.waterlog.com/xml/SiteDetailsSiteData.php?Site=1&Acct=88&Start=0&Range=864000000', ssl.verifypeer = F)
# root <- xmlRoot(xmlTreeParse(xmltree, getDTD = F))
# datacode <- xmlSApply(root[[1]], xmlValue)[1]
#
# Then continue with 'pierdata <- read.csv(...)'



