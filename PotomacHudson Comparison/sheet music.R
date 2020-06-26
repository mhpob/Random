library(ggplot2); library(lubridate); library(dplyr)
load('p:/obrien/biotelemetry/past sb/past-analysis/secor.sb.rda')
hudson <- readRDS('p:/obrien/biotelemetry/hudson sb/hud-sb-analysis/hud_detects.rds')
names(hudson) <- tolower(names(hudson))

library(dplyr)
secor.sb <- full_join(secor.sb, hudson)
rm(hudson)

secor.sb$system <-
  ifelse(secor.sb$array %in% c('Long Island', 'New Jersey'), 'NY Bight',
  ifelse(secor.sb$array %in% c('Hudson','Above', 'Below', 'Between', 'Long Isl',
                               'Saugerties-Coxsackie', 'West Point-Newburgh'),
         'Hudson',
  ifelse(secor.sb$array %in% c('MA', 'Mass', 'ME'), 'NEngland',  
  ifelse(secor.sb$array %in% c('Upper MD Bay', 'Mid MD Bay', 'Lower MD Bay',
                      'Other', 'Patuxent', 'Choptank', 'Nanticoke'), 'Maryland',
                ifelse(secor.sb$array %in% c('Bay Mouth', 'Elizabeth', 'James',
                                             'Rappahannock', 'York'), 'Virginia',
                       secor.sb$array)))))

secor.sb$transmitter <-
  ifelse(mdy(secor.sb$tag.date) < ymd('2014-10-29', tz = 'America/New_York') &
           grepl('25465', secor.sb$transmitter), paste0(secor.sb$transmitter, 'a'),
         ifelse(mdy(secor.sb$tag.date) >= ymd('2014-10-29', tz = 'America/New_York') &
                  grepl('25465', secor.sb$transmitter), paste0(secor.sb$transmitter, 'b'),
                secor.sb$transmitter))

# tag.info <- secor.sb %>% 
#   distinct(transmitter, tag.date, .keep_all = T) %>% 
#   mutate(tag.date = lubridate::mdy(tag.date, tz = 'America/New_York'),
#          system = ifelse(tag.date < ymd('2014-10-29', tz = 'America/New_York'),
#                          'Mid Potomac', 'Lower Potomac')) %>% 
#   select(tag.date, transmitter, system, `length`)
# 
secor.sb <- secor.sb %>%
  mutate(date.floor = lubridate::floor_date(date.local, unit = 'day')) %>%
  distinct(date.floor, transmitter, .keep_all = T)

  # select(tag.date, date.floor, transmitter, system, length) %>%
  # rbind(., tag.info) %>%
  # mutate(tag.round = ifelse(tag.date < ymd('2014-10-29', tz = 'America/New_York'),
  #                           'A', 'B')) %>%
  # arrange(desc(tag.round), length, transmitter)
  
  hold <- data.frame(transmitter = unique(secor.sb$transmitter),
                     plot.order = seq(1:length(unique(secor.sb$transmitter))))
secor.sb <- secor.sb %>% 
  left_join(hold)

# secor.sb$trans.num <- factor(secor.sb$trans.num,
#                              levels = secor.sb$trans.num[order(secor.sb$length)])

pot.cols <- colorRampPalette(c('lightgreen', 'darkgreen'))(3)
bay.cols <- colorRampPalette(c('red', 'orange'))(2)
else.cols <- colorRampPalette(c('blue', 'violet'))(7)

cols <- c('Upper Potomac' = pot.cols[1], 'Mid Potomac' = pot.cols[2],
          'Lower Potomac' = pot.cols[3], 'Maryland' = bay.cols[1],
          'Virginia' = bay.cols[2], 'C&D' = else.cols[1],
          'Delaware' = else.cols[2], 'DE Coast' = else.cols[3],
          'Mass' = else.cols[4], 'NY Bight' = else.cols[5],
          'MD Coast' = else.cols[6], 'VA Coast' = else.cols[7])

cols2 <- c('Upper Potomac' = 'green', 'Mid Potomac' = 'green',
           'Lower Potomac' = 'green', 'Maryland' = 'gray',
           'Virginia' = 'gray', 'C&D' = 'gray', 'Ches' = 'gray',
           'Delaware' = 'pink', 'DE Coast' = 'red',
           'NEngland' = 'blue', 'NY Bight' = 'blue', 'Hudson' = 'violet',
           'MD Coast' = 'red', 'VA Coast' = 'red', 'NJ Coast' = 'red')

labels <- secor.sb %>% 
  distinct(trans.num, length) %>% 
  select(length) %>% 
  data.frame()
labels <- as.numeric(labels[,1])

secor.sb$yday <- yday(secor.sb$date.floor)

ggplot() + geom_raster(data = secor.sb,
                       aes(x = yday, y = transmitter,
                           fill = system)) +
  labs(x = 'Date', y ='', fill = 'System') +
  # xlim(lubridate::ymd('2014-04-12'), lubridate::ymd('2015-07-31')) +
  scale_fill_manual(values = cols2) +
  facet_wrap(~year(secor.sb$date.floor), ncol = 1, scales = 'free_y')+
  theme(axis.title.y = element_blank(), axis.text.y = element_blank())
# scale_y_discrete(labels = labels)
