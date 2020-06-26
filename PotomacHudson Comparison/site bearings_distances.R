load('p:/obrien/biotelemetry/past sb/past-analysis/secor.sb.rda')
hudson <- readRDS('p:/obrien/biotelemetry/hudson sb/hud-sb-analysis/hud_detects.rds')
names(hudson) <- tolower(names(hudson))

library(dplyr)
all <- full_join(secor.sb, hudson)
rm(hudson, secor.sb)


all_split <- split(all, all$transmitter)
# Make sure we always have at least two detections
all_split <- all_split[sapply(all_split, function(x) dim(x)[1] > 1)]

# Run on multiple computer cores (i.e., parallelize) to reduce computing time
library(parallel)
cl <- makeCluster(detectCores() - 1)
clusterExport(cl, 'all_split')
movements <- parLapply(cl = cl,
                       X = all_split,
                       fun = TelemetryR::track, dates = 'date.local',
                       ids = 'array')

stopCluster(cl)

movements <- movements[sapply(movements, function(x) dim(x)[1] > 1)]


for(i in seq(1, length(movements), 1)){
  movements[[i]]$transmitter <- names(movements)[i]
}


tofrom <- function(x){
  from <- x$array[seq(1, nrow(x) - 1, 1)]
  to <- x$array[seq(2, nrow(x), 1)]
  time <- x$date.local[seq(2, nrow(x), 1)]
  fish <- rep(x$transmitter[1], times = nrow(x) - 1)
  
  data.frame(fish, time, from, to, stringsAsFactors = F)
}

test <- lapply(movements, tofrom)
test <- do.call(rbind, args = c(test, make.row.names = F))
head(test)


library(dplyr)

sites <- all %>% 
  distinct(array, lat, long) %>% 
  distinct(array, .keep_all = T) %>% 
  filter(!is.na(lat),
         lat != 'None') %>% 
  mutate(lat = as.numeric(lat),
         long = as.numeric(long))

# dist.sites <- as.data.frame(sites[, c('long', 'lat')])
# row.names(dist.sites) <- sites$array

combos <- data.frame('Site' = expand.grid(sites$array, sites$array,
                                          stringsAsFactors = F),
                     'Long' = expand.grid(sites$long, sites$long),
                     'Lat' = expand.grid(sites$lat, sites$lat))

earth.bear <- function (long1, lat1, long2, lat2, radians = F){
  rad <- pi/180
  a1 <- lat1 * rad
  a2 <- long1 * rad
  b1 <- lat2 * rad
  b2 <- long2 * rad
  dlon <- b2 - a2
  bear <- atan2(sin(dlon) * cos(b1), cos(a1) * sin(b1) - sin(a1) *
                  cos(b1) * cos(dlon))
  output <- (bear %% (2 * pi))
  if(radians == F){
    output <- output * (180/pi)
  }
  return(output)
}

combos$bearing  <-  earth.bear(combos$Long.Var1, combos$Lat.Var1,
                               combos$Long.Var2, combos$Lat.Var2, radians = F)
names(combos) <- c('from', 'to', 'long.from', 'long.to', 'lat.from', 'lat.to',
                   'bearing')



site2site <- test %>%
  left_join(combos) %>% 
  mutate(month = lubridate::month(time),
         day = lubridate::day(time),
         season = case_when(month %in% 1:2 |
                              (month == 12 & day > 15) |
                              (month == 3 & day <= 15) ~ 'Winter',
                            month %in% 4:5 |
                              (month == 3 & day > 15) |
                              (month == 6 & day <= 15) ~ 'Spring',
                            month %in% 7:8 |
                              (month == 6 & day > 15) |
                              (month == 9 & day <= 15) ~ 'Summer',
                            T ~ 'Fall'),
         season = factor(season,
                         levels = c('Winter', 'Spring', 'Summer', 'Fall')),
         origin = case_when(grepl('-1303-', fish) ~ 'Hudson',
                            T ~ 'Potomac'))

library(ggplot2)
ggplot() + geom_histogram(data = filter(site2site, origin == 'Hudson'),
                          aes(x = bearing, y = ..density..),
                          color = 'gray') +
  labs(title = 'Hudson') +
  coord_polar() +
  scale_x_continuous(breaks = seq(0, 360, 45), limits = c(0, 360)) +
  facet_wrap(~ season, ncol = 2)
