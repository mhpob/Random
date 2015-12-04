turt <- read.csv('c:/users/secor lab/desktop/hbailey/costarica_2004-7lbt_forgeorge.csv', stringsAsFactors = F)
turt <- turt[!grepl('\\.', as.character(turt$track)),]


turt <- split(turt, turt$track)
for(i in seq(1, length(turt), 1)){
  turt[[i]]$number <- seq(1, dim(turt[[i]])[1], 1)
}
turt <- do.call(rbind.data.frame,turt)


library(raster)
world <- shapefile('c:/users/secor lab/desktop/gis products/natural earth/110m coastline/ne_110m_land.shp')
# points(turt$long, turt$lat)
library(ggplot2)
mapdat <- fortify(world)

library(animation)


map <- ggplot() + geom_polygon(data = mapdat, fill = 'darkgrey', color = 'black',
                        aes(long, lat, group = group)) +
  coord_map(xlim = c(-135, -78), ylim = c(-38, 12.5))

hulls <- chull(x = turt[turt$number %in% seq(1, 120, 1), 'long'],
               y = turt[turt$number %in% seq(1, 120, 1), 'lat'])

jj <- turt[turt$number %in% seq(1, 120, 1),]


saveVideo({
  for (i in 1:120){
  plot <- map +
    geom_point(data = turt[turt$number %in% seq(1, i, 1),],
               aes(x = long, y = lat, color = as.factor(track))) +
    labs(x = 'Longitude', y = 'Latitude') +
  theme(legend.position = 'none')
  print(plot)
  ani.pause()
  }
  for(k in 1:15){
    plot <- plot + geom_polygon(data = jj[hulls,], aes(x = long, y = lat),
                                color = 'black', fill = NA)
    print(plot)
    ani.pause()
  }
  }, interval = 0.2, video.name = 'helenani.wmv',
  ffmpeg = 'c:/ffmpeg/bin/ffmpeg.exe',
  ani.height = 720, ani.width = 1280,
  other.opts = "-b 300k")
