#step:1 Framing the question
#What are the best movies in Hollywood
#Step:2 Data Collection
#Check whether you can scrap
library(robotstxt)
Path<-paths_allowed("https://en.wikipedia.org/wiki/List_of_countries_and_dependencies_by_population")
library(rvest)
url<-"https://en.wikipedia.org/wiki/List_of_countries_and_dependencies_by_population"
my_html<-read_html("https://en.wikipedia.org/wiki/List_of_countries_and_dependencies_by_population")
my_table<-html_nodes(my_html,"table")
population_wiki = html_table(my_table)[[1]]
population=population_wiki[,1:4]
View(population)
names(population)<-c("Rank","Country","Population","World","Share")
View(population)
write.csv(population,"My_population_s")

#Data Cleaning
population$Population <-gsub(",","",population$Population)
population$`% of world` <-gsub("%","",population$`% of world`)
population$Population <-as.numeric(population$Population)
population$`% of world` <-as.numeric(population$`% of world`)
View(population)

#Check for missing values
population$`% of world`=ifelse(is.na(population$`% of world`),
                                      ave(population$`% of world`,FUN=function(x) mean(x,na.rm=TRUE)),
                               population$`% of world`)
View(population)

#Dealing with categorical data
population$'Highly populated' <-population$`% of world`>5
View(population)
population$`Highly populated`<-as.factor(population$`Highly populated`)
population$`Highly populated`<-factor(population$`Highly populated`,
                              levels = c("FALSE","TRUE"),
                              labels = c(0,1))
View(population)
write.csv(population,"Cleaned data")
