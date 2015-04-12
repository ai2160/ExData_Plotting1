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

png('plot2.png')
par('mar' = c(3,4,4,2))
plot(power$index, power$Global_active_power, type='n', 
                 ylab = 'Global Active Power (kilowatts)', xaxt='n')
axis(1, at = atValue, labels=labelValue)
with(power, lines(index, Global_active_power))
dev.off()