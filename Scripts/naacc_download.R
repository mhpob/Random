# North Atlantic Aquatic Connectivity Collaborative (NAACC) data download
# https://naacc.org/naacc_search_crossing.cfm
# Works as of 20210129

library(httr)

POST('https://naacc.org/naacc_search_crossing_action.cfm',
     body = list(
       sceReset = 'false',
       stateSelect = 12,
       town = '',
       stream = 'James River watershed',
       watershedID = '',
       observerID = '',
       coordinatorID = '', 
       SurveyId = '',
       CrossingCode = '',
       standardID = '',
       num = '25',
       datasetID = 1,
       lastupdated_from = 'All',
       lastupdated_to = 'All',
       date_observed_from = 'All',
       date_observed_to = 'All',
       Submit =  'Search'
     ))


GET('https://naacc.org/naacc_export_begin.cfm?ds=naacc&r=shapefile')
GET('https://naacc.org/naacc_export_shapefile.cfm')
GET('https://naacc.org/naacc_export_shapefile_action.cfm')

response <- GET('https://naacc.org/excel/0/shapefile.zip',
                write_disk(paste0('NAACC_shapefile_',Sys.Date(), '.zip'),
                           overwrite = T
                )
)

unzip(file.path(response$content),
      exdir = gsub('.zip', '', file.path(response$content))
)



library(sf)
shape <- read_sf(gsub('.zip', '', file.path(response$content)))

plot(st_geometry(shape))
