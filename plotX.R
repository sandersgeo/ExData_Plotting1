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

# Subset data for applicable to days
df <- subset(df, Date == as.Date("2007-02-01") | Date == as.Date("2007-02-02"))

