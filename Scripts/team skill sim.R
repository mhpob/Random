library(extraDistr)
dat <- data.frame(
  team = rep(c('a', 'b'), each = 23),
  skill = c(rtpois(23, 9, b = 10), rtpois(23, 10, b = 10))
)


library(ggplot2)
# ggplot(data = dat)+
#   # geom_dotplot(aes(x = skill, y = ..count.., fill = team), position = position_dodge(),
#   #              dotsize = 1, method = 'histodot', binwidth = 1) +
#   geom_bar(aes(x = skill, y = ..count.., fill = team),
#            position = position_dodge(preserve = 'single')) +
#   geom_density(aes(x = skill, y = ..count..,  fill = NULL, color = team), size = 1) +
#   scale_x_continuous(breaks = seq(0, 10, 1), limits = c(0, 10)) +
#   geom_vline(xintercept = c(median(dat[dat$team == 'a',]$skill) - 0.5,
#                             median(dat[dat$team == 'b',]$skill) + 0.5)) +
#   labs(y = 'Number of players', x = 'Skill level', color = 'Team', fill = 'Team') +
#   theme_minimal()
#              

ggplot(data = dat)+
  geom_dotplot(aes(x = skill, fill = team), position = position_dodge(),
               method = 'dotdensity', binwidth = 0.25, stackratio = 1) +
  # geom_bar(aes(x = skill, y = ..count.., fill = team),
  #          position = position_dodge(preserve = 'single')) +
  geom_density(aes(x = skill, fill = NULL, color = team), size = 1) +
  scale_x_continuous(breaks = seq(0, 10, 1), limits = c(0, 10)) +
  geom_vline(xintercept = c(median(dat[dat$team == 'a',]$skill) - 0.5,
                            median(dat[dat$team == 'b',]$skill) + 0.5)) +
  labs(y = 'Number of players', x = 'Skill level', color = 'Team', fill = 'Team') +
  ylim(0, 0.5) +
  theme_minimal() +
  theme(axis.text.y = element_blank(),
        axis.title = element_text(hjust = 0, size = 16),
        axis.text = element_text(size = 12),
        legend.position = 'none')

