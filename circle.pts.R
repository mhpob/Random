# The following was adopted from an answer on R-Help, 20061107, by Arien Lam
# https://stat.ethz.ch/pipermail/r-help/2006-November/116851.html

# Computes the place where you end up, if you travel a certain distance along
# a great circle, which is uniquely defined by a point (your starting point)
# and an angle with the meridian at that point (your direction).
# 
# lonlatpoint is a set of longitude and latitude pairs (decimal degrees)
# radius is the radius of desired circle, in m.
# Rearth is the "ellipsoidal quadratic mean radius of the earth", in m. (FYI)

circle.pts <- function(lonlatpoint, radius) {
     Rearth <- 6372795
     magnitude <- radius / Rearth
     
     lonlatpoint <- unique(lonlatpoint)
     lonlatpoint <- lonlatpoint * (pi / 180)
     lonlatpoint[3] <- paste0('circle', seq(1,nrow(lonlatpoint),1))
     
     direction <- seq(0, 2*pi, by = 2* pi / 100)
     direction <- rep(direction, times = nrow(lonlatpoint))
     lonlatpoint <- lonlatpoint[rep(1:nrow(lonlatpoint),
                                    each = 101),]

     
     latb <- asin(cos(direction) * cos(lonlatpoint[,2]) * sin(magnitude) +
                    sin(lonlatpoint[,2]) * cos(magnitude))
     dlon <- atan2(cos(magnitude) - sin(lonlatpoint[,2]) * sin(latb),
                   sin(direction) * sin(magnitude) * cos(lonlatpoint[,2]))
     lonb <- lonlatpoint[,1] - dlon + pi / 2

     lonb[lonb >  pi] <- lonb[lonb >  pi] - 2 * pi
     lonb[lonb < -pi] <- lonb[lonb < -pi] + 2 * pi

     latb <- latb * (180 / pi)
     lonb <- lonb * (180 / pi)

     data.frame(long = lonb, lat = latb, circle = lonlatpoint[,3])
}