This task has 2 parts of which part1 is to use the data provided in Footfall2013.ods file and observe the footfall patterns of a street in north and in south dublin and the part2 is to scrap the data from respective website and plot a comparative plot. For this part a file Footfall2012.ods has been scraped through the website smartdublin.
In order to fetch data from the above files, a function street () has been created. (line 14 to 19 in file Q4.R). This function accepts sheet number, street name and file name as inputs and processes it by reading the data using read_ods () function, and with the street name as input it searches the position of the street in column 1 and stores it in a variable street_position. Using the position of the street respective required columns will be fetched and a column with week number is appended to the columns.
Also, a function multiplot () was created to display the plotted graphs side by side, so that it will be easy for comparison of graphs.

<b>Part 1:

Capel Street from Dublin North and South William Street from South Dublin were selected for this task. In order to fetch the footfall details of these streets, I used the street () function which was manually created. A for loop was created to fetch these details from the file, and the street () function is introduced inside this for loop along with street name and file name. The details fetched for respective streets are stored in variables Capel_street and South_William_street and respective column names have been updated accordingly.
Using the above fetched data, number of persons entering and leaving the respective camera is fetched for all the days and for 52 weeks and stored in variables Capel_averages and William_averages. The data of persons entering and leaving was filtered separately and stored in separate variables for each street.
A Line graph using ggplot with week number, value (sum of persons) is plotted for both the streets and for both IN and OUT data of dataset.

• From the plotted graph we can see that the persons entering the camera frame on Saturdays is higher for both North Dublin (Capel St) and South Dublin (South William Street) and also leaving the frame is higher on Saturdays for both North and South Dublin.

• Persons entering to Capel Street on Sundays is low for the whole 52 weeks whereas persons entering to William street on Sundays were low till week 20 and later it slightly got increased.

Output graph:

![image](https://user-images.githubusercontent.com/25825690/90322134-4e266580-df48-11ea-9126-b5ad1a8495c2.png)



<b>PART 2 <br>
<br>
For this part of the task a file was scraped from the website smartdublin. And for downloading this file mode attribute is set to “wb” inside download.file () function as R doesn’t introduce this by default. Data of the year 2012 was downloaded successfully.
Camera placed at Moore Street of Dublin was selected for this task. For loop was used to fetch the data from the downloaded file. Inside the for loop the function street() was used by providing the inputs of street name(Moore) and file name as Footfall2012.ods. And the respective data fetched was stored in the variable Moore_St
Data fetched in above step is used to calculate the number of persons entering and leaving the camera view on all days and for all weeks placed at Moore street, this is achieved by grouping the column Week and summarizing with sum.
Number of persons entering and leaving were filtered out and stored separately in the variables Moore_Week_In and Moore_Week_Out
And a graph using ggplot was plotted using the data Moore_Week_In and by passing Week to X axis and value (sum of persons entering the camera view) as Y axis and facet_wrap was used to compare the data for each day of the week. (Fig 3)
<br>• By observing the graph plotted we can see that around 15000 people per week enter Moore street from Monday to Saturday, whereas on Sunday around 10000 peoples per week enters Moore street.
<br>• Also, we can observe that there is a sudden increase in the persons entering the Moore street on all days in the weeks 49,50,51.
<br>• Also, a sudden decrease of persons visiting around week 19 is seen on all the days.

Output graph:
![image](https://user-images.githubusercontent.com/25825690/90322141-5ed6db80-df48-11ea-9f32-eaa4c05d60d5.png)
