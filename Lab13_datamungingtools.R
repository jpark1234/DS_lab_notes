#data munging tools in R
#play around with a matrix 
theMat <- matrix(1:9, nrow=3)
apply(theMat,1, sum)
apply(theMat,2, sum)
colSums(theMat)
rowSums(theMat)

theMat[2,1] <- NA

apply(theMat, 1, sum)
apply(theMat, 1, sum, na.rm=TRUE)
#see what apply family functions can do?

#lets try a list 
theList <- list(A=matrix(1:9,3), B=1:5, c=matrix(1:4,2), D=2)
lapply(theList,sum)
sapply(theList,sum)
sapply

#ddply, aggregate all things ar better than tapply

#parallel processing in R
install.packages("doParallel")
require(doParallel)

cl <- makeCluster(4)
registerDoParallel(cl)

#bryan lewis is a cool guy 

parLapply(cl=cl, theList,sum)
stopCluster(cl)
#parallel processing is something you really need to know what youre doing 
#it can speed up things but also mess up things so beware 

firstList <- list(A=matrix(1:16,4), B=matrix(1:16,2), c=1:5)
secondList <- list(A=matrix(1:16,4), B=matrix(1:16,8), c=15:1)
mapply(identical, firstList, secondList)

#you pass as many arguemts as you want, compare a bunch of lists
simplefucn <- function(x, y)
{
  NROW(x) + NROW(y)
}
mapply(simplefucn, firstList, secondList)

#mapply is very powerful because you can pass multiple arguments into an apply function! 
#how great is that?

require(ggplot2)
data(diamonds)
head(diamonds)

aggregate(price ~ cut, diamonds, mean)
aggregate(price ~ cut + color, diamonds, mean)
aggregate(cbind(price, carat) ~ cut, diamonds, mean)

require(plyr)
head(baseball)
baseball$sf[baseball$year < 1954] <- 0
baseball$hbp[is.na(baseball$hbp)] <- 0
baseball <- baseball[baseball$ab >= 50,]
baseball$OBP <- with(baseball, (h + bb + hbp)/ (ab + bb +hbp + sf))
head(baseball)

obp <- function(data)
{
  c(OBP=with(data, sum(h + bb+ hbp)/ sum(ab+ bb + hbp + sf)))
}

#in plyr package,
#the first letter tells you in put, second letter tells you output. ddply is data frame in, data frame out 
careerOBP <- ddply(baseball, "id", obp)
head(careerOBP)

careerOBP <- careerOBP[order(careerOBP$OBP, decreasing=TRUE),]
head(careerOBP, 10)
#llply goes from a list to a list

aggregate(price ~ cut, diamonds, each(mean,median))
codes <- read.table("http://www.jaredlander.com/data/countryCodes.csv",
                    header=TRUE, sep=",", stringsAsFactors=FALSE)
countries <- read.table("http://www.jaredlander.com/data/GovType.csv",
                    header=TRUE, sep=",", stringsAsFactors=FALSE)

codes <- rename(codes, c(Country.name="Country"))
#this is better than colnames! 

countryJoined <- join(x=codes, y=countries, by="Country")
head(countryJoined)
#join is more efficient, merge doesnt work as well 

require(reshape2)
head(airquality)
#make wide list to long
airMelt <- melt(airquality, id=c("Month", "Day"), value.name="Value", variable.name="Metric")
#dcats puts it in dataframe, acast does it in array, 
airCast <- dcast(airMelt, Month + Day ~ Metric, value.var="Value")
head(airCast)
