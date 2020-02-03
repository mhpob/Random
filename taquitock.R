library(dplyr)

## Download and unzip VA Sandy 2015 1m NED ----
# https://www.sciencebase.gov/catalog/item/581d2458e4b08da350d584c4


# Keeping this commented since it takes a while to download/unzip

# download.file('https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/1m/IMG/USGS_NED_one_meter_x28y416_VA_Sandy_2014_IMG_2015.zip',
#               'c:/users/secor/downloads/USGS_NED_one_meter_x28y416_VA_Sandy_2014_IMG_2015.zip')
# unzip('c:/users/secor/downloads/USGS_NED_one_meter_x28y416_VA_Sandy_2014_IMG_2015.zip','USGS_NED_one_meter_x28y416_VA_Sandy_2014_IMG_2015.img')



## Elevation data import and manipulation ----
# Going to use a stars proxy object, as it runs super quickly. The vignettes are great:
# https://r-spatial.github.io/stars/index.html

library(stars)

elev_data <- read_stars('USGS_NED_one_meter_x28y416_VA_Sandy_2014_IMG_2015.img', 
                        proxy = T)


# Convert lat/long of property to UTM and buffer point with 137 m (encompasses property)

house <- c(-77.384226, 37.527999) %>%
  # Make coordinate into a point
  st_point() %>%
  # Make point into an simple feature (sf object)
  st_sfc() %>% 
  # Make coordinate reference system lat/long
  st_set_crs(4326) %>%
  # Transform CRS to the proper UTM (CRS of elev_data)
  st_transform(st_crs(elev_data)) %>%
  # Create 137m radius buffer
  st_buffer(137)


# Crop elevation data to house buffer

elev_data <- elev_data[house]



## Create ray shade thing! ----

library(rayshader)


# Pull elevation data into memory as a raster object, then convert to matrix for
# rayshader

elev_data <- elev_data %>%
  as('Raster') %>%
  raster_to_matrix()


# Throw some shade

elev_data %>%
  sphere_shade(colorintensity = 50, sunangle = 270) %>%
  plot_map()

raymat <- ray_shade(elev_data,
                    sunangle = 73)

elev_data %>%
  sphere_shade(colorintensity = 50) %>%
  add_shadow(raymat, max_darken = 0.5) %>%
  plot_3d(elev_data, theta = 195, phi = 20, baseshape = 'circle',
          zoom = 0.35, zscale = 0.55, windowsize = c(1000, 900))

render_snapshot(clear = T, instant_capture = F)
rgl::rgl.close()

elev_data %>%
  sphere_shade() %>%
  plot_3d(elev_data, zscale = 0.35, theta = 195,phi = 20)

save_3dprint('taquitock_3d_2.stl', maxwidth = 100)

rgl::readSTL('taquitock_3d.stl', col = 'green')

## Sun path over Taquitock ----
# Following http://matthewkling.github.io/media/rayshader/
library(insol)

sun <- seq(ISOdate(2020, 12, 21, 0, tz = 'America/New_York'),
           ISOdate(2020, 12, 21, 24, tz = 'America/New_York'), by = "min") %>%
  JD() %>%
  sunvector(37.527999, -77.384226, -5) %>%
  sunpos() %>% 
  as.data.frame() %>%
  mutate(id = 1:nrow(.),
         zenith = 90 - zenith) %>%
  filter(zenith >= -6, # exclue nighttime
         id %% 3 == 0) # keep every three minutes


library(magick)

img <- image_graph(width = 500, height = 500)

# generate hillshade image for each solar position
pb <- txtProgressBar(max = nrow(sun))
for(i in 1:nrow(sun)){
  azimuth <- sun$azimuth[i]
  zenith <- sun$zenith[i]
  
  elev_data %>%
    sphere_shade(sunangle = azimuth, colorintensity = 50) %>% 
    # add_shadow(ambient_shade(elev_data)) %>%
    add_shadow(ray_shade(elev_data,
                         anglebreaks = seq(zenith - 4, zenith + 4, 1),
                         sunangle = azimuth),
               max_darken = 0.5) %>%
    plot_map()
  
  setTxtProgressBar(pb, i)
}
close(pb)

# save animation
dev.off()
img %>% image_animate(fps = 10) %>% image_write("animation.gif")



## Overlay image onto 3D elevation ----
# This currently doesn't work.
library(stars)

# Write proxy of JPEG2000 image
pic <- read_stars('c:/users/secor/downloads/m_3707729_se_18_1_20160723_20160928.jp2',
                  proxy = T)

house <- c(-77.384226, 37.527999) %>%
  # Make coordinate into a point
  st_point() %>%
  # Make point into an simple feature (sf object)
  st_sfc() %>% 
  # Make coordinate reference system lat/long
  st_set_crs(4326) %>%
  # Transform CRS to the proper UTM (CRS of elev_data)
  st_transform(st_crs(pic)) %>%
  # Create 137m radius buffer
  st_buffer(137)


pic <- st_crop(pic, house)

# Convert elev_dat to pic CRS
elev_data <- st_transform(elev_data, st_crs(pic))
elev_data <- st_as_stars(elev_data)

pic_full <- st_as_stars(pic)



library(rayshader)
p <- as(pic_full[,,], 'Raster')
p <- raster_to_matrix(p)

x <- as(x, 'Raster')
x <- raster_to_matrix(x)


pp <- png::readPNG('test.png')

x %>%
  sphere_shade(colorintensity = 50, sunangle = 45) %>%
  add_overlay(p, alphalayer = 0.5) %>%
  plot_map()





## Other data sources ----
library(stars)

tt <- read_stars('c:/users/secor/downloads/Job505045_va2014_usgs_cmgp_sandy_m4970/Job505045_va2014_usgs_cmgp_sandy_m4970.tif',
                 proxy = T)
house <- c(-77.384226, 37.527999) %>%
  # Make coordinate into a point
  st_point() %>%
  # Make point into an simple feature (sf object)
  st_sfc() %>% 
  # Make coordinate reference system lat/long
  st_set_crs(4326) %>%
  # Transform CRS to the proper UTM (CRS of elev_data)
  st_transform(st_crs(tt)) %>%
  # Create 137m radius buffer
  st_buffer(137)


tt <- tt[house]


library(rayshader)


# Pull elevation data into memory as a raster object, then convert to matrix for
# rayshader

tt <- tt %>%
  as('Raster') %>%
  raster_to_matrix()


# Throw some shade

tt %>%
  sphere_shade(colorintensity = 50, sunangle = 270) %>%
  plot_map()

raymat <- ray_shade(tt,
                    sunangle = 73)

tt %>%
  sphere_shade(colorintensity = 50) %>%
  add_shadow(raymat, max_darken = 0.5) %>%
  plot_3d(tt, theta = 195, phi = 20, baseshape = 'circle',
          zoom = 0.35, zscale = 0.55, windowsize = c(1000, 900))







## LIDAR ----
library(lidR)

tt_las <- readLAS('c:/users/secor/downloads/USGS_LPC_VA_Sandy_2014_18STG8956_LAS_2015/USGS_LPC_VA_Sandy_2014_18STG8956_LAS_2015.las')

library(sf)
house <- c(-77.384226, 37.527999) %>%
  # Make coordinate into a point
  st_point() %>%
  # Make point into an simple feature (sf object)
  st_sfc() %>% 
  # Make coordinate reference system lat/long
  st_set_crs(4326) %>%
  # Transform CRS to the proper UTM (CRS of elev_data)
  st_transform(st_crs(tt_las)) %>%
  # Create 137m radius buffer
  st_buffer(137)


tt_las <- lasclip(tt_las, matrix(st_bbox(house), ncol = 2))

plot(tt_las)

tt_dsm <- grid_canopy(tt_las, res = 0.5,
                      pitfree(c(0, 2, 5, 10, 15), c(0, 1.5)))

library(rayshader)
p <- tt_dsm %>% 
  raster_to_matrix()


# Throw some shade

p %>%
  sphere_shade(colorintensity = 50, sunangle = 270) %>%
  plot_map()

raymat <- ray_shade(p,
                    sunangle = 73)

p %>%
  sphere_shade(colorintensity = 50) %>%
  plot_3d(p, theta = 195, phi = 20,zscale = 0.5, mouseMode = c('trackball', 'zoom'))
