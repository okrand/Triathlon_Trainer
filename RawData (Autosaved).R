require (graphics)
pdf("GBike_raw.pdf")

#names<- c('TimeStamp','Ax','Ay','Az','Gx','Gy','Gz')

data<-read.csv("Bike.csv", header = FALSE)

#data[order(as.Date(data$V1, format="%Y-%m-%d %H:%M:%S +%f")),]

#data<-data[order(data$V1),]

#write.csv(data, file="sortRun.csv")



xRMS<-paste("xRMS: ", sqrt(mean(data$V5^2)))
yRMS<-paste("yRMS: ", sqrt(mean(data$V6^2)))
zRMS<-paste("zRMS: ", sqrt(mean(data$V7^2)))


plot(data$V5, type='o', pch='.', col="red", ylim=c(-10,10), xlab="Time", ylab = "Rotation Rate", main = "Bike Gyroscope")
lines(data$V6, type='o', pch='.', col="blue")
lines(data$V7, type='o', pch='.', col="green")
legend(0, 10, c("X", "Y", "Z"), col=c("red","blue","green"), pch=c(20,20,20))

text(c(100,100,100),c(10,9,8), labels=c(xRMS, yRMS ,  zRMS))

dev.off()
