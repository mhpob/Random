
library(parallel)
cl <- makeCluster(detectCores() - 1)
clusterExport(cl, 'all_split')
clusterEvalQ(cl, library(TelemetryR))

test <- parLapply(cl = cl,
                  X = all_split,
                  fun = TelemetryR::track, dates = 'date.local', ids = 'station')

stopCluster(cl)