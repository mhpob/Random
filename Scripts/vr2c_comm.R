library(serial)

rec_con <- serialConnection('vr2c_1', port = 'COM3',
                            mode = '9600,n,8,1',
                            buffering = 'line',
                            newline = 1,
                            handshake = 'none',
                            translation = 'crlf')
open(rec_con)
write.serialConnection(rec_con, '')
write.serialConnection(rec_con, '*450280.0#19,status')

read.serialConnection(rec_con)
j <- NULL
t <- Sys.time()

while(Sys.time() < t+2){
  j <- c(j,read.serialConnection(rec_con))
}




write.serialConnection(rec_con, '*450280.0#19,status')
strsplit(k3, "(?<=.)(?=(450280))", perl = T)

write.serialConnection(rec_con, '*450280.0#19,rtminfo')

close(rec_con)






# To find the trailing hex sum on the return string:
# 1) ASCII character vector to raw bites
# 2) Convert to decimal
# 3) Sum
# 4) Convert to hex
# 5) Take last two digits

return_hex <- function(ascii){
  hold <- charToRaw(ascii)
  hold <- as.numeric(hold)
  hold <- sum(hold)
  hold <- as.hexmode(hold)
  substr(hold, nchar(hold) - 2, nchar(hold))
}
return_hex('OK')


