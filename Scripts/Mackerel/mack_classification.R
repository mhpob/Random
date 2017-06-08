setwd('scripts/mackerel')
library(randomForest); library(dplyr)

mack.data <- read.csv('alldata2.csv', na.strings = 'n/a')
# names(mack.data)

class.func <- function(data, year_class, age, country = 'US'){
  # Build random forest model using baseline data set
  baseline <- filter(data, Yearclass == year_class, Age == 1)
  baseline$Country <- droplevels(baseline$Country)
  
  rf.model <- randomForest(Country ~ d18O + d13C, data = baseline,
                           importance = TRUE, proximity = TRUE, oob.prox = T)
  
  # Use random forest model to classify age/yearclass subset
  to.classify <- filter(data, Age == age, Yearclass == year_class,
                        Country %in% country)
  # Nomincal classification (>50%)
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
for(i in seq(1, 7, 1)){
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