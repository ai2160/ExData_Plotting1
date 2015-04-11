library(sqldf)
query = 'select * from file where Date="1/2/2007" or Date="2/2/2007"'
power <- read.csv.sql('household_power_consumption.txt', sql = query, sep = ';')
power[power == '?'] = NA
power <- power[complete.cases(power),]
png('plot1.png')
with(power, hist(Global_active_power, xlab = 'Global Active Power (kilowatts)', main = 'Global Active Power', col = 'red'))
dev.off()