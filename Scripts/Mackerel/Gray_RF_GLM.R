setwd('scripts/mackerel')
library(ggplot2); library(randomForest); library(pROC)

df.99 <- read.csv('master data file to dave.csv')
df.99 <- subset(df.99, !grepl('\\*', Country))
df.99 <- subset(df.99, Year == 1999)

set.seed(71)
rf.99 <- randomForest(Country ~ d18O + d13C, data = df.99,
                      importance = TRUE, proximity = TRUE, oob.prox = T)
print(rf.99)
round(importance(rf.99))

rf.99.O <- randomForest(Country ~ d18O, data = df.99,
                        importance = TRUE, proximity = TRUE, oob.prox = T)
print(rf.99.O)


###Pull out 1998 year class of adults! even though 99 baseline
adult.data <- read.csv("All Adult Data for R.csv", header = T) 
adult.data.99 <- subset(adult.data, Yearclass == 1998)
class <- predict(rf.99.O, newdata = adult.data.99, type = "response")
prob <- predict(rf.99.O, newdata = adult.data.99, type = "prob")
plot(class, prob[, 2], ylab = "Probability of US Origin")
abline(h = 0.5, col = 2, lwd = 2, lty = 2)



#GLM Portion (Logistic Regression)
mod.99 <- glm(Country ~ d18O, data = df.99, family ="binomial")
summary(mod.99)
prob.glm.99.adult <- predict(mod.99, adult.data.99, type = "response")
table(prob.glm.99.adult)
