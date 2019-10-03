setwd('scripts/mackerel')
library(randomForest); library(dplyr)

mack.data <- read.csv('alldata2.csv', na.strings = 'n/a')
# names(mack.data)

class.func <- function(data, year_class, age, country = 'CAN'){
  # Build random forest model using baseline data (age-1 fish of a given year class)
  baseline <- filter(data, Yearclass == year_class, Age == 1)
  baseline$Country <- droplevels(baseline$Country)
  
  rf.model <- randomForest(Country ~ d18O + d13C, data = baseline, ntree = 10000,
                           importance = T, proximity = T, oob.prox = T)
  
  # Use random forest model to classify age/yearclass subset
  to.classify <- filter(data, Age == age, Yearclass == year_class,
                        Country %in% country)
  # Nominal classification (>50%)
  Classification <- predict(rf.model, newdata = to.classify, type = "response")
  # Probability 
  prob <- predict(rf.model, newdata = to.classify, type = "prob")
  
  cbind(to.classify, Classification, prob)
}

# Examples
age2_1998 <- class.func(mack.data, 1998, 2)
age2_1999 <- class.func(mack.data, 1999, 2)

## Loop over subsets we would like to classify
# Choose the subsets we want to classify
class <- matrix(c(2, 1998,
                  2, 1999,
                  2, 2000,
                  3, 1998,
                  3, 2000,
                  4, 1999,
                  5, 1998), ncol = 2, byrow = T)
colnames(class) <- c('age', 'year_class')

# We can use a standard loop
all.data <- NULL
for(i in seq(1, dim(class)[1], 1)){
  temporary <- class.func(mack.data,
                          year_class = class[i, 2], age = class[i, 1])
  all.data <- rbind(all.data, temporary)
}

# Or use the "apply" functions, which are vectorized and run faster if there are
# a lot of loop iterations. Here, they're pretty much the same speed.
# The "MARGIN" variable tells it to loop over rows (1) or columns (2).
all.data <- apply(class, MARGIN = 1,
                  function(x) class.func(mack.data, year_class = x['year_class'],
                                                   age = x['age']))
all.data <- do.call(rbind, all.data)


write.csv(all.data, 'mackerel_classification.csv', row.names = F)







library(ggplot2); library(dplyr)
ggplot()+
  geom_boxplot(data = all.data,
              aes(x = Subregion, y = d18O, fill = Classification), outlier.size = 0)+
  geom_point(data = all.data,
              aes(x = Subregion, y = d18O, fill = Classification),
             position = position_jitterdodge())+
  labs(title = '', subtitle = 'Canadian origin') +
  theme_bw()
    




baseline <- filter(mack.data, Age == 1, Yearclass == 2000)
baseline$Country <- droplevels(baseline$Country)

rf.model <- randomForest(Country ~ d18O, data = baseline, ntree = 10000,
                         importance = TRUE, proximity = TRUE, oob.prox = T)
rf.model



to.classify <- filter(mack.data, Age == 2, Yearclass == 1999,
                      Country %in% 'US')
