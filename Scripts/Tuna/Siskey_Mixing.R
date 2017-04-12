library(readxl); library(randomForest); library(ggplot2)

siskey <- read_xlsx('p:/obrien/randomr/scripts/tuna/siskey_abft mixing data_original.xlsx')
base <- read.csv('p:/obrien/randomr/scripts/tuna/baseline.csv')


## Build Random Forest model using stratified sampling of base data:
## Draw 100 and 100 of each class to grow each tree.
## Weighted in favour of d18O.

base.rf <- randomForest(Populations ~ d18O + d13C, base,
                         sampsize = c(100, 100),
                         classwt = c(1, 2))
cutoff <- c(0.47, 0.53)

predictions <- cbind(base,
                     Origin = predict(base.rf, newdata = base,
                                      type = "response", cutoff = cutoff))

## Predictions
# Using mixed stock samples, we estimate the natal origin. Some manipulations
# are required to ensure that the naming of variables is identical to those used
# in the trial data and the sign is also changed.

# Subset siskey data
newdata <- siskey[, c("Suess d13C", "final d18O")]
# Rename variables in 'siskey' to match names in 'base'
names(newdata) <- c('d13C', 'd18O')

cutoff <- c(0.526, 0.474)

siskey_pred = cbind(siskey,
                    Origin = predict(base.rf, newdata = newdata,
                                     type = "prob", cutoff = cutoff))

write.csv(siskey_pred, 'scripts/tuna/siskey_abft_predicted_mixing.csv',
          row.names = F)

## Visual QA/QC
# ggplot() +
#   geom_point(data = siskey_pred, aes(y = Origin.West, x = `final d18O`))
# 
# ggplot() +
#   geom_point(data = siskey_pred, aes(y = Origin.West, x = `CFL (cm)`))
