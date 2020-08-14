library(dplyr)
library(sqldf)

unzip("DublinBusGTFS.zip",overwrite = T)
list.files(path = ".")

#FETCH RESPECTIVE DATA FROM THE FILES INTO VARIABLES
agency<-read.table("agency.txt",header = T,sep = ',',fileEncoding="UTF-8-BOM")
calendar<-read.table("calendar.txt",header = T,sep = ',',fileEncoding="UTF-8-BOM")
calendar_dates<-read.table("calendar_dates.txt",header = T,sep = ',',fileEncoding="UTF-8-BOM")
routes<-read.table("routes.txt",header = T,sep = ',',fileEncoding="UTF-8-BOM")
shapes<-read.table("shapes.txt",header = T,sep = ',',fileEncoding="UTF-8-BOM")
stop_times<-read.table("stop_times.txt",header = T,sep = ',',fileEncoding="UTF-8-BOM")
stops<-read.table("stops.txt",header = T,sep = ',',fileEncoding="UTF-8-BOM")
transfers<-read.table("transfers.txt",header = T,sep = ',',fileEncoding="UTF-8-BOM")
trips<-read.table("trips.txt",header = T,sep = ',',fileEncoding="UTF-8-BOM")


########## Q3.1  ########

#JOIN VARIABLES TO FETCH ROUTE,TRIP,STOP DETAILS IN ONE DATAFRAME
Dublin_Bus_Data <- routes %>% 
  left_join(trips) %>%  
  left_join(stop_times) %>% 
  left_join(stops)%>% 
  select(route_id, route_short_name , route_long_name, route_type, 
         service_id, trip_id, stop_id, stop_name, arrival_time, departure_time, 
         stop_sequence, direction_id)


#FIND NUMBER OF TRIPS IN EACH ROUTE
Num_trips_route<- Dublin_Bus_Data %>% 
  group_by( route_short_name,route_long_name, trip_id) %>% 
  summarise() %>% 
  summarise(count = n())


#PLOT GRAPH TO SHOW NUMBER OF TRIPS IN EACH ROUTE
qplot(data = Num_trips_route,x=route_short_name,y=count,fill=route_short_name)+
  geom_bar(stat = "identity") +
  geom_text(aes(label=count),hjust=-0.7)+
  labs(title = "Number of trips for each route",
       x="Route",
       y="Number of trips") +
  coord_flip()


#######  Q3.2

#Forward direction of Bus 15B
forward_direction <- filter(Dublin_Bus_Data, route_short_name == "15B" & direction_id == 0)
#Reverse direction of 15B
reverse_direction <- filter(Dublin_Bus_Data, route_short_name == "15B" & direction_id == 1)


#Forward and Reverse direction from Home
Home_forward_direction<-sqldf("select * from Dublin_Bus_Data where 
                              stop_name=='Stocking Lane' and direction_id == 0 
                              order by arrival_time asc")
Home_reverse_direction<-sqldf("select * from Dublin_Bus_Data where 
                              stop_name=='Stocking Lane' and direction_id == 1 
                              order by arrival_time asc")


unique(reverse_direction$stop_name)

#Forward and Reverse direction from work
work_forward_direction<-sqldf("select * from Dublin_Bus_Data where 
                              stop_name == 'Benson Street' and direction_id == 0 
                              and route_short_name == '15B' order by arrival_time asc")
work_reverse_direction<-sqldf("select * from Dublin_Bus_Data where 
                              stop_name == 'Benson Street' and direction_id == 1 
                              and route_short_name == '15B' order by arrival_time asc")




#From Stocking Lane(Home) towards Benson Street(Work)
ggplot(Home_reverse_direction[1:50,],aes(x=stop_sequence,y=arrival_time,col=stop_id)) +
  geom_point() + geom_line() +
  labs(title = "Buses from Stocking Lane(Home) towards Benson Street(Work)",
       x = "stop number",
       y = "Timing")


#From Benson Street(Work) towards Stocking Lane(Home)
ggplot(work_forward_direction[70:121,],aes(x=stop_sequence,y=arrival_time,col=stop_id)) +
  geom_point() + geom_line() +
  labs(title = "Buses from Benson Street(Work) towards Stocking Lane(Home)",
       x = "stop number",
       y = "Timing")


