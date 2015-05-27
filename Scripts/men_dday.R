#### Setup & Functions ########################################################
if(('dplyr' %in% installed.packages()) == F) install.packages('dplyr')
library(dplyr)
library(ggplot2)

# Load NOAAimp() to rip data from Tides & Currents
source('p:/obrien/randomr/noaa.R')

# Find degree days for each day given temperatures and DD thresholds
deg.day <- function(temperatures, thresholds){
  ddys <- function(temperatures, thresholds) {
    ifelse(temperatures >= thresholds, temperatures - thresholds, 0)
  }
  
  hold1 <- list()
  for(i in thresholds) {
    hold1[i - (thresholds[1] - 1)] <- list(ddys(temperatures, i))
    hold2 <- data.frame(do.call(cbind, hold1))
  }
  names(hold2) <- do.call(paste, list('dd_thresh', thresholds, sep = "."))
  hold2
}

# Find final lengths with given L0, B, and start/end dates
DDleng <- function (L0, B, start, end) {
  sub.ddys <- select(filter(CBL.temp, date >= start & date <= end), -contains('wt'), -date)##
  inputs <- expand.grid(L0, B, colSums(sub.ddys))##
  leng <- inputs[1] + inputs[2]*inputs[3]
  leng <- cbind(leng, inputs, rep(thresholds, each = length(L0)*length(B)))
  names(leng) <- c('Lt', 'L0', 'B', 'CGDD', 'Threshold')
  leng
}

#### NOAA water temp rip & maniuplation #######################################
st <- 20090901
end <- 20100830
station <- 8577330
data <- 'water_temperature'

CBL.all.temp <- NOAAimp(st, end, station, data)

CBL.all.temp <- CBL.all.temp[is.na(CBL.all.temp[2]) == F,]
CBL.all.temp$Date.Time <- strptime(as.character(CBL.all.temp[,1]), format = "%Y-%m-%d %H:%M", tz = 'GMT')
CBL.all.temp$Date <- as.Date(format(CBL.all.temp$Date.Time, "%Y-%m-%d"))

maxs <- aggregate(Water.Temperature ~ Date, data = CBL.all.temp, max)
names(maxs) <- c('date','wt.max')
means <- aggregate(Water.Temperature ~ Date, data = CBL.all.temp, mean)
names(means) <- c('date','wt.mean')
CBL.temp <- merge(maxs,means)

rm(maxs, means, st, end, station, data)

#### Degree Day and L(t) calculation ###################################################
# Degree Day calc
thresholds <- seq(10, 14, 2)
CBL.temp <- cbind(CBL.temp, deg.day(CBL.temp$wt.mean, thresholds))

# L(t) calc
#L0 <- seq(33, 60, 0.5) #33.01-56.56 according to Jen and Mike
lengths<-read.csv("P:/Atkinson/Conferences & Presentations/Brown Bag/2014/ing_menlen.csv", header= TRUE)
##Remove the 1st column from ing_menlen, leaving only lengths
lengths<-lengths[,2]
beta <- c(0.021, 0.05, 0.082) #0.021-0.082 according to Jen and Mike

##Run model for different months of ingress (Nov-Apr) and plot 9 combinations of threshold temp (10, 12, 14) 
#   & beta values (0.021, 0.05, 0.082)
final.length.nov <- DDleng(lengths, beta, '2009-11-01', '2010-7-31')
ggplot(final.length, aes(x=Lt))+geom_histogram()+facet_wrap(~Threshold+B)+ggtitle("November '09 Ingress")+ylab("frequency")+xlab("Final length (mm)")

final.length.dec <- DDleng(lengths, beta, '2009-12-01', '2010-7-31')
ggplot(final.length, aes(x=Lt))+geom_histogram()+facet_wrap(~Threshold+B)+ggtitle("December '09 Ingress")+ylab("frequency")+xlab("Final length (mm)")

final.length.jan <- DDleng(lengths, beta, '2010-1-01', '2010-7-31')
ggplot(final.length, aes(x=Lt))+geom_histogram()+facet_wrap(~Threshold+B)+ggtitle("January '10 Ingress")+ylab("frequency")+xlab("Final length (mm)")

final.length.feb <- DDleng(lengths, beta, '2010-2-01', '2010-7-31')
ggplot(final.length, aes(x=Lt))+geom_histogram()+facet_wrap(~Threshold+B)+ggtitle("February '10 Ingress")+ylab("frequency")+xlab("Final length (mm)")

final.length.mar <- DDleng(lengths, beta, '2010-3-01', '2010-7-31')
ggplot(final.length, aes(x=Lt))+geom_histogram()+facet_wrap(~Threshold+B)+ggtitle("March '10 Ingress")+ylab("frequency")+xlab("Final length (mm)")

final.length.apr <- DDleng(lengths, beta, '2010-4-01', '2010-7-31')
ggplot(final.length, aes(x=Lt))+geom_histogram()+facet_wrap(~Threshold+B)+ggtitle("April '10Ingress")+ylab("frequency")+xlab("Final length (mm)")



##Get plots of each month length distribution separately
ggplot(final.length, aes(x=Lt))+geom_histogram()+facet_wrap(~Threshold+beta)+ggtitle("December Ingress")+ylab("frequency")+xlab("Final length (mm)")



ggplot(final.length, aes(x=Lt))+geom_histogram()+facet_wrap(~Threshold+)
##geom_histogram(fill="white") to change color of bars

