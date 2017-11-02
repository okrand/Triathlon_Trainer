require (graphics)
pdf("Bike_raw.pdf")

#names<- c('TimeStamp','Ax','Ay','Az','Gx','Gy','Gz')

data<-read.csv("Bike.csv", header = FALSE)

#data[order(as.Date(data$V1, format="%Y-%m-%d %H:%M:%S +%f")),]

data<-data[order(data$V1),]

write.csv(data, file="sortBike.csv")



xRMS<-paste("xRMS: ", sqrt(mean(data$V2^2)))
yRMS<-paste("yRMS: ", sqrt(mean(data$V3^2)))
zRMS<-paste("zRMS: ", sqrt(mean(data$V4^2)))


plot(data$V2, type='o', pch='.', col="red", ylim=c(-1.5,1.5), xlab="Time", ylab = "Amplitude", main = "Bike Accelerometer")
lines(data$V3, type='o', pch='.', col="blue")
lines(data$V4, type='o', pch='.', col="green")
legend(0, 1.5, c("X", "Y", "Z"), col=c("red","blue","green"), pch=c(20,20,20))

text(c(100,100,100),c(1.5,1.39,1.28), labels=c(xRMS, yRMS ,  zRMS))

dev.off()
