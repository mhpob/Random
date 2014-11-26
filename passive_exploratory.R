library(TelemetryR); library(ggplot2); library(dplyr)
pass.dat <- read.csv('p:/obrien/biotelemetry/csi/listening/activedata.csv',
                     header = T, stringsAsFactors = F)

pass.dat <- pass.dat %>% 
  mutate(pred.growth = sturgrow(Temp, Sal, DO.pct),
         river = substr(Site.ID, 1, 2))

pd_no0 <- pass.dat %>%
  filter(Detections > 0)

pd_bot <- pass.dat %>%
  filter(Type == 'B')

pd_bot_n0 <- pass.dat %>%
  filter(Type == 'B',
         Detections > 0)

pd_mean <- pass.dat %>%
  group_by(Site.ID, Cruise) %>%
  summarize(temp = mean(Temp),
            do = mean(DO.pct),
            sal = mean(Sal),
            det = mean(Detections))


par(mar = c(5, 4, 4, 5) + 0.1)
plot(density(pd_bot$DO.pct), xlim = c(10, 130),
     "Dissolved Oxygen (%)")
par(new = T)
plot(x = pd_bot_n0$DO.pct, y = pd_bot_n0$Detections,
     xlim = c(10, 130),ylim = c(0, 3), col = 'blue',
     xaxt = "n", yaxt = "n", xlab = "", ylab = "")
axis(4, at = c(0, 1, 2, 3), col.axis = 'blue')
mtext('Detections', side = 4, line = 3, col = 'blue')

par(mar = c(5, 4, 4, 5) + 0.1)
plot(density(pd_bot$Temp), xlim = c(10, 35),
     'Temperature (°C)')
par(new = T)
plot(x = pd_bot_n0$Temp, y = pd_bot_n0$Detections,
     xlim = c(10, 35),ylim = c(0, 3), col = 'blue',
     xaxt = "n", yaxt = "n", xlab = "", ylab = "")
axis(4, at = c(0, 1, 2, 3), col.axis = 'blue')
mtext('Detections', side = 4, line = 3, col = 'blue')


par(mar = c(5, 4, 4, 5) + 0.1)
plot(density(pd_bot$Sal), xlim=c(0, 30),
     'Salinity')
par(new = T)
plot(x = pd_bot_n0$Sal, y = pd_bot_n0$Detections,
     xlim = c(0, 30), ylim = c(0, 3), col = 'blue',
     xaxt = "n", yaxt = "n", xlab = "", ylab = "")
axis(4, at = c(0, 1, 2, 3), col.axis = 'blue')
mtext('Detections', side = 4, line = 3, col = 'blue')