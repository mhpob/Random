asin(sin(60 * (pi/180)) * 1500/1440) * (180/pi)



asin(1488/1500)* (180/pi)


refr <- function(angle_in, v1, v2){
  asin(sin(angle_in * (pi/180)) * v2/v1) * (180/pi)
}
crit <- function(slow_v, fast_v){
  asin(slow_v/fast_v) * (180/pi)
}

j <- data.frame(angle = 30,
                v1 = 1488,
                v2 = 1494)


for(i in 2:10){
  j <- rbind(j,
                data.frame(angle = refr(j[i-1, 'angle'], j[i-1, 'v1'], j[i-1, 'v2']),
                           v1 = j[i-1, 'v2'],
                           v2 = j[i-1, 'v2'] + 6))
}
j
refr(80, 1488, 1500)

k <- j[10, c(1,3,2)]
names(k) <- c('angle', 'v1', 'v2')

for(i in 2:10){
  k <- rbind(k,
             data.frame(angle = refr(k[i-1, 'angle'], k[i-1, 'v1'], k[i-1, 'v2']),
                        v1 = k[i-1, 'v2'],
                        v2 = k[i-1, 'v2'] - 6))
}

rbind(j,k)

c_u <- function(t, s, z){
  1449.2 + 4.623 * t - 0.0546 * t^2 + 1.391 * (s - 35) + 0.017 * z
}

j <- seq(10.1, 27, 0.1)
plot(j[1:169], diff(acos(c_u(10, 33, 16)/c_u(j, 33, 0)) * (180/pi)))
abline(v = 11.21)

plot(j, acos(c_u(10, 33, 16)/c_u(j, 33, 0)) * (180/pi))
abline(v = 12.12)
