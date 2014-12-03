library(TelemetryR); library(ggplot2); library(dplyr)
pass.dat <- read.csv('p:/obrien/biotelemetry/csi/listening/activedata.csv',
                     header = T, stringsAsFactors = F)

pass.dat <- pass.dat %>% 
  mutate(pred.growth = sturgrow(Temp, Sal, DO.pct),
         river = substr(Site.ID, 1, 2))

pd_mean <- pass.dat %>%
  group_by(Site.ID, Cruise) %>%
  summarize(temp = mean(Temp),
            do = mean(DO.pct),
            sal = mean(Sal),
            det = mean(Detections))


test <- function(var, brk){
  pd_bot <- pass.dat %>%
    filter(Type == 'B')
  pd_bot <- pd_bot %>%  
    mutate(bin = findInterval(pd_bot[, var],
                              seq(floor(range(pd_bot[, var])[1]),
                                  ceiling(range(pd_bot[, var])[2]), brk)))
  det.bins <- pd_bot %>%
    group_by(bin) %>%
    summarize(detect = sum(Detections))
  
  histo <- hist(pd_bot[, var], breaks = seq(floor(range(pd_bot[, var])[1]),
                                            ceiling(range(pd_bot[, var])[2]),
                                            brk),
                plot = F)
  mids <- data.frame(mids = histo$mids)
  mids$bin <- row.names(mids)
    
  det.bins <- merge(det.bins, mids)
  det.bins <- det.bins[det.bins$detect != 0,]

  par(mar = c(5, 4, 4, 5) + 0.1)
  plot(histo, main = var, xlab = var, 
       xlim = c(floor(range(pd_bot[, var])[1]),
                ceiling(range(pd_bot[, var])[2])))
  par(new = T)
  plot(det.bins$mids, det.bins$detect,
       xlim = c(floor(range(pd_bot[, var])[1]),
                ceiling(range(pd_bot[, var])[2])),
       col = 'blue', xaxt = "n", yaxt = "n", xlab = "", ylab = "")
  axis(4, at = seq(0, ceiling(range(det.bins$detect)[2]), 5),
       col.axis = 'blue')
  mtext('Detections', side = 4, line = 3, col = 'blue')
}

test('Temp', 1)
test('DO.pct', 5)
test('Sal', 2)
test('Cond', 2)


# Overplot general histogram, then histogram where detections > 0
pd_bot <- pass.dat %>%
    filter(Type == 'B')
histoplot <- function (var, binwidth = NULL) {
  det.data <- substitute(pd_bot %>% filter(Detections > 0) %>% arrange(var) %>%
                           mutate(cumulative = cumsum(Detections),
                                  cumulative = cumulative/max(cumulative)*100),
                         list(var = as.name(var)))
  det.data <- eval(det.data)
  
  call <- substitute(ggplot() + geom_histogram(data = pd_bot, aes(x = var),
                                               binwidth = binwidth) +
                       geom_histogram(data = det.data,
                                      aes(x = var, color = 'red'),
                                      binwidth = binwidth) +
                       geom_line(data = det.data, aes(x = var,
                                                      y = cumulative)),
                     list(var = as.name(var)))
  eval(call)
}
histoplot('DO.pct', 5)
histoplot('Temp', 1)
histoplot('Sal', 2)
histoplot('Cond', 2)
histoplot('pred.growth')
histoplot('Depth')
