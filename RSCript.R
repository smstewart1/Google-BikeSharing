#install relevant libraries
library(tidyverse)
library(lubridate)
library(ggplot2)

#read in the datasets
Q1 <- read_csv("Divvy_Trips_2020_Q1.csv")
Q2 <- read_csv("Divvy_Trips_2019_Q2.csv")
Q3 <- read_csv("Divvy_Trips_2019_Q3.csv")
Q4 <- read_csv("Divvy_Trips_2019_Q4.csv")

#check files
head(Q1)
head(Q2)
head(Q3)
head(Q4)

#standardizes formats
Q4 <- rename(Q4
     ,ride_id = trip_id
     ,rideable_type = bikeid 
     ,started_at = start_time  
     ,ended_at = end_time  
     ,start_station_name = from_station_name 
     ,start_station_id = from_station_id 
     ,end_station_name = to_station_name 
     ,end_station_id = to_station_id 
     ,member_casual = usertype)

Q3 <- rename(Q3
     ,ride_id = trip_id
     ,rideable_type = bikeid 
     ,started_at = start_time  
     ,ended_at = end_time  
     ,start_station_name = from_station_name 
     ,start_station_id = from_station_id 
     ,end_station_name = to_station_name 
     ,end_station_id = to_station_id 
     ,member_casual = usertype)

Q2 <- rename(Q2
       ,ride_id = "01 - Rental Details Rental ID"
       ,tripduration = '01 - Rental Details Duration In Seconds Uncapped'
       ,rideable_type = "01 - Rental Details Bike ID" 
       ,started_at = "01 - Rental Details Local Start Time"  
       ,ended_at = "01 - Rental Details Local End Time"  
       ,start_station_name = "03 - Rental Start Station Name" 
       ,start_station_id = "03 - Rental Start Station ID"
       ,end_station_name = "02 - Rental End Station Name" 
       ,end_station_id = "02 - Rental End Station ID"
       ,birthyear = '05 - Member Details Member Birthday Year'
       ,member_casual = "User Type"
       ,gender = "Member Gender")

#calculates trip time in Q1 dataset and reformats
Q1 <- Q1 %>% mutate(tripduration = ended_at - started_at)
Q1$tripduration <- Q1$tripduration %>% as.integer()

#creates longitude latitude library
rosettastone <- Q1[ ,c("start_station_id", "start_lat", "start_lng")]
rosettastone <- rosettastone[!duplicated(rosettastone),]

Q1 <- Q1[, !names(Q1) %in%  c("start_lat", "start_lng", "end_lat", "end_lng")]

#cleans up data types
Q4 <-  mutate(Q4, ride_id = as.character(ride_id)
                   ,rideable_type = as.character(rideable_type)) 
Q3 <-  mutate(Q3, ride_id = as.character(ride_id)
                   ,rideable_type = as.character(rideable_type)) 
Q2 <-  mutate(Q2, ride_id = as.character(ride_id)
                   ,rideable_type = as.character(rideable_type)) 


#merges the data
composite <- bind_rows(Q2, Q3, Q4, Q1)

#drops old dataframes to free up memory
rm(Q1, Q2, Q3, Q4)
rm(cnames, Q2names)

#standardizes naming 
composite <-  composite %>%  mutate(member_casual = recode(member_casual, "Subscriber" = "member", "Customer" = "casual"))

#creates month and day columns
composite$date <- as.Date(composite$started_at)
composite$month <- format(as.Date(composite$date), "%m")
composite$day <- format(as.Date(composite$date), "%d")
composite$year <- format(as.Date(composite$date), "%Y")
composite$day_of_week <- format(as.Date(composite$date), "%A")

#remove bikes taken out for service
composite_v2 <- composite[!(composite$start_station_name == "HQ QR" | composite$tripduration < 0),]

#descriptive statistics
mean(composite_v2$tripduration) #straight average (total ride length / rides)
median(composite_v2$tripduration) #midpoint number in the ascending array of ride lengths
max(composite_v2$tripduration) #longest ride
min(composite_v2$tripduration) #shortest ride

write.csv(composite_v2, file = "Composite.csv", row.names = FALSE)
write.csv(rosettastone, file = "rosetta.csv", row.names = FALSE)

#generate data sets for plots
members <- composite_v2[composite_v2$member_casual == "member",]
casuals <- composite_v2[composite_v2$member_casual == "casual",]
dailym <- members %>% group_by(day_of_week) %>% summarise(avg_time = mean(tripduration))
dailyc <- casuals %>% group_by(day_of_week) %>% summarise(avg_time = mean(tripduration))
monthlym <- members %>% group_by(month) %>% summarise(avg_time = mean(tripduration))
monthlyc <- casuals %>% group_by(month) %>% summarise(avg_time = mean(tripduration))
