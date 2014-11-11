## Exploratory Analysis Project 1
## plot4.R
##
## This function constructs four plots using Electric power consumption data from 2/1/2007 to 
## 2/2/2007. The plots are saved to a PNG file, called plot4.png, with a width of 480 pixels and 
## a height of 480 pixels.
## plot1: Global Active Power over 2/1/2007 to 2/2/2007
## plot2: Votage over 2/1/2007 to 2/2/2007
## plot3: Energy sub metering over 2/1/2007 to 2/2/2007
## plot4: Global_reactive_power over 2/1/2007 to 2/2/2007
##

plot4 <- function() {
        ## load required package
        require("sqldf")
        
        ## download the data file and unzip it to the data folder
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                      destfile="data/household_power_consumption.zip")
        unzip("data/household_power_consumption.zip","household_power_consumption.txt", 
              exdir = "data", overwrite = TRUE)
        
        ## read data of given period
        data <- read.csv.sql("data/household_power_consumption.txt", header = TRUE, 
                             sep = ";", dbname = tempfile(),
                             sql = "select * from file where Date = '1/2/2007' 
                             or Date = '2/2/2007' ")
        
        ## close all connection created by the read.csv.sql function
        closeAllConnections()
        
        ## transform the Date and Time variables to Date/Time class in R
        data$DateTime <- strptime(paste(data$Date, data$Time), "%d/%m/%Y %H:%M:%S")
        
        ## Create a png device and contructs the plot
        png(filename = "plots/plot4.png")
        
        ## set multiple-plot framework
        par(mfrow = c(2,2))
        with(data, {
                ## construct plot1
                plot(data$DateTime, data$Global_active_power, type = "l",  
                     xlab = "", ylab="Global Active Power (kilowatts)")
                
                ## construct plot2
                plot(data$DateTime, data$Voltage, type = "l", xlab = "datetime", ylab = "Voltage")
                
                
                ## construct plot3
                plot(data$DateTime, data$Sub_metering_1, type = "l",  
                xlab = "", ylab="Energy sub metering")
                lines(data$DateTime, data$Sub_metering_2, col = "red")
                lines(data$DateTime, data$Sub_metering_3, col = "blue")
                legend("topright",legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
                        lty = c(1,1,1), col = c("black", "red", "blue"), text.col= "black" )
                
                ## construct plot4
                plot(data$DateTime, data$Global_reactive_power, type = "l",
                     xlab = "datetime", ylab = "Global_reactive_power")
        })
        
        ## close the png device
        dev.off()
}