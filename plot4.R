#R script for Exploratory Data Analysis Week 1 Project
#
#load libraries we need
library(dplyr)
library(lubridate)


#set the directory we want to work in
wdir<-c("./week1project")

#Check to see if the directory we want already exists, if not create it
if(!file.exists(wdir)){dir.create(wdir)}

#make the working directory the same
setwd(wdir)

#check to see if we already got the data
if(!file.exists("data.zip")){
  
  #download the raw data zip file
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",destfile="data.zip")
  
  #unzip the file and put all the files into the working directory
  unzip("data.zip", junkpaths=TRUE, exdir=".")
}

#read in the data for only 2/1/2007 and 2/2/2007 - rows 23438 to 69517
power<-read.table("household_power_consumption.txt",header=TRUE,sep=";")

#convert to df table
pwrtbl<-as_tibble(power)

#remove the power variable
rm("power")

#rename the Date and Time variables to avoid reserved words
pwrtbl<-rename(pwrtbl,DateRec=Date, TimeRec=Time)

#filter for just 2/1 and 2/2
pwrtbl<-filter(pwrtbl,DateRec=="1/2/2007" | DateRec=="2/2/2007")

#add a combined date/time variable
pwrtbl<-mutate(pwrtbl,Datetime=dmy_hms(paste(DateRec,TimeRec)))

#make sure the other variables are numeric
pwrtbl<-mutate(pwrtbl,Global_active_power=as.numeric(Global_active_power))
pwrtbl<-mutate(pwrtbl,Global_reactive_power=as.numeric(Global_reactive_power))
pwrtbl<-mutate(pwrtbl,Voltage=as.numeric(Voltage))
pwrtbl<-mutate(pwrtbl,Global_intensity=as.numeric(Global_intensity))
pwrtbl<-mutate(pwrtbl,Sub_metering_1=as.numeric(Sub_metering_1))
pwrtbl<-mutate(pwrtbl,Sub_metering_2=as.numeric(Sub_metering_2))
pwrtbl<-mutate(pwrtbl,Sub_metering_3=as.numeric(Sub_metering_3))

#Create plot4
png("plot4.png", width=480, height=480, units="px", bg="white")
par(mfrow=c(2,2),mar=c(4,4,2,1))
plot(pwrtbl$Datetime,pwrtbl$Global_active_power, type="l", ylab="Global Active Power",xlab="")
plot(pwrtbl$Datetime,pwrtbl$Voltage, type="l", ylab="Voltage",xlab="datetime")
with(pwrtbl, plot(Datetime,Sub_metering_1,type="n",col="black",ylab="Energy sub metering",xlab=""))
with(pwrtbl,points(Datetime,Sub_metering_1,col="black",type="l"))
with(pwrtbl,points(Datetime,Sub_metering_2,col="red",type="l"))
with(pwrtbl,points(Datetime,Sub_metering_3,col="blue",type="l"))
legend("topright",col=c("black","red","blue"),legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lty=1)
plot(pwrtbl$Datetime,pwrtbl$Global_reactive_power,type="l",ylab="Global_reactive_power", xlab="datetime")
dev.off()

#return to original working directory
setwd("../")
