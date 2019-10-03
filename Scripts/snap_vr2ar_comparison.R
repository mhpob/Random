j <- read.csv('c:/users/secor/downloads/ref_1hr.csv', stringsAsFactors = F)
j <- j[j$Reference == 'Mean',]
j <- j[1:720,]

rawsig <- (10 ^ (j$Data_SPL / 20)) * (10 ^ (-178.15 / 20))

plot.ts(cbind(rawsig, j$Data_SPL, j$Data_mV))
plot(j$Data_mV, j$Data_SPL)

