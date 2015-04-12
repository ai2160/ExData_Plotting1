library(sqldf)
library(plyr)

query = 'select * from file where Date="1/2/2007" or Date="2/2/2007"'
power <- read.csv.sql('household_power_consumption.txt', sql = query, sep = ';')
power[power == '?'] = NA
power <- power[complete.cases(power),]


power$index <- as.numeric(rownames(power))
power$DateTime <- as.Date(strptime(paste(power$Date, power$Time), "%d/%m/%Y %H:%M:%S"))
power$Day <- strftime(power$DateTime, '%a')

xAxis <- ddply(power,.(Day), summarize, atValue=min(index))
atValue <- xAxis$atValue
labelValue <- xAxis$Day
atValue <- c(atValue, length(power$index) + 1)
labelValue <- c(labelValue, 'Sat')

png('plot4.png')
par('mfrow' = c(2,2))
par('mar' = c(4.1,4.1,2,2))
plot(power$index, power$Global_active_power, type='n', 
     ylab = 'Global Active Power', xlab = '', xaxt='n')
axis(1, at = atValue, labels=labelValue)
with(power, lines(index, Global_active_power))

plot(power$index, power$Voltage, type='n', 
     ylab = 'Voltage', xlab = 'datetime', xaxt='n')
axis(1, at = atValue, labels=labelValue)
with(power, lines(index, Voltage))


plot(power$index, power$Sub_metering_1, type='n', 
                 ylab = 'Energy sub metering', xlab = '', xaxt='n')
axis(1, at = atValue, labels=labelValue)
with(power, lines(index, Sub_metering_1))
with(power, lines(index, Sub_metering_2, col = 'red'))
with(power, lines(index, Sub_metering_3, col = 'blue'))

legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lty = 1, 
       col = c("black", "red", "blue"))

plot(power$index, power$Global_reactive_power, type='n', 
     ylab = 'Global_reactive_power', xlab = 'datetime', xaxt='n')
axis(1, at = atValue, labels=labelValue)
with(power, lines(index, Global_reactive_power))
dev.off()