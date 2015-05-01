CBP Water Quality Database(1984-present) CBP_WQDB 
CBP Water Quality Database(1949-1982) CBI_WQDB 
http://api.chesapeakebay.net/rest/DataHubRESTSrv/dhHelper.svc/getExtentData/WATER_BODIES/Water_Quality_Data/CBP_WQDB 

library(XML)
cbpurl <- xmlTreeParse('http://api.chesapeakebay.net/getWQWaterQuality.svc/WATER_BODIES/101,110,29,40,66,81,93/51/false/12311983/05212010')
cbproot <- xmlRoot(cbpurl)
cbp <- xmlSApply(cbproot, function(x) xmlSApply(x, xmlValue))

# Change class
cbpchar <- apply(cbp, 1, as.character)
cbp_df <- data.frame(cbpchar, row.names = NULL,
                     stringsAsFactors = F)
cbp_df <- lapply(cbp_df, type.convert, na.strings = 'character(0)')
cbp_df <- do.call(cbind.data.frame, cbp_df)


# Sassafras 101
#Susquehanna 110
# Choptank 29
# Elk 40
# Nanticoke 66
# Pax 81
# Potomac 93

API Loc:
http://data.chesapeakebay.net/doc/Datahub_2011_REST_API.pdf