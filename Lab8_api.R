apropos("mea")

#API: your command talks to their computer and gives you back data. 
#there are many APIs 

#http://developer.nytimes.com/docs/read/article_search_api_v2
baseURL <-
  http://api.nytimes.com/svc/search/v2/articlesearch.json?api-key=1D6AB47D959E8B266850AC01D1F38EDE:9:68403017&fq=news_desk:("Sports")&fl=web_url,news_desk,lead_paragraph,word_count,headline&begin_date=20130601&end_date=20131112

require(rjson)
theQuery <-"http://api.nytimes.com/svc/search/v2/articlesearch.json?api-key=1D6AB47D959E8B266850AC01D1F38EDE:9:68403017&fq=news_desk:(\"Sports\")&fl=web_url,news_desk,lead_paragraph,word_count,headline&begin_date=20130601&end_date=20131112"
theQuery
theResults <- fromJSON(file=theQuery)
View(theResults)
str(theResults)
str(theResults$response$docs)
theResults$response$docs[1]

require(plyr)
resultsDF <- ldply(theResults$response$docs, as.data.frame)
View(resultsDF)

"http://api.nytimes.com/svc/search/v2/articlesearch.json?api-key=1D6AB47D959E8B266850AC01D1F38EDE:9:68403017&fq=news_desk:("Sports")&fl=web_url,news_desk,lead_paragraph,word_count,headline&begin_date=20130601&end_date=20131112&page=1"

resultsSports <- vector("list", 3)
resultsSports
baseQuery <- "http://api.nytimes.com/svc/search/v2/articlesearch.json?api-key=1D6AB47D959E8B266850AC01D1F38EDE:9:68403017&fq=news_desk:(\"Sports\")&fl=web_url,news_desk,lead_paragraph,word_count,headline&begin_date=20130601&end_date=20131112&page=%s"
for(i in 0:2)
{
  tempURL <- sprintf(baseQuery, i)
  tempResult <- fromJSON(file=tempURL)
  resultsSports[[i+1]] <- ldply(tempResult$response$docs, as.data.frame)
}

theResults$response$docs[[1]]
str(resultsSports)
resultsSportsAll <- ldply(resultsSports)
class(resultsSports)

theString <- "hello %s, what are you doing for %s?"
sprintf(theString, "Bob", "dinner")

get.api <- function(section, lastPage=0)
{
  results <- vector("list", lastPage+1)
  baseQuery <- "http://api.nytimes.com/svc/search/v2/articlesearch.json?api-key=1D6AB47D959E8B266850AC01D1F38EDE:9:68403017&fq=news_desk:(\"%s\")&fl=web_url,news_desk,lead_paragraph,word_count,headline&begin_date=20130601&end_date=20131112&page=%s"
 for(i in 0:lastPage)
 {
   tempURL <- sprintf(baseQuery, section, i)
   tempResult <- fromJSON(file=tempURL)
   results[[i+1]] <- ldply(tempResult$response$docs, as.data.frame)
 }
  return(ldply(results))
}

resultsArt <- get.api(section="Arts", lastPage=0)
dim(resultsArt)
resultsSports <- get.api(section="Sports", lastPage=0)
resultsAll <- rbind(resultsSports, resultsArt)
dim(resultsAll)

require(RTextTools)
doc_matrix <- create_matrix(resultsAll$body, language="english", 
                           removeNumbers=TRUE, removeStopwords=TRUE,
                           stemWords=TRUE)
#this creates a bag of words, all the words in the lead paragraph
require(useful)
View(topright(as.matrix(doc_matrix)))

textX <- as.matrix(doc_matrix)
nb1 <- naiveBayes(x=textX, y=resultsAll$nytd_section_facet)
head(nb1$tables)
?e1071:::predict.naiveBayes

#try these for map reduce 
require(Reduce)
require(ddply)
