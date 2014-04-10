load(url("http://www.jaredlander.com/data/credit.rdata"))
head(credit)
require(ggplot2)
ggplot(credit, aes(x=CreditAmount, y=Credit)) + geom_jitter(position=position_jitter(height=0.2))  + facet_grid(CreditHistory ~ Employment)

require(rpart)
#rpart takes a model like a linear model but builds a tree. Tree is basically a hyperlocalized regression
creditTree <- rpart(Credit ~ CreditAmount + Age + CreditHistory + Employment, data=credit)
creditTree

require(rpart.plot)
rpart.plot(creditTree, extra=4)
#extra is just a polotting function argument, different numbers will make different plots 
#algorithm asks a bunch of questions and based on that decides a value 
#first question, what type of credit is it CrA, LtP or UTD. if its not one of these three
#they know you have a 60% chance of bad credit.
# if yes, are you borrowing less than 7760 dollars? 
# if yes, 75% of of good (right value is Good, left value is Bad) 25% of having bad credit 

#at one point you have to prune the tree to stop asking questions becaues the bucket is too small
#randomforest - one tree can be wrong, lets fit a lot more tree with different subset of variables and see what the average value is 
#trees grow out of bagging 

require(randomForest)
require(useful)
creditX <- build.x(Credit ~ CreditAmount + Age + CreditHistory + Employment, data=credit)
creditY <- build.y(Credit ~ CreditAmount + Age + CreditHistory + Employment, data=credit)

#x matrix of all the predictors and y matrix of predictor  values (good vs bad) and does matrix multiplication on it
head(creditX) #this is crazy
head(creditY) #this is good vs bad

creditForest <- randomForest(x=creditX, y=creditY)
creditForest

#bagging is all the same models , ensamble model is bringing together a bunch of week models together 
#boosting is changing the weights for the rows where good rows get more weight and bad rows get less
#jackknife : its a lot like leave one out cross validation, but you take one row out 

load(url("http://www.jaredlander.com/data/wifi.rdata"))
head(wifi)

ggplot(wifi, aes(x=x, y=y, color=Distance)) + geom_point() + scale_color_gradient2(low="blue", ="white", high="red", midpoint=mean(wifi$Distance))
#this is non linear least squares
wifiMod1 <- nls(Distance ~ sqrt((betaX - x)^2 + (betaY - y)^2),
                data=wifi, start=list(betaX=50, betaY=50)) #start is to optimze the function 
wifiMod1
coef(wifiMod1)

ggplot(wifi, aes(x=x, y=y, color=Distance)) + 
  geom_point() + scale_color_gradient2(low="blue", mid="white", high="red", midpoint=mean(wifi$Distance)) + 
  geom_point(data=as.data.frame(t(coef(wifiMod1))), aes(x=betaX, y=betaY),
             size=5, color="green")

#spline smoothes curvesmid
#give it x, givt it y, run a regression but is a curvey regression with a smotth line

require(ggplot2)

install.packages("plyr")
require(plyr)
data(diamonds)

data(diamonds, package="ggplot2")
diaSpline1 <- smooth.spline(x=diamonds$carat, y=diamonds$price)
diaSpline2 <- smooth.spline(x=diamonds$carat, y=diamonds$price, df=2)
diaSpline3 <- smooth.spline(x=diamonds$carat, y=diamonds$price, df=10)
diaSpline4 <- smooth.spline(x=diamonds$carat, y=diamonds$price, df=20)
diaSpline5 <- smooth.spline(x=diamonds$carat, y=diamonds$price, df=50)
diaSpline6 <- smooth.spline(x=diamonds$carat, y=diamonds$price, df=100)
#more degrees of freedom wigglier

get.spline.info <- function(object)
{
  data.frame(x=objects$x, y=object$y, df=object$df)
}

splineDF <- ldply(list(diaSpline1, diaSpline2, diaSpline3, diaSpline4, diaSpline5, diaSpline6,
                       get.spline.info))

g <- ggplot(diamonds, aes(x=carat, y=price))+ geom_point()
#spline uses localized regression to put a curve through to better fit. but to not offerfit, you need 
#degrees of freedom, the more DF the more overfitting  

splineDF$df <- round(splineDF$df, 0)

g + geom_line(data=splineDF, aes(x=x, y=y, color=factor(df), group(df)))

require(splines)
head(diamonds$carat)
#ns is natrual spline 
head(ns(diamonds$carat, df=1)) 
head(ns(diamonds$carat, df=2))
head(ns(diamonds$carat, df=3)) 
head(ns(diamonds$carat, df=4))
head(ns(diamonds$carat, df=5)) 

g + stat_smooth(methods="lm", formula= y ~ ns(x, 6), color="blue") + 
  stat_smooth(method="lm", formual=y~ ns(x, 3), color="red")
