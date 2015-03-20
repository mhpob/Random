# devtools::install_github('droglenc/FSA')
library(FSA); library(ggplot2); library(dplyr)

## Data import
locs <- do.call(paste, list('c:/users/secor lab/desktop/odu striped bass ages',
            list.files(path ='c:/users/secor lab/desktop/odu striped bass ages',
                       pattern = '*.csv'), sep = '/'))
data <- lapply(locs, FUN = read.csv,
                        header = T, stringsAsFactors = F, na.strings = "")
al <- do.call(rbind.data.frame, data)
al <- al %>% 
  filter(!is.na(OTOAGE),
         TOTAL > 0, OTOAGE > 0) %>% 
  select(TOTAL, OTOAGE) %>% 
  mutate(TOTAL = 0.0393701 * TOTAL,
         TOTAL = floor(TOTAL),
         TOTAL = ifelse(TOTAL >= 48, '>48', TOTAL))

al.quar <- al %>% 
  group_by(TOTAL) %>%
  summarize(fstqu = quantile(OTOAGE)['25%'],
            med = quantile(OTOAGE)['50%'],
            thrdqu = quantile(OTOAGE)['75%'])
write.csv(al.quar, 'age_length.csv', row.names = F)

ggplot(data = al, aes(x = OTOAGE, y = TOTAL)) +
  geom_smooth(se = F, size = 2) + geom_point() +
  labs(x = 'Age', y = 'Total Length (inches)') + 
  theme_bw()

ggplot(data = al, aes(x = factor(TOTAL), y = OTOAGE)) + geom_boxplot() +
  scale_y_continuous(breaks = seq(0,27))




alk <- Summarize(al$TOTAL ~ al$OTOAGE)
names(alk)[1] <- 'age'
alk$age <- as.numeric(levels(alk$age)[alk$age])

vbF <- vbFuns('typical')
vbb <- nls(TOTAL ~ vbF(OTOAGE, Linf, K, t0), data = al,
           start = vbStarts(TOTAL ~ OTOAGE, data = al, type = 'typical'))
plot(al$OTOAGE, al$TOTAL)
curve(vbF(x, Linf = coef(vbb)), add = T, col = 'red')

summary(vbb)


plot(alk$age, alk$sd)
plot(vbb)

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
