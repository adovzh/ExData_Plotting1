## This scripts expects to read data from 'household_power_consumption.txt' file
## located in current directory.

# function to read a portion of data from the file
read.hpc <- function(skip, nrows, header) {
    read.table("household_power_consumption.txt", sep = ";", header = header,
               stringsAsFactors = FALSE, na.strings = "?",
               skip = skip, nrows = nrows,
               colClasses = c(rep("character", 2), rep("numeric", 7)))
}

# read header
hpc <- read.hpc(skip = 0, nrows = 5, header = TRUE)
hpc.header <- colnames(hpc)

# read data related to a 2007-02-01 and 2007-02-02
# start and length parameters are determined using command line tools
hpc <- read.hpc(skip = 66637, nrows = 2880, header = FALSE)
colnames(hpc) <- hpc.header

# parse and add Timestamp column to the data frame
hpc <- cbind(Timestamp = strptime(paste(hpc$Date, hpc$Time), format = "%d/%m/%Y %H:%M:%S"), hpc)

# create a plot and save it into png file
ylabel <- "Energy sub metering"
png("plot3.png", width = 480, height = 480)
with(hpc, {
    plot(Timestamp, Sub_metering_1, col = "black", type = "l", xlab = "", ylab = ylabel)
    lines(Timestamp, Sub_metering_2, col = "red")
    lines(Timestamp, Sub_metering_3, col = "blue")
    legend("topright", colnames(hpc)[8:10], col = c("black", "red", "blue"), lty = 1)
})
dev.off()
