# Zip file name
zfile <- "data/exdata_data_household_power_consumption.zip"

# File name
fileobj <- "data/household_power_consumption.txt"

# Url for data file
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# Create data directory if non-existent
if (!file.exists("data")){
  dir.create("data")
}

# Download file if non-existent
if (!file.exists(zfile)){
  download.file(fileUrl, destfile = zfile, method = "auto")
}

# Unzip file
ufile <- unzip(zfile)

# Read unzipped file to dataframe
df <- read.csv(ufile, sep = ';', stringsAsFactors = FALSE, header = TRUE)

# Combine day and time in single column
df$DateTime <- paste(df$Date,df$Time, sep = "T")

# Convert characters to date/time object
df$DateTime <- as.POSIXlt(df$DateTime, format = "%d/%m/%YT%H:%M:%S")

# Reformat date/time object to Y/M/D
df$DateTime <- as.POSIXlt(df$DateTime, format = "%Y-%m-%dT%H:%M:%S")

# Convert characters to date objects
df$Date <- as.Date(df$Date, format = "%d/%m/%Y")

# Reformat date objects to Y/M/D
df$Date <- as.Date(df$Date, format = "%Y-%m-%d")

# Convert characters to numeric
# class(df$Sub_metering_1)
# df$Sub_metering_1 <- as.numeric(df$Sub_metering_1)
# df$Sub_metering_2 <- as.numeric(df$Sub_metering_2)
# df$Sub_metering_3 <- as.numeric(df$Sub_metering_3)

head(df)

# Subset data for applicable to days
df <- subset(df, Date == as.Date("2007-02-01") | Date == as.Date("2007-02-02"))

# head(df)

# Convert characters to numeric
df$Global_active_power <- as.numeric(df$Global_active_power)

# Create plot graphic file
png(file = "plot4.png")

# Plot All subgraphs 2x2
par(mfrow=c(2,2))

# Plot Global_active_power histogram
hist(df$Global_active_power, col = 'red', main = "Global Active Power",
     xlab = "Global Active Power (kilowats)")

# Plot voltage
plot(df$DateTime, as.numeric(df$Voltage), type="l", xlab="datetime", ylab="Voltage")

# Plot Sub_metering_x lines
plot(df$DateTime, as.numeric(df$Sub_metering_1), type = "l", main = "",
     xlab = "", ylab = "Energy sub metering")
lines(df$DateTime, as.numeric(df$Sub_metering_2), type = "l", col = "red")
lines(df$DateTime, as.numeric(df$Sub_metering_3), type = "l", col = "blue")
legend("topright", lty=1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3" ))

# Plot Global Reactive Power
plot(df$DateTime, as.numeric(df$Global_reactive_power), type="l", xlab="datetime", ylab="Global_reactive_power")

# Close file
dev.off()