library(stringr)
library(tidytext)
library(readr)
library(dplyr)
library(ggplot2)


#READ THE HISTORY_DATABASE FILE 
history_file<- read_fwf("history_database",
                     fwf_positions(c(1,15),c(13,NA),c("timestamp","commands")))
#NUMBER OF LINES OF CODES USED FOR EACH QUESTION
Number_lines<-data.frame(question=c("Q1","Q2","Q3","Q4"),lines=0)


#CONVERT THE DATE AND TIME TO THE FORMAT OF DATE PRESENT IN HISTORY_DATABASE FILE
start_date<- (as.numeric(as.POSIXct("2019-11-28 19:00:00 CET"))*1000) %>% format(scientific=F)
end_date<- (as.numeric(as.POSIXct("2019-12-08 23:00:00 CET"))*1000) %>% format(scientific=F)

#SELECT THE COMMANDS EXECUTED IN ABOVE TIME PERIOD
history_data<- history_file$timestamp>start_date & history_file$timestamp<end_date
Commands_Entered <- history_file[history_data,]
View(Commands_Entered)


#COMMANDS USED FOR SOLVING RESPECTIVE QUESTIONS
Q1_commands<-rbind(Commands_Entered[510:830,],Commands_Entered[2681:3007,],
                   Commands_Entered[5515:5558,])
Q2_commands<-rbind(Commands_Entered[831:1694,],Commands_Entered[3008:3842,],
                   Commands_Entered[5559:5603,])
Q3_commands<-rbind(Commands_Entered[1698:1868,],Commands_Entered[3844:4028,],
                   Commands_Entered[2138:2678,],Commands_Entered[5258:5514,],
                   Commands_Entered[5604:5702,])
Q4_commands<-rbind(Commands_Entered[14:509,],Commands_Entered[4029:5170,],
                   Commands_Entered[5704:5883,])


#OUTPUT THE COMMANDS USED FOR EACH QUESTIONS TO RESPECTIVE FILES
writeLines(Q1_commands$commands,"Q1Commands.txt")
writeLines(Q2_commands$commands,"Q2Commands.txt")
writeLines(Q3_commands$commands,"Q3Commands.txt")
writeLines(Q4_commands$commands,"Q4Commands.txt")


#NUMBER OF COMMANDS USED TO SOLVE EACH QUESTION
Number_lines$lines[1]<-nrow(Q1_commands)
Number_lines$lines[2]<-nrow(Q2_commands)
Number_lines$lines[3]<-nrow(Q3_commands)
Number_lines$lines[4]<-nrow(Q4_commands)


#PLOT BAR GRAPH TO SHOW THE LINES OF COMMANDS USED FOR EACH QUESTION
ggplot(Number_lines,aes(question,lines,fill=question,width=0.5,label=lines))+
  geom_bar(stat='identity')+
  geom_text(hjust=0.5, vjust=-0.5)
