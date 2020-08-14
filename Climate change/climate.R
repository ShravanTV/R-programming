library(dplyr)
library(ggplot2)


weather_data<-read.csv('testset.csv',sep=',',stringsAsFactors=F)

#MUTATING A COLUMN YEAR FOR FURTHER ANALYSIS OF DATA
weather_data_year<-mutate(weather_data,year=substring(weather_data$datetime_utc,1,4))


#CONVERTING THE REQUIRED COLUMNS TO NUMERIC
weather_data_year$year<-as.numeric(weather_data_year$year)
weather_data_year$X_hum<-as.numeric(weather_data_year$X_hum)
str(weather_data_year)


#OBTAIN AVERAGE OF HUMIDITY, RAIN, TEMPERATURE OVERS YEARS
data_year<-weather_data_year %>% 
  group_by(year) %>% 
  summarize(average_humidity=mean(X_hum,na.rm = T),
            average_rain=mean(X_rain,na.rm = T),
            average_temp=mean(X_tempm,na.rm = T))



#RESPECTIVE QPLOT TO DISPLAY THE CHANGES OVER YEARS
humidity<-qplot(data = data_year,x=year,y=average_humidity,
                geom =c( "line","point","smooth"),main = "Humidity over years") 
rain<-qplot(data = data_year,x=year,y=average_rain,
            geom = c( "line","point","smooth"),main = "Rain over years")
temperature<-qplot(data = data_year,x=year,y=average_temp,
                   geom = c( "line","point","smooth"),main = "Temperature over years")



#FUNCTION TO DISPLAY THE ABOVE PLOTS SIDE BY SIDE
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



#PLOT TO DISPLAY TEMPERATURE,HUMIDITY,RAIN OVER YEARS
multiplot(temperature,humidity,rain,cols=3)
