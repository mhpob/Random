## Pulls data from CO-OPS (NOAA Tides and Currents)
## Visit http://tidesandcurrents.noaa.gov/api/ for full API
## Date format: yyyyMMdd
## Common stations:
##      Solomons: 8577330
##      Choptank: 8571892
##      OCI: 8570283
##      Wash, Dc: 8594900
## Common data products: air_temperature, water_temperature, wind, salinity, currents

## M. O'Brien 20140424

NOAAimp <- function(START, END, STATION, DATA){
  START <- as.Date(as.character(START), format = "%Y%m%d")
  END <- as.Date(as.character(END), format = "%Y%m%d")
  STARTS <- seq(START,END,'months')
  STARTS <- paste(format(STARTS, "%Y"),format(STARTS, "%m"),format(STARTS, "%d"), sep='')
  j <- paste('http://tidesandcurrents.noaa.gov/api/datagetter?begin_date=',
           STARTS,'&range=744&station=',STATION,'&product=',DATA,
           '&units=metric&time_zone=gmt&application=UMCES&format=csv', sep = '')
  jj <- lapply(j,read.csv)
  jjj <- do.call(rbind, jj)
}

#### Example usage:
# st <- 20090901                # Start Date
# end <- 20100830               # End Date
# stat <- 8577330               # Pull data from Solomons
# dat <- 'water_temperature'    # Pull water temperature
# CBL.all.temp <- NOAAimp(st, end, stat, dat)