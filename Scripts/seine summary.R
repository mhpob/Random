library(readxl); library(tidyr); library(dplyr)

key <- read_excel('p:/obrien/seine/cbl_seine_database.xlsx', sheet = 'Site_Info')
counts_lengths <- read_excel('p:/obrien/seine/cbl_seine_database.xlsx', sheet = 'Counts_Lengths')


key2018 <- key %>% 
  filter(DATE > '2018-05-01') %>% 
  mutate(PARTICIPANTS = strsplit(PARTICIPANTS, ', '))

# Number of people
k <- kk$PARTICIPANTS
k <- unlist(k)
unique(k)

data <- key2018 %>% 
  left_join(counts_lengths, by = c('RECORD NUM' = 'RECORD_NUM')) %>% 
  select(-starts_with('X_')) %>% 
  mutate(LN1 = as.numeric(LN1)) %>% 
  gather(key = 'hold',
         value = 'TL',
         LN1:LN30, 
         na.rm = T) %>% 
  select(-hold) %>% 
  mutate(TL = as.numeric(TL),
         wknum = lubridate::week(DATE))

l <- group_by(data, SCIENTIFIC) %>% 
  summarize(n = n()) %>% 
  filter(n >= 50)

k <- data %>% 
  filter(SCIENTIFIC %in% l$SCIENTIFIC)
,
         SCIENTIFIC != 'Strongylura marina')

labs <- c(
  `Brevoortia tyrannus` = 'Menhaden; Brevoortia tyrannus',
  `Leiostomus xanthurus` = 'Spot; Leiostomus xanthurus',
  `Menidia beryllina` = 'Inland silverside; Menidia beryllina',
  `Menidia menidia` = 'Atlantic silverside; Menidia menidia',
  `Morone americana` = 'White perch; Morone americana',
  `Morone saxatilis` = 'Striped bass; Morone saxatilis'
)

library(ggplot2)
TLplot <- ggplot() + geom_density(data = k, aes(TL, fill = factor(DATE)),
                                  alpha = 0.4) +
  facet_wrap(~ SCIENTIFIC, scales = 'free') +
  labs(x = 'Total length (mm)', y = 'Density', fill = 'Date') +
  scale_fill_viridis_d()+
  theme_bw()
ggsave('tlplot.jpeg', TLplot, width = 11)


# Compared to previous years
j <- key %>% 
  filter(DATE < '2018-05-01') %>% 
  left_join(counts_lengths, by = c('RECORD NUM' = 'RECORD_NUM')) %>% 
  filter(SCIENTIFIC %in% c('Brevoortia tyrannus', 'Leiostomus xanthurus',
                           'Menidia beryllina', 'Menidia menidia',
                           'Morone americana', 'Morone saxatilis')) %>% 
  select(-starts_with('X_')) %>% 
  mutate(LN1 = as.numeric(LN1)) %>% 
  gather(key = 'hold',
         value = 'TL',
         LN1:LN30, 
         na.rm = T) %>% 
  select(-hold) %>% 
  mutate(TL = as.numeric(TL),
         wknum = lubridate::week(DATE))
# Need to remove the erroneously-recorded lengths (too big)


ggplot() + geom_density(data = j, aes(TL, group = factor(wknum))) +
                        # alpha = 0.4) +
  facet_wrap(~ SCIENTIFIC, scales = 'free',
             labeller = labeller(SCIENTIFIC = labs)) +
  labs(x = 'Total length (mm)', y = 'Density', fill = 'Date') +
  theme_bw()



# What have the hauls been made of? ----
cnt <- data %>% 
  distinct(`RECORD NUM`, SCIENTIFIC, .keep_all = T) %>% 
  mutate(common = case_when(grepl('Brev', SCIENTIFIC) ~ 'Menhaden',
                            grepl('Call', SCIENTIFIC) ~ 'Blue crab',
                            grepl('Fund', SCIENTIFIC) ~ 'Mummichog',
                            grepl('Gastero', SCIENTIFIC) ~ 'Stickleback',
                            grepl('strumo', SCIENTIFIC) ~ 'Skilletfish',
                            grepl('bosc', SCIENTIFIC) ~ 'Naked goby',
                            grepl('Leio', SCIENTIFIC) ~ 'Spot',
                            grepl('beryl', SCIENTIFIC) ~ 'Inland silverside',
                            grepl('menid', SCIENTIFIC) ~ 'Atlantic silverside',
                            grepl('america', SCIENTIFIC) ~ 'White perch',
                            grepl('saxa', SCIENTIFIC) ~ 'Striped bass',
                            grepl('Paral', SCIENTIFIC) ~ 'Summer flounder',
                            grepl('Poma', SCIENTIFIC) ~ 'Bluefish',
                            grepl('Strong', SCIENTIFIC) ~ 'Needlefish',
                            grepl('Syng', SCIENTIFIC) ~ 'Pipefish'))

countplot <- ggplot() + geom_col(data = cnt, aes(x = DATE, y = COUNT, fill = common,
                                    group = `RECORD NUM`), position = 'dodge') +
  labs(x = NULL, y = 'Count', fill = NULL) +
  theme_bw()
ggsave('p:/obrien/seine/countplot.jpeg', countplot, width = 11)
