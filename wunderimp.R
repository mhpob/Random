############################################################
## Import archived meteorological data from wunderground.com
## This function uses reshape package to extract data frames
##   from list (k, here) and merge them into a single data
##   frame.
##   Please note, merge_recurse() is not in reshape2 package.
##
## arp = airport code (in quotes)
## Yr = sequence of years desired
## Mst = start month
## Mend = end month
##
## Example: data <- wunderimp('KWAL',seq(1977,1989,1),1,12)
############################################################
## Frequently used airport codes:
## OC, MD == KOXB
## Wallops Island, MD  == KWAL
## PAX NAS == KNHK
############################################################

if(('lubridate' %in% installed.packages()) == F) install.packages('lubridate')

wunderimp <- function (arp, Yr, Mst, Mend) {
  Dend <- ifelse(Mend == 4 | Mend == 6 | Mend == 9 | Mend == 11, 30, 
                 ifelse(Mend == 2, 28, 31))
  j <- paste("http://www.wunderground.com/history/airport/",arp,"/",Yr,"/",Mst,
        "/1/CustomHistory.html?dayend=",Dend,"&monthend=",Mend,"&yearend=",Yr,
        "&format=1",sep="")
  k <- lapply(j, read.csv)
  k <- merge_recurse(k)
 
  winddeg<-data.frame(do.call('rbind',strsplit(as.character(k$WindDirDegrees.br...),'<',fixed=T)))
  k<-cbind(k,winddeg)
  k<-k[,!names(k) %in% c('WindDirDegrees.br...','X2')]
  names(k)[1] <- "Date"
  names(k)[23]<- "WindDirDeg"
  k
}