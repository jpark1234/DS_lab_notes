##aggregate function

### sringsAsFactors=FALSE : include this argument in the readHTMLtable
###try rescraping the data with this argument and see if it works 

###change date 
UFO$Date <- as.Date(UFO$Date, format="%m/%d/%y")
require(lubridate)
UFO$Year <- year(UFO$Date)

unique(UFO$Year)
aggregate(pdate ~ Year, length, data=UFO)

###options
write.table(UFO, file="UFO.csv",sep=",", row.names=FALSE)
write.table(UFO, file="UFO.csv",sep="\t", row.names=FALSE)
write.csv(UFO, file="UFO.csv",sep="\t", row.names=FALSE) 
###do write.csv if you want to open it on sqllite 

###read.csv2? 

###Regular expresions####
require(stringr)
require(XML)

###which=3 means get the third table 
pres <- readHTMLTable("http://www.loc.gov/rr/print/list/057_chron.html", 
                      which=3, as.data.frame=TRUE, skip.rows=1, header=TRUE,
                      stringsAsFactors=FALSE)


load(url("http://www.jaredlander.com/data/presidents.rdata"))
presidents <- presidents[1:64,]
presidents$YEAR

yearList <- str_split(string=presidents$YEAR, pattern = "-")
yearMatrix <-data.frame(Reduce(rbind, yearList))

presidents$PRESIDENT
str_sub(string=presidents$PRESIDENT, start=1, end=3)
str_sub(string=presidents$PRESIDENT, start=4, end=8)

johnPos <- str_detect(string=presidents$PRESIDENT, pattern=ignore.case("John"))
presidents$PRESIDENT[johnPos]

###this removes all the johns, and you get NA in johns place
str_extract(string=presidents$PRESIDENT, pattern=ignore.case("John"))
presidents$PRESIDENT[johnPos]

load(url("http://www.jaredlander.com/data/warTimes.rdata"))
theTimes <- str_split(string=warTimes, pattern="(ACAEA)|-", n=2)
which(str_detect(string= warTimes, pattern = "-"))
warTimes[which(str_detect(string= warTimes, pattern = "-"))]
###grab the first element of each list 
theStart <- sapply(theTimes, FUN=function(x) x[1])

###find anywar that started in january
str_extract(string=theStart, pattern="January")
theStart[str_detect(string=theStart, pattern="January")]

str_extract(string=theStart, pattern="[0-9]{4}")
str_extract(string=theStart, pattern="\\d{4}")
##only one two or three digits 
str_extract(string=theStart, pattern="[0-9]{1,3}")
###only the beginning of the text has four digits 
str_extract(string=theStart, pattern="^\\d{4}")
###only four digits of text, nothing else 
###carrot means (^) beginning of string, $ means end of string 
str_extract(string=theStart, pattern="^\\d{4}$")

str_extract(string=theStart, pattern="^\\d.*?{4}$")
##"~" is a negate sign

str_replace(string=theStart, pattern="\\d", replacement="x")
str_replace_all(string=theStart, pattern="\\d", replacement="x")
str_replace(string=theStart, pattern="\\d{4}", replacement="x")
###find any number of digits, 1 through 4, and replace it all with x
###replace finds ALL in one line, without all, you only get the first one replaced
str_replace_all(string=theStart, pattern="\\d{1,4}", replacement="x")

commands <- c("<a href=index.html>The link is here</a>",
              "<b>This is bold text</b>")
###in reg ex, period (.) means ANY character, + says search for multiple ones
##\\1 is a short cut menas whatever was found in the first set of (), if you had two
###and want to replace the second one, you do \\2
str_replace(string=commands, pattern="<.+?>(.+?)<.+?>", replacement="\\1")



