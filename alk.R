devtools::install_github('droglenc/FSA')
library(FSA); library(dplyr)

al <- read.csv('age_length.csv')
al <- al %>% 
  mutate(fl.in = FL * 0.03937) %>% 
  slice(-c(153, 86, 244)) %>% 
  arrange(Age)

alk <- Summarize(al$fl.in ~ al$Age)
names(alk)[1] <- 'age'
alk$age <- as.numeric(levels(alk$age)[alk$age])

vbF <- vbFuns('typical')
vbb <- nls(fl.in ~ vbF(Age, Linf, K, t0), data = al,
           start = vbStarts(fl.in ~ Age, data = al, type = 'typical'))
plot(al$Age, al$fl.in)
curve(vbF(x, Linf = coef(vbb)), add = T, col = 'red')

summary(vbb)


plot(alk$age, alk$sd)
plot(vbb)

library(changepoint)
sd.cpt <- cpt.mean(alk[!is.na(alk$sd),'sd'], pen.value = 0.05)
plot(sd.cpt)
coef(sd.cpt)
# $mean
# [1] 1.445930 4.250993
cpts(sd.cpt) #returns index == between ages 6 and 7

j <- data.frame(matrix(c(14, rep(NA,9)), 1))
names(j) <- names(alk)

alk <- alk %>%
  rbind(j) %>% 
  mutate(model = 49.31216*(1-exp(-0.09175*(age-(-0.02277)))),
         lci65.mod = ifelse(age <= 6,
                      model - 1.446/sqrt(4),
                      model - 4.251/sqrt(10)),
         hci65.mod = ifelse(age <= 6,
                      model + 1.446/sqrt(4),
                      model + 4.251/sqrt(10)),
         lpi.65.mod = ifelse(age <= 6,
                      model - qt(.841, 3) * 1.446 * sqrt(1 + (1/4)),
                      model - qt(.841, 9) * 1.446 * sqrt(1 + (1/10))),
         hpi.65.mod = ifelse(age <= 6,
                      model + qt(.841, 3) * 1.446 * sqrt(1 + (1/4)),
                      model + qt(.841, 9) * 1.446 * sqrt(1 + (1/10)))) %>% 
  arrange(age)
  
  
vbpred <- function(x){49.31216*(1-exp(-0.09175*(x-(-0.02277))))}
vbpred(c(3:18))

write.csv(alk, 'alk.csv')


qt(.025,9)*4.134*sqrt(1+(1/10))
