## Exploratory Analysis Project 1
## plot3.R
##
## This function constructs a Global Active Power histogram plot using Electric power consumption
## data from 2/1/2007 to 2/2/2007. The plot is saved to a PNG file, called plot1.png, with a width
## of 480 pixels and a height of 480 pixels.
##

plot3 <- function() {
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
        png(filename = "plots/plot3.png")
        plot(data$DateTime, data$Sub_metering_1, type = "l",  
             xlab = "", ylab="Energy sub metering")
        lines(data$DateTime, data$Sub_metering_2, col = "red")
        lines(data$DateTime, data$Sub_metering_3, col = "blue")
        
        legend("topright",legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
               lty = c(1,1,1), col = c("black", "red", "blue"), text.col= "black" )
        
        ## close the png device
        dev.off()
}