library(dplyr); library(sf)
# sb <- st_read('p:/obrien/biotelemetry/hudson sb/detections/mobile_tracking_2017_UMD_stripedbass.shp')
hud <- st_read('C:/Users/secor/Downloads/hr_contours/hr-10m-1m_contour.shp')


# Find depth islands (same beginning/end point)
islands <- lapply(st_geometry(hud), function(x) x[1,] == x[nrow(x),])

# Remove islands
hud.lines <- hud[!sapply(islands, function(x) !F %in% x),]

# Pull out one depth contour
test <- hud.lines %>% filter(CONTOUR == -10)
# test <- test[1:100,]

# for each linestring, find the linestring that is closest to its endpoints

# polygons <- st_sfc(crs = st_crs(test))

log <- NULL
line.dists <- 0
system.time(
while(as.numeric(min(line.dists, na.rm = T)) <= 400){
  endpts <- st_line_sample(test, sample = c(0, 1))
  
  dist.diag.drop <- function(x){
    l <- st_distance(x)
    diag(l) <- NA
    l
  }

  line.dists <- dist.diag.drop(endpts)
  min.index <- arrayInd(which.min(line.dists), dim(line.dists))
 
  pts <- endpts[min.index]
  pts <- st_cast(pts, 'POINT')
  pt.min <- which(st_distance(pts) == min(line.dists, na.rm = T),
                  arr.ind = T)[1,]

  combined <- st_multilinestring(list(st_geometry(test)[[min.index[1]]],
                          st_linestring(st_coordinates(pts[pt.min])),
                          st_geometry(test)[[min.index[2]]])) %>% 
    st_line_merge() %>% 
    st_sfc() %>%
    st_sf(ID = 'NEW', CONTOUR = -10, crs = st_crs(test), geometry = .)

  
  if(st_intersects(st_line_sample(combined, sample = 1),
                   st_line_sample(combined, sample = 0), sparse = F)){
    polygons <- rbind(polygons, combined)
    test <- test[-min.index]
  } else{
    test <- test[-min.index,]
    test <- rbind(test, combined)
  }
  log <- c(log, min(line.dists, na.rm = T))
}
)

library(mapview)
mapview(test)
mapview(hud.lines, zcol = 'CONTOUR')
+ mapview(sb, zcol = 'TAG1')



# Parallel??
hud.spl <- split(hud.lines, hud.lines$CONTOUR)
hud.spl <- hud.spl[1:20]

parfunc <- function(q, stopdist = 400){
  working.data <- q
  wd.crs <- st_crs(q)
  contr <- unique(q$CONTOUR)
  line.dists <- 0
  
  dist.diag.drop <- function(x){
    l <- st_distance(x)
    diag(l) <- NA
    l
  }
  
  while(as.numeric(min(line.dists, na.rm = T)) <= stopdist &
        nrow(working.data) > 1){
    
    endpts <- st_line_sample(working.data, sample = c(0, 1))
    
    line.dists <- dist.diag.drop(endpts)
    min.index <- arrayInd(which.min(line.dists), dim(line.dists))
    
    pts <- endpts[min.index]
    pts <- st_cast(pts, 'POINT')
    pt.min <- which(st_distance(pts) == min(line.dists, na.rm = T),
                    arr.ind = T)[1,]
    
    combined <- st_multilinestring(list(st_geometry(working.data)[[min.index[1]]],
                                        st_linestring(st_coordinates(pts[pt.min])),
                                        st_geometry(working.data)[[min.index[2]]])) %>% 
      st_line_merge() %>% 
      st_sfc() %>%
      st_sf(ID = paste(working.data$ID[min.index[1]], working.data$ID[min.index[2]]),
            CONTOUR = contr, geometry = ., crs = wd.crs)
    
      working.data <- working.data[-min.index,]
      working.data <- rbind(working.data, combined)
    # log <- c(log, min(line.dists, na.rm = T))
  }
  working.data
}

library(parallel)
cl <- makeCluster(detectCores() - 1)
clusterExport(cl, 'hud.spl')
clusterEvalQ(cl, library(sf))
clusterEvalQ(cl, library(dplyr))

system.time(
contours <- parLapply(cl = cl,
                  X = hud.spl,
                  fun = parfunc)
)

stopCluster(cl)
