### URL-based ------------------------------------------------------------------
# Weather underground
# NOAA Tides and Currents
# Note the need for looping or many input parameters to make this worth it.


### Web scraping ---------------------------------------------------------------
library(rvest); library(ggplot2); library(dplyr)

## Rugby
RWC <- html('http://en.wikipedia.org/wiki/Rugby_World_Cup')

tourneys <- RWC %>%
  html_nodes('table') %>%
  .[[3]] %>%
  html_table()

tourneys$'Total attendance' <- 
  as.numeric(unlist(lapply(strsplit(tourneys$'Total attendance', ','),
       paste, collapse = '')))

ggplot() + geom_line(data = tourneys, aes(x = Year, y = `Total attendance`))


## Tom
tom <- html('https://scholar.google.com/citations?user=cET1m2EAAAAJ&hl=en&pagesize=200')
tomcite <- tom %>%
  html_nodes('table') %>%
  .[[2]] %>%
  html_table()

names(tomcite) <- c('title', 'cites', 'year')
tomcite <- tomcite[2:dim(tomcite)[1],]
for(i in 2:3){tomcite[, i] <- as.numeric(tomcite[, i])}

ggplot() + geom_point(data = tomcite, aes(year, cites), size = 5)

tomcite$fish <- ifelse(grepl('fish', tomcite$title), 'fish',
                ifelse(grepl('crab', tomcite$title), 'crab','other'))
ggplot() + geom_point(data = tomcite, aes(year, cites, color = fish), size = 5)

tomcite$nation <- ifelse(grepl('Canadian', tomcite$title), 'Canada',
                  ifelse(grepl('American', tomcite$title), 'Murica','Other'))
ggplot() + geom_point(data = tomcite, aes(year, cites, color = nation), size = 5)

### Other ----------------------------------------------------------------------
# CBL Pier
# Chrome > Inspect Element > Network