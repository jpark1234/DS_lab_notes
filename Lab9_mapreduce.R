#map reduce: split the data by keys, apply something, and recombine it according to the keys
fakeData <- c("Statistics is a small part of data science but data science is not necessarily part of statistics",
              "Data science uses statistics and data mining.",
              "Another word for data mining is machine learning or statistical learning.")

keyval <- function(key, value=NULL)
{
  if(missing(value))
  {
    list(key=NULL, value=key)
  }else
  {
    list(key=key, value=value)
  }
}

firstkv <- keyval(key=c(1,2,3), value=c("a","b","c"))
#this means 1 is matched to a, 2 is matched to b, 3 is matched to c
values <- function(kv)
{
  kv$value
}
keys <- function(kv)
{
  kv$key
}

values(firstkv)
keys(firstkv)

unlist(strsplit(x=fakeData, split=""))
theMapper <- function(key, value)
{
  theSplit <- unlist(strsplit(x=value, split=""))
  values <- rep(x=1, times=NROW(theSplit))
  keyval(key=theSplit,value=values)
}
firstMap <- theMapper(value=fakeData)
firstMap

theReducer <- function(key, value)
{
  keyval(key=key, value=sum(value))
}

theDF <- data.frame(key=keys(firstMap), value=values(firstMap))
aggregate(value~key, data=theDF, sum)

simpleFunc <- function(data, func)
{
  func(data)
}
simpleFunc(1:10,mean)

mapreduce <- function(data, map, reduce)
{
  mappedResults <- map(.,data)
  organizedResults <- tapply(x=values(mappedResults),
                             INDEX=keys(mappedResults),
                             FUN=function(x)x)
  theReduced <- mapply(reduce, key=names(organizedResults), value=organizedResults,
                       SIMPLIFY=FALSE, USE.NAMES=FALSE)
  
  keyval(key=sapply(theReduced, keys), values=sapply(theReduced, values)
}

trial <- mapreduce(data=fakeData, map=theMapper, reduce=theReducer)
lapply(trial,values)
sapply(trial,values)
sapply(trial,keys)

rmr2::mapreduce(data=fakeData, map=theMapper, reduce=theReducer)





theDF <- data.frame(A=1:20)
theDF$Counter <-1
sum(theDF$Counter)
