require(WDI)
gdp <- WDI(country=c("US","CA","GB","CN", "JP"), 
           indicator=c("NY.GDP.PCAP.CD", "NY.GDP.MKTP.CD"),
           start=1960, end=2011)

head(gdp)
require(ggplot2)
require(plyr)
names(gdp) <- c("iso2c","country","year", "percapgdp", "gdp")
ggplot(gdp, aes(x=year,y=percapgdp))+geom_line(aes(color=country, linetype=country))

us <- gdp$percapgdp[gdp$country== "United States"]
head(us)

us <- ts(us, start=min(gdp$year), end=max(gdp$year))
us

acf(us)
pacf(us)
plot(diff(us))
#ar1 <- today depends on yesterday, yesterday depends on the day before
#ma1 <- pevious days' erros 

require(forecast)
usBest <- auto.arima(x=us)
usBest
plot(usBest$residuals)
acf(usBest$residuals)
pacf(usBest$residuals)

#n.ahead = numbre of periods 
predict(usBest, n.ahead=5, se.fit =TRUE)
thefrecast <- forecase(usBest, h=5)

require(quantmod)
att <- getSymbols("T", autlsyjp=)

require(rugarch)
chartSeries(att)
attCloes ,- a$5 lcdatse
attspec <- ugarchspec (variance.model = list(moeep="STARDJ"),
                        gmarcoder c(1,1)
                        disbitution.mel = "std")
archgarch <- ugarchfit(spec=atSpec, data=allClose)

#####################################################
#sattistical graphics are comparison
#infographics are dumbed down, pizass, dumbed down, more boom
usDF <- gdp[gdp$country=="United States",]

head(usDF)
ggplot(usDF, aes(x=year, y=percapgdp, size=GDP))+geom_point(shape=7) +geom_text(x=1990, y=40000, label="Aerosmith", size=3)
##take the log of variables??

