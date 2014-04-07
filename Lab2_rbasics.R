theMatrix <- matrix(1:9, nrow=3)
theMatrix
apply(theMatrix, 2, sum)
#matrix all has to be the same type, data frame can be different things. 
#2 will do a columwise operation, 1 will do a row operation. 

#see the difference
mat2 <- matrix(c(1,4,2,5), nrow=2) 
mat3 <- matrix(c(1,4,2,5), nrow=2, byrow=TRUE) 

#pressing TAB shows the available arguemtns 

apply(theMatrix, 1, sum)
colSums(theMatrix)
rowSums(theMatrix)

theMatrix[2,1] 
theMatrix[2,1] <- NA
apply(theMatrix, 1, sum)
apply(theMatrix, 1, sum, na.rm=TRUE)

rowSums(theMatrix)
rowSums(theMatrix, na.rm=TRUE)

theList <- list(A=matrix(1:9, 3), B=1:5, C=matrix(1:4,2),D=2)

#forloops are evil 
#lapply is apply for lists
lapply(theList, sum)
#lapply takes a list and returns a list. wouldn't you like to see this in a pretty vector?
#s in sapply is simple apply
sapply(theList, sum)

theDF <- data.frame(A=1:10, B=10:1)
lapply(theDF, sum)
#data frames are a highly inefficient version of a list 

firstList <- list(A=matrix(1:16, 4), B=matrix(1:16, 2), C=1:5)
secondList <- list(A=matrix(1:16,4), B=matrix(1:16, 8), C=15:1) 

mapply(identical, firstList, secondList)
#results say A is identical, B and C are not the same matricies 

theNames <- c("George", "John", "Thomas")
nchar(theNames)
sapply(theNames, nchar)
lapply(theNames, nchar)

#what if you want to build your own function?
#functions might as well be variables in R
#assign a function to a variable
#everything inside a function should be inside braces { }
nrow(theMatrix)
#you cant pass this on non numbers
nrow(theNames)
#so try
#lower case nrow ncol only works with things with dimension. capital works for vectors and lists without dimentionality
NROW(theNames)

simpleFunc <- function(x, y)
{
    NROW(x) + NROW(y) 
}
simpleFunc
mapply(simpleFunc, firstList, secondList)
#if you want to return multiple things, pack it in the list and return a list 

#how to load a package in R
library(ggplot2)
require(ggplot2)
data(diamonds)
head(diamonds)

#tilda separates the left and the right of the function
aggregate(price ~ cut, diamonds, mean)
aggregate(price ~ cut + color, diamonds, mean)
#use cbind to combine left hand side vectors 
aggregate(cbind(price, carat) ~ cut, diamonds, mean)
aggregate(cbind(price, carat) ~ cut + color, diamonds, mean)

require(plyr)
head(baseball)
#when you load plyr, baseball automatically gets loaded. but for ggplot2, you have to call in diamonds dataset
#tweet: gselevator? 
?baseball

baseball$sf[baseball$year < 1954] <- 0
baseball <- baseball[baseball$ab >= 50,]
baseball$hbp[is.na(baseball$hbp)] <- 0

#using "with" saves a lot of function 
obp <- function(data)
{ 
  with(data, sum(h + bb+ hbp)/sum(ab + bb + hbp + sf))
}

head(obp(baseball))
#ddply: dataframe apply version for plyr
careerOBP <- ddply(baseball, .variables="id", obp)
head(careerOBP)
obpSorted <- careerOBP[order(careerOBP$V1, decreasing=TRUE),]
head(obpSorted)

baseball <- join(baseball, careerOBP, by="id")

llply(theList, sum)
#llply acts like lapply
lapply(theList, sum)
#lapply looks like sapply
sapply(theList, sum)

require(reshape2)
head(airquality)

airMelt <- melt(airquality, id=c("Month", "Day"), value.name="value", variable.name="Metric")
head(airMelt)
tail(airMelt)

airCast <- dcast(airMelt, Month + Day ~ Metric, value.var="value")
head(airCast)

#"solve" - gets you an inverse 
solve(theMatrix)

#"sprintf()"
