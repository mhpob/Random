### URL-based ------------------------------------------------------------------
# NOAA Tides and Currents Code
download.file('https://raw.githubusercontent.com/mhpob/Random/master/noaa.R',
              'noaa.R')


# Weather underground code
download.file('https://raw.githubusercontent.com/mhpob/Random/master/wunderimp.R',
              'wunderimp.R')



### Web scraping ---------------------------------------------------------------
library(rvest); library(ggplot2)

## Tom's Google Scholar page
#  Import the HTML tree using rvest
tom <- html('https://scholar.google.com/citations?user=cET1m2EAAAAJ&hl=en&pagesize=200')

#  Now pull out the correct table. Remember that you may have to cycle which table
#  you want by changing the number below. html_nodes, %>%, and html_table are from
#  the rvest package
tomcite <- tom %>%
  html_nodes('table') %>% 
  .[[2]] %>%
  html_table()

#  Quick editing to give columns correct names and classes 
names(tomcite) <- c('title', 'cites', 'year')
tomcite <- tomcite[2:dim(tomcite)[1],]
for(i in 2:3){tomcite[, i] <- as.numeric(tomcite[, i])}

#  Plotting using ggplot2 package
ggplot() + geom_point(data = tomcite, aes(year, cites), size = 5)

#  If/then statement to pull the words "fish" and "crab" out of paper titles
tomcite$fish <- ifelse(grepl('fish', tomcite$title), 'fish',
                ifelse(grepl('crab', tomcite$title), 'crab','other'))
ggplot() + geom_point(data = tomcite, aes(year, cites, color = fish), size = 5)

#  If/then statement to pull "Canadian" and "American" out of titles
tomcite$nation <- ifelse(grepl('Canadian', tomcite$title), 'Canada',
                  ifelse(grepl('American', tomcite$title), 'Murica','Other'))
ggplot() + geom_point(data = tomcite, aes(year, cites, color = nation), size = 5)


## Rugby World Cup Wikipedia Page
RWC <- html('http://en.wikipedia.org/wiki/Rugby_World_Cup')

tourneys <- RWC %>%
  html_nodes('table') %>%
  .[[3]] %>%
  html_table()

tourneys$'Total attendance' <- 
  as.numeric(unlist(lapply(strsplit(tourneys$'Total attendance', ','),
       paste, collapse = '')))

ggplot() + geom_line(data = tourneys, aes(x = Year, y = `Total attendance`))



### Other ----------------------------------------------------------------------
# CBL Pier
download.file('https://raw.githubusercontent.com/mhpob/Random/master/PierRip.R',
              'cblpier.R')
