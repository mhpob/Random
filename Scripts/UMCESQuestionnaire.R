library(ggplot2); library(reshape2); library(dplyr)

survey <- read.csv('p:/obrien/randomr/umces2016_convocquestionnaire.csv',
                   stringsAsFactors = F)

survey <- survey %>%
  mutate(Disc.pct = Discovery/(Discovery + Integration + Application + Teaching),
         Int.pct = Integration/(Discovery + Integration + Application + Teaching),
         App.pct = Application/(Discovery + Integration + Application + Teaching),
         Teach.pct = Teaching/(Discovery + Integration + Application + Teaching))

survey <- arrange(survey, Disc.pct, Int.pct, App.pct, Teach.pct) %>%
  mutate(order = seq(1:29))


sur.raw <- melt(survey, id = c('Question', 'order'),
                measure.vars =c('Discovery', 'Integration', 'Application', 'Teaching'))
sur.pct <- melt(survey, id = c('Question', 'order'),
                measure.vars = c('Disc.pct', 'Int.pct', 'App.pct', 'Teach.pct'))


ggplot() + geom_raster(data = sur.pct, aes(x = variable, y = as.factor(order),
                                           fill = value)) +
  scale_fill_gradient(low = 'blue', high = 'red', name = NULL) +
  scale_y_discrete(labels = NULL) +
  scale_x_discrete(labels =
                     c('Discovery', 'Integration', 'Application', 'Teaching')) +
  labs(y = NULL, x = NULL) +
  theme_bw()
