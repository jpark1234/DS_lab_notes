require(WDI)
gdp <- WDI(country=c("US", "CA", "CN", "JP", "SG", "IL", "GB"),
           indicator=c("NY.GDP.PCAP.CD", "NY.GDP.MKTP.CD"),
           start=1960, end=2011)
names(gdp) <- c("iso2c", "Country", "Year", "PerCapGDP", "GDP")
head(gdp)

require(ggplot2)
ggplot(gdp, aes(Year, PerCapGDP, color=Country, linetype=Country)) + geom_line()
ggplot(gdp, aes(Year, GDP, color=Country, linetype=Country)) + geom_line()
us <- gdp$PerCapGDP[gdp$Country == "United States"]


us <- ts(us, start=min(gdp&Year), end=max(gdp$Year))
us
#ts turns matrix into time series 
acf(us)
pacf(us)

require(forecast)
usBest <- auto.arima(us)
usBest

predict(usBest, n.ahead=5)
forecast(usBest, h=5)
plot(forecast(usBest, h=5))

install.packages("vars")
require(reshape2)
#melting is the oppostie of casting 
#acast is an array, decast is a dataframe 
gdpCast <- dcast(Year ~ Country, data=gdp, value.var="PerCapGDP")
head(gdpCast)

gdpTS <- ts(gdpCast[, -1], start=min(gdpCast$Year), end=max(gdpCast$Year))
plot(gdpTS, plot.type="single", col=1:8)

ndiffs(gdpTS) #tells you the optimal number of differences to do 
gdpDiffed <- diff(gdpTs, differences=1)
plot(gdpDiffed, plot.type="single", col=1:7)

gdpVar <- VAR(gdpDiffed, lag.max=12)
gdpVar$p
length(gdpVar$varresult)
names(gdpVar$varresult)
#basically we have seven different models, if we look at one of them
class(gdpVar$varresult$Canada) 
# we will see its just a simple linear model 

install.packages("coefplot")
require(coefplot)
coefplot(gdpVar$varresult$Canada)

#garch model won the nobel prize 

install.packages("quatmod")
require(quantmod)
att <- getSymbols("T", auto.assign=FALSE)
class(att)
plot(att)
chartSeries(att)
addBBands()
addMACD(32, 50 ,12)

attclose <- att$T.Close
install.packages("rugarch")
require(rugarch)

attSpec <- ugarchspec(variance.model=list(model="sGARCH", garchOrder=c(1,1)), 
                      mean.model=list(armaOrder=c(1,1)),
                      distribution.model = "std")
attGarch <- ugarchfit(spec=attSpec, data=attclose)

attPred <- ugarchboot(attGarch, n.ahead=50, method="partial")
plot(attPred, which=2)
#r finance 
#april 29th Chris Wiggins, hackNY, Clear channel 


