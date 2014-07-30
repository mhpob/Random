CBP Water Quality Database(1984-present) CBP_WQDB 
CBP Water Quality Database(1949-1982) CBI_WQDB 
http://api.chesapeakebay.net/rest/DataHubRESTSrv/dhHelper.svc/getExtentData/WATER_BODIES/Water_Quality_Data/CBP_WQDB 

j<-readLines('http://api.chesapeakebay.net/getWQWaterQuality.svc/WATER_BODIES/101,110,29,40,66,81,93/51/false/12311983/05212010')
jj<-xmlRoot(j)
p <- xmlSApply(jj, function(x) xmlSApply(x, xmlValue))
pt <- data.frame(t(p), row.names = NULL)

ptt <- apply(pt,2,unlist)

# Sassafras 101
#Susquehanna 110
# Choptank 29
# Elk 40
# Nanticoke 66
# Pax 81
# Potomac 93

API Loc:
http://data.chesapeakebay.net/doc/Datahub_2011_REST_API.pdf
