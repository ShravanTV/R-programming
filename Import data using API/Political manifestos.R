library(httr)
library(data.table)
library(ggplot2)
library(dplyr)

url<- 'https://manifesto-project.wzb.eu/tools/api_get_core.json?key=MPDS2019a&api_key='
key=''  #Insert a key obtained after registering for the API

#OBTAINING DATA FROM URL USING KEY
response<-GET(paste0(url,key))
results<- content(response)


#CONVERT LIST OBTAINED TO A DATA TABLE
bind_results<-do.call(rbind, results) %>% as.data.table
bind_results<-bind_results[,1:24]
names(bind_results)<-unlist(bind_results[1,])
bind_results<-bind_results[-1,]

#CONVERT REQUIRED COLUMNS TO CHARACTERS
bind_results$partyname<-as.character(bind_results$partyname)
bind_results$countryname<-as.character(bind_results$countryname)
names(bind_results)


#FILTER DATA RELATED TO IRELAND AND NORTHERN IRELAND
Ireland<-bind_results %>%
  filter(countryname == "Ireland"|countryname=="Northern Ireland") %>%
  count(partyname,countryname)
  

#PLOT TO DISPLAY NUMBER OF POLITICAL MANIFESTOS PUBLISHED IN IRELAND AND NORTHERN IRELAND BY RESPECTIVE POLITICAL PARTIES
qplot(data=Ireland,x=partyname,y=n,fill=countryname) +
    geom_bar(stat = "identity") + 
    geom_text(aes(label=n),hjust=-0.7)+
    labs(title = "Political manifestos published in Ireland and Northern Ireland",
         x = NULL,
         y = "Total (1948-present)")+
    coord_flip()


