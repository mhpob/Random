setwd ("C:/Misc/Dissertation/")
data1<-read.csv ("SGR data_MANOVA.csv", header=TRUE)
SGR<-manova (cbind(OverallSGRL, OverallSGRweight) ~Treatment+Strain+SamplingEvent, data=data1)
summary(SGR) #manova with two dependent variables

SGR1<-manova(cbind(OverallSGRL, OverallSGRweight)~Treatment+Strain+Treatment*Strain, data=data1)
summary(SGR1)

SGR2<-aov(OverallSGRL~Treatment+Strain+Treatment*Strain, data=data1)
summary(SGR2)
