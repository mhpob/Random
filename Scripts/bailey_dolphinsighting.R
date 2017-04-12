library(ggplot2); library(lubridate); library(tidyr); library(dplyr)

# Distance blocks
L1 <- -74 - (50/60) - (40.36/3600)
L2 <- -74 - (37/60) - (21.23/3600)
L3 <- -74 - (25/60) - (39.43/3600)

# Sighting Data
sight <- read.csv('c:/users/secor/desktop/bailey dolphin/seamap sightings data.csv',
                  stringsAsFactors = F)

sight <- filter(sight, grepl('delphis|tursi', scientific, ignore.case = T),
                latitude < 38.6)
sight$d_block <- ifelse(sight$longitude <= L1, 'A',
                 ifelse(sight$longitude > L1 & sight$longitude <= L2, 'B',
                 ifelse(sight$longitude > L2 & sight$longitude <= L3, 'C',
                        'D')))
# # Visualize
# # CPOD Locations
# cpod <- data.frame(site = c('T-1C', 'A-5C', 'T-2C', 'T-3C'),
#                    long = c(-74.949, -74.72215, -74.50508333, -74.34948333),
#                    lat = c(38.336, 38.3356, 38.33598333, 38.3356))
# 
# ggplot() + geom_point(data = sight, aes(x = longitude, y = latitude,
#                                         color = d_block, shape = sp_code)) +
#   geom_point(data = filter(sight, sp_code == 'Dde'),
#              aes(x = longitude, y = latitude), pch = 1) +
#   geom_vline(xintercept = c(L1, L2, L3)) +
#   geom_point(data = cpod, aes(x = long, y = lat), size = 3, color = 'red')

# Time aggregation
sight <- sight %>% 
  mutate(obs_date = mdy(obs_date),
         month = month(obs_date)) %>% 
  group_by(sp_code, month, d_block) %>% 
  summarize(n = sum(count))

# Pivot/fill data
sight <- spread(sight, sp_code, n, fill = 0)

# Model
sight_fit <- glm(data = sight, formula = cbind(Ttr, Dde) ~ d_block * month,
                 family = binomial)
summary(sight_fit)

