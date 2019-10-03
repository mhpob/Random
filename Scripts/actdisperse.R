library(TelemetryR)

ACTupdate(local.ACT = 'ACTactive.rda')

# Tag "A69-9001-26563" is MD DNR's test transmitter.

unid <- ACTsplit('p:/obrien/biotelemetry/detections', 'ACTactive.rda',
                 my.trans = paste0('A69-1601-', seq(25434,25533,1)),
                 write = F, start = '20160101')

UNIDprep(unid, directory = 'p:/obrien/biotelemetry/detections',
         out = 'c:/users/secor/desktop')
