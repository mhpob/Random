unid <- ACTsplit('p:/obrien/biotelemetry/detections',
                 my.trans = paste0('A69-1601-', seq(25434,25533,1)),
                 false.det = c('A69-1601-37119', 'A69-1601-64288'),
                 write = F)