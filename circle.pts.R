# The following was adopted from an answer on R-Help, 20061107, by Arien Lam
# https://stat.ethz.ch/pipermail/r-help/2006-November/116851.html

# Computes the place where you end up, if you travel a certain distance along
# a great circle, which is uniquely defined by a point (your starting point)
# and an angle with the meridian at that point (your direction). The travelvector
# is actually a dataframe with at least columns of magnitude and direction.
# n.b. earth radius is the "ellipsoidal quadratic mean radius of the earth", in m.


circle.pts <- function(lonlatpoint, radius) {
     Rearth <- 6372795
     travelvector <- data.frame(cbind(direction = seq(0, 2*pi, by = 2* pi / 100),
                                      magnitude = radius))
     Dd <- travelvector$magnitude / Rearth
     Cc <- travelvector$direction

     if (class(lonlatpoint) == "SpatialPoints") {
         lata <- coordinates(lonlatpoint)[1, 2] * (pi / 180)
         lona <- coordinates(lonlatpoint)[1, 1] * (pi / 180)
     }
     else {
         lata <- lonlatpoint[2] * (pi / 180)
         lona <- lonlatpoint[1] * (pi / 180)
     }
     
     latb <- asin(cos(Cc) * cos(lata) * sin(Dd) + sin(lata) * cos(Dd))
     dlon <- atan2(cos(Dd) - sin(lata) * sin(latb), sin(Cc) * sin(Dd) * cos(lata))
     lonb <- lona - dlon + pi / 2

     lonb[lonb >  pi] <- lonb[lonb >  pi] - 2 * pi
     lonb[lonb < -pi] <- lonb[lonb < -pi] + 2 * pi

     latb <- latb * (180 / pi)
     lonb <- lonb * (180 / pi)

     data.frame(cbind(long = lonb, lat = latb))
}