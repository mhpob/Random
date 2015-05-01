library(ggplot2); library(nlme); library(dplyr)
menh <- read.csv('c:/users/secor lab/desktop/alex/increment widths (2013).csv')

# names(menh)
# Want Location.., Growth.Speed, Continuous.increments, Increment.Length..um.

menh <- menh %>% 
  filter(Before.or.After.Inflection == 'Before') %>% 
  transmute(fish = Location..,
            growth = Growth.Speed,
            inc.num = End.Point,
            inc.wid = Cumulative.length..um.)

# ggplot() + geom_boxplot(data = menh, aes(y = inc.wid, x = growth, fill = growth))
# ggplot(data = menh, aes(x = inc.num, y = inc.wid, color = growth)) + geom_point() +
#   stat_smooth(method = lm)

rfish <- lme(inc.wid ~ growth,
            random = ~ inc.num | fish,
            # correlation=corAR1(form= ~ ordered(inc.num) | fish),
            # control = lmeControl(niterEM = 5200, msMaxIter = 5200),
            data = menh,
            method = 'REML')

summary(rfish)
plot(rfish)

