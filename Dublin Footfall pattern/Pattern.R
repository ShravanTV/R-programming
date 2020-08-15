library(readODS)
library(dplyr)
library(reshape2)
library(sqldf)
library(ggplot2)

South_William_street<-NULL
Capel_street<-NULL
Moore_St<-NULL
total_sheets<-get_num_sheet_in_ods("Footfall2013.ods")
total_sheets1<-get_num_sheet_in_ods("Footfall2012.ods")


#FUNCTION TO FETCH STREET DETAILS BASED ON SHEET NUMBER, STREET NAME AND FILE NAME AS INPUT
street<-function(sheet_no,street_name,file_name){  
  read_data<-read_ods(file_name,sheet = sheet_no,col_names = F)
  street_position<-grep(street_name, read_data[[1]])  
  data_range=c(street_position+3,street_position+26) 
  mutate(read_data[data_range[1]:data_range[2],2:15],week=sheet_no) 
}



#FUNCTION TO PLOT MULTIPLE PLOTS SIDE BY SIDE FOR EASY COMPARISION
multiplot <- function(..., plotlist = NULL, file, cols = 1, layout = NULL) {
  require(grid)
  plots <- c(list(...), plotlist)
  numPlots = length(plots)
  if (is.null(layout)) {
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
    if (numPlots == 1) {
    print(plots[[1]])
  
  } else {
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
      for (i in 1:numPlots) {
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}




#########  Part 1  ############

#FETCHES DATA RELATED TO CAPEL STREET FROM ALL THE SHEETS IN ODS FILE
for (i in 1:total_sheets) {
  Capel_street<-rbind(Capel_street,street(i,"Capel St","Footfall2013.ods"))
}
names(Capel_street)<-c("Mon_In","Mon_Out","Tue_In","Tue_Out","Wed_In","Wed_Out","Thu_In","Thu_Out","Fri_In","Fri_Out","Sat_In","Sat_Out","Sun_In","Sun_Out","Week")



#FETCHES DATA RELATED TO SOUTH WILLIAM STREET FROM ALL THE SHEETS IN THE ODS FILE
for (i in 1:total_sheets) {
  South_William_street<-rbind(South_William_street,street(i,"South William","Footfall2013.ods"))
}
names(South_William_street)<-c("Mon_In","Mon_Out","Tue_In","Tue_Out","Wed_In","Wed_Out","Thu_In","Thu_Out","Fri_In","Fri_Out","Sat_In","Sat_Out","Sun_In","Sun_Out","Week")


#CONVERSION OF CAPEL STREET COLUMNS TO DOUBLE
for(i in 1:15){
  Capel_street[[i]]<-as.double(Capel_street[[i]])
}


#FINDING NUMBER OF PERSONS ENTERING AND LEAVING CAMERA VIEW OVER WEEKS AT CAPEL STREET
Capel_Average_Week<-group_by(Capel_street,Week) %>%
  summarise_all(funs(sum))
Capel_averages <- melt(Capel_Average_Week, id.vars="Week")
Capel_Week_In<-sqldf("select * from Capel_averages where variable in ('Mon_In','Tue_In','Wed_In','Thu_In','Fri_In','Sat_In','Sun_In')")
Capel_Week_Out<-sqldf("select * from Capel_averages where variable in ('Mon_Out','Tue_Out','Wed_Out','Thu_Out','Fri_Out','Sat_Out','Sun_Out')")


#PLOT TO SHOW SUM OF PERSONS ENTERING IN CAMERA VIEW PLACED AT CAPEL STREET OVER WEEKS
Capel_Week_In_plot<-ggplot(Capel_Week_In, aes(Week,value,color=variable)) + 
  geom_point() +
  geom_line()+
  ggtitle("Weekly persons entering in camera view placed at Capel Street(North Dublin)")+
  xlab("Week")+ylab("Average number of persons")


#PLOT TO SHOW SUM OF PERSONS LEAVING FROM CAMERA VIEW PLACED AT CAPEL STREET
Capel_Week_Out_plot<-ggplot(Capel_Week_Out, aes(Week,value,color=variable)) + 
  geom_point() +
  geom_line()+
  ggtitle("Weekly persons leaving Out from camera view placed at Capel Street(North Dublin)")+
  xlab("Week")+ylab("Average number of persons")



#CONVERSION OF SOUTH WILLIAM STREET COLUMNS TO DOUBLE
for(i in 1:15){
  South_William_street[[i]]<-as.double(South_William_street[[i]])
}


#FINDING NUMBER OF PERSONS ENTERING AND LEAVING CAMERA VIEW OVER WEEKS AT SOUTH WILLIAM STREET
William_Average_Week<-group_by(South_William_street,Week) %>%
  summarise_all(funs(sum))
William_averages <- melt(William_Average_Week, id.vars="Week")
William_Week_In<-sqldf("select * from William_averages where variable in ('Mon_In','Tue_In','Wed_In','Thu_In','Fri_In','Sat_In','Sun_In')")
William_Week_Out<-sqldf("select * from William_averages where variable in ('Mon_Out','Tue_Out','Wed_Out','Thu_Out','Fri_Out','Sat_Out','Sun_Out')")


#PLOT TO SHOW SUM OF PERSONS ENTERING IN CAMERA VIEW PLACED AT SOUTH WILLIAM STREET OVER WEEKS
William_Week_In_plot<-ggplot(William_Week_In, aes(Week,value,color=variable)) + 
  geom_point() +
  geom_line()+
  ggtitle("Weekly persons entering in cameras placed at South William Street")+
  xlab("Week")+ylab("Average number of persons")


#PLOT TO SHOW SUM OF PERSONS LEAVING FROM CAMERA VIEW PLACED AT SOUTH WILLIAM STREET
William_Week_Out_plot<-ggplot(William_Week_Out, aes(Week,value,color=variable)) + 
  geom_point() +
  geom_line()+
  ggtitle("Weekly persons entering Out at cameras placed at South William Street")+
  xlab("Week")+ylab("Average number of persons")


#PLOTTING ALL THE PLOTS OBTAINED ABOVE FOR COMPARISION
multiplot(Capel_Week_In_plot,William_Week_In_plot,Capel_Week_Out_plot,
          William_Week_Out_plot,cols=2)




############### Part 2 ##################

url<-"https://data.smartdublin.ie/dataset/8204be0a-6348-459e-96e9-65bb75600ec3/resource/9e5e4e4f-3be9-45be-b837-9ca93076fbe6/download/pedestrianfootfall2012.ods"
download.file(url,destfile = "Footfall2012.ods", mode = "wb")

#Moore St
#FETCHES DATA RELATED TO MOORE STREET  FROM ALL THE SHEETS IN ODS FILE
for (i in 1:total_sheets1) {
  Moore_St<-rbind(Moore_St,street(i,"Moore St","Footfall2012.ods"))
}
names(Moore_St)<-c("Mon_In","Mon_Out","Tue_In","Tue_Out","Wed_In","Wed_Out","Thu_In","Thu_Out","Fri_In","Fri_Out","Sat_In","Sat_Out","Sun_In","Sun_Out","Week")

#CONVERSION OF MOORE STREET COLUMNS TO DOUBLE
for(i in 1:15){
  Moore_St[[i]]<-as.double(Moore_St[[i]])
}


#FINDING NUMBER OF PERSONS ENTERING AND LEAVING CAMERA VIEW OVER WEEKS AT MOORE STREET
Moore_Average_Week<-group_by(Moore_St,Week) %>%
  summarise_all(funs(sum))
Moore_averages <- melt(Moore_Average_Week, id.vars="Week")
Moore_Week_In<-sqldf("select * from Moore_averages where variable in ('Mon_In','Tue_In','Wed_In','Thu_In','Fri_In','Sat_In','Sun_In')")
Moore_Week_Out<-sqldf("select * from Moore_averages where variable in ('Mon_Out','Tue_Out','Wed_Out','Thu_Out','Fri_Out','Sat_Out','Sun_Out')")

#COMPARE THE DAYS OF WEEKS AT MOORE STREET
ggplot(Moore_Week_In, aes(Week,value,color=variable)) + 
  geom_point() +geom_line()+
  ggtitle("Comparing the persons entering Moore street on all days of week over a year")+
  xlab("Week")+ylab("Average number of persons")+
  facet_wrap(~variable)

