load(url("http://www.jaredlander.com/data/credit.rdata"))
head(credit)
#non linear models
#trees 
require(rpart)
CreditTree <- rpart(Credit ~ CreditHistory + CreditAmount + Age + Employment, data= credit)
require(rpart.plot)
rpart.plot(CreditTree, extra=4)
# yes answers to go the left, no answer goes to the right 
# response variable is categorical 

#random forest = a whole bunch of trees, randomly picking which columns to use as predictors. 
#so the number of trees varies as well, some might have three predictors, some might have four, etc 
require(randomForest)
creditFormula <- Credit ~ CreditHistory + Purpose + Employment + Duration + Age + CreditAmount
creditFormula
require(devtools)
install_github("useful", "jaredlander")
require(useful)
creditX <- build.x(creditFormula, data=credit)
creditY <- build.y(creditFormula, data=credit)
creditForest <- randomForest(x=creditX, y=creditY)
creditForest

#elastic net 
#dimensionality : is when there are more predictors than observations, more columbns than rows 
acs <- read.table("http://www.jaredlander.com/data/acs_ny.csv", header=TRUE, sep=",", stringsAsFactor=FALSE)
#american community service is a great great great data about demographics
acs$Income <- acs$FamilyIncome >= 150000
acsFormula <- Income ~ NumBedrooms + NumChildren + NumPeople + NumRooms + NumUnits + NumVehicles + NumWorkers +
  OwnRent + YearBuilt + ElectricBill + FoodStamp + HeatingFuel + Insurance + Language -1
#this model automatically adds a column of 1s of intercepts 
acsX <- build.x(acsFormula, data=acs, contrasts=FALSE)
unique(credit$CreditHistory)
head(build.x(Credit ~ CreditHistory, data=credit))
acsY <- build.y(acsFormula, data=acs)
require(glmnet)
acs1 <- cv.glmnet(x=acsX, y=acsY, family="binomial", nfolds=5)
plot(acs1)
plot(acs1$glmnet.fit)
require(view)
view(as.matrix(coef(acs1$glmnet,fit)))
coef(acs1, s="lambda.min")
coef(acs1, s="lambda.1se")