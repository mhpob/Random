# This script rips water quality data from the CBL Pier Storm Central Water Log site
# https://stormcentral.waterlog.com/SiteDetails.php?a=88&site=1&pa=CBLPier
# 
# In the future, I'd like to put in start/stop time arguments.


xmltree <- readLines('https://stormcentral.waterlog.com/xml/SiteDetailsSiteData.php?Site=1&Acct=88&Start=0&Range=864000000')

datacode <- unlist(strsplit(xmltree[3], '<SiteData>'))[2]
datacode <- unlist(strsplit(datacode, '</SiteData>'))[1]

pierdata <- read.csv(paste0('https://stormcentral.waterlog.com/download.php/data/',
                      datacode, '-d.csv?filename=thisdoesntmatter'),
                      skip = 1, header = T, stringsAsFactors = F)



# j <- getURL('https://stormcentral.waterlog.com/xml/SiteDetailsSiteData.php?Site=1&Acct=88&Start=0&Range=864000000', ssl.verifypeer = F)
# jj<-xmlTreeParse(j, getDTD = F)
# jjk <- xmlRoot(jj)
# jjk[[1]]['SiteData']



