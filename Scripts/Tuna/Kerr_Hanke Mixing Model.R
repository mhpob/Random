# This document chronicles the process by which otoliths collected from the heads of Bluefin tuna can be used to determine the natal origin of individual fish.

# Data Acquisition
# Read Sample Data
natal <- read.csv("p:/obrien/randomr/scripts/tuna/Kerr data.csv", header = T)  
names(natal)
natal = natal[!is.na(natal$d18O),]
# Read Baseline data
base <- read.csv("p:/obrien/randomr/scripts/tuna/baseline.csv", header = T)   #directory where csv 
names(base)

# 1. Fluctuations in the carbon isotope estimates in the sample over years. The yearly aggregation combines data from several regions that do not exist in all years.
library(ggplot2)
# Change in delta c13 over years (confounded with Region)

ggplot(subset(natal, !is.na(d13C))) +
  geom_boxplot(aes(x = factor(Year), y = abs(d13C)))
# Change in delta O18 over years (confounded with Region)

ggplot(subset(natal, !is.na(d18O))) +
  geom_boxplot(aes(x = factor(Year), y = abs(d18O)))

# 2. The distribution of the oxygen isotope estimates from the baseline relative to the distribution in the sample 
# Distribution of baseline delta O18 relative to sample values

ggplot(subset(natal, !is.na(d18O))) +
  geom_histogram(aes(x = abs(d18O)), alpha = 0.5) + 
  geom_histogram(data = base, aes(x = -1 * d18O, fill = Populations),
                 alpha = 0.5)


# 3. Time trends in length of fish sampled. The yearly variation is confounded with regional variation where regions may not be sampled in all years.
# Change in curved fork length over years (confounded by Region)

ggplot(subset(natal, !is.na(d18O))) +
  geom_boxplot(aes(x = factor(Year), y = CFL))

# 4. The relationship between carbon isotope estimates and the curved forklength of a fish.
# Relationship between isotope values and curved fork length

ggplot(subset(natal, !is.na(d18O))) +
  geom_point(aes(x = d13C, y = CFL)) +
  geom_smooth(aes(x = d13C, y = CFL))

# 5. The relationship between oxygen isotope estimates and the curved forklength of a fish.

ggplot(subset(natal,!is.na(d18O))) +
  geom_point(aes(x = d18O, y = CFL)) +
  geom_smooth(aes(x = d18O, y= CFL))

# 6. Two dimensional kernal density plots of the baseline data showing the overlap between eastern and western origin baseline data.
# Kernal density contours for the baseline data 

ggplot(base) +
  geom_point(aes(y = d13C, x = d18O, col = Populations)) +
  geom_density2d(aes(y = d13C, x = d18O, col = Populations))

## Classification Model
# The majority of the data is associated with eastern origin samples and, consequently, this becomes the majority class. If we do not correct for this bias it results in better fit for the majority class. 

library(randomForest)
set.seed(71)
base.rf <- randomForest(Populations ~ d13C + d18O, data = base,
                        importance = T, proximity = T, oob.prox = T,
                        classwt = c(1, 2))
base.rf

# The greater importance of the oxygen isotope data in the fitting (`r round(importance(base.rf), 2)`) is further emphasized by the class weighting.
## Look at variable importance:

round(importance(base.rf), 2)

# A pairs plot show the relationship between the primary variables and the MDS axes.
## Do MDS on 1 - proximity:
base.mds <- cmdscale(1 - base.rf$proximity, eig = TRUE)
op <- par(pty = "s")
pairs(cbind(base[, 1:2], base.mds$points), cex = 0.6, gap = 0,
      col = c("red", "green")[as.numeric(base$Populations)],
      main = "Base Data: Predictors and MDS of Proximity Based on RandomForest")
par(op)
print(base.mds$GOF)


# To compensate for the emphasis on the majority class, equal sample sizes are specified. There is no big improvement over the previous model except that the class errors are now more equal.

## Stratified sampling: draw 40 and 40 of each class to grow each tree.
## Weighted in favour of d18O

base.rf2 <- randomForest(Populations ~ d18O + d13C, base,
                          sampsize = c(100, 100),
                          classwt = c(1, 2))
base.rf2

cutoff <- c(.47,.53)

predictions <- cbind(base,
                     Origin = predict(base.rf2, newdata = base,
                                      type = "response", cutoff = cutoff))
xtabs(~Populations + Origin, predictions)

## Predictions
# Using mixed stock samples, we estimate the natal origin. Some manipulations are required to ensure that the naming of variables is identical to those used in the trial data and the sign is also changed. *I am not sure why the data is transformed in this way in the baseline data.*

# Test data 
newdata <- natal[, c("d13C", "d18O")]

cutoff <- c(0.526, 0.474)
predictions <- cbind(natal,
                     Origin = predict(base.rf2, newdata = newdata,
                                      type = "response", cutoff = cutoff))
predictionsP = cbind(natal,
                     Origin = predict(base.rf2, newdata = newdata,
                                      type = "prob", cutoff = cutoff))
# update database with results
d <- merge(predictions, predictionsP)
e <- merge(natal, d, all.x = T)
write.csv(e, file = "Indiv_assign.csv", row.names = F, quote = F)
 