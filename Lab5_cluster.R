#Adjacent matricies: Linkage 
#directed graph: reletionship doesnt have to be reciprocal
#undirected graph: its like a twoway street, the relatinship has to be reciprocal
#what is igraph? we won't use it but look it up 

#"apply" "foreach" <- foreach is a forloop that runs in parallells
#1. build function that samples 3,000 random rows
#2. build funcitons that calculate average degree
#3. build function that calls functions 1 and 2
# call funcion 3, 10,000 times 

#Clustering, k-means clustering
# what does k-means do? it is the center of the cluster, the physical center
# when you do k means, you need to know how many centers you are looking for 

wine <- read.table("http://www.jaredlander.com/data/wine.csv", 
                   header=TRUE, sep=",", stringsAsFactors=FALSE)
require(useful)
corner(wine)

set.seed(278613)
#clusters is the number of centers
#iter.max = stop the process at some point. some data might not converge at all
#nstart = 5 means it will do 5 clusterings of this and give you an average 
winek3 <- kmeans(x=wine, centers=3)
winek3 <- kmeans(x=wine[subsetgoeshere], centers=3)
winek3$cluster
winek3$centers #gives you the coordinates of the physical centers of the clustered points. there are fourteen dimentions (14 variables). one row for each center. there are three centers, there will be three rows.
#k means only works for numeric data. k means doesnt work for string 
winek3$totss #total sum of squares
winek3$size
#how do i know how many clusters are right?
#hartigans rule, and gap statistics
#hartigans rule: measure of the between sum of squares and the within sum of squares 

wineBest <- FitKMeans(x=wine, max.clusters=20, seed=278613)
#the hartigan number is greater than 10, add the cluster, if it is not greater than 10, that's enough. 
winek3$tot.withinss
PlotHartigan(wineBest)
#interpreting the plot, hartigan's rule tells you what to use next. dont go below to red, so use 12 not 13. 
#what is the difference between using 11 and 12 then?

#gap statistic
require(cluster)
theGap <- clusGap(wine, K.max=20, FUNcluster=pam) #don't run this, it takes some time
# this measures how dissimilar the individuals are from the center 

#what is a boot strap
# you take an avearge of 1000 values, say. you randomly draw a 1000 points without replacements. 
# you have a whole new dataframe, that has repeats
# then you calculate the average again. get a different value
# then you repeat the process of sampling 1000 values, repeat the step 1200 times
# then you have 1200 averages that can give you an average  

#gap statistics is doing bootstrap on kmeans data 
#pick the point lowest on this graph

x <- c(1, 4, 5)
mean(x)
median(x)
#if you have categorical data, use kmedoids 
winePam <- pam(x=wine, k=5)
plot(winePam)
#if you have outlier in the data, kmedoids will behave better than kmeans. 

require(parallel)
require(doParallel)
cl <-makeCluster(2)
registerDoParallel(cl)

answer <- foreach(i=1:100, .combine='c') %dopar% #dopar makes it run in parallel
{
  i*2
}

stopCluster(cl)
#when you do 10000 reps, you do it in the foreach loop
