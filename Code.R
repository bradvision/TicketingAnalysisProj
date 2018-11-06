#The following data is from the Data.gov the tdf is the Traffic Tick Issued within a four year window
#https://catalog.data.gov/dataset/traffic-tickets-issued-beginning-2008

#install.packages("readr")
#install.packages("tidyverse")
#install.packages("VIM")
#install.packages("data.table")

library(readr)
library(VIM)
library(tidyverse)
library(data.table)

#importing the Traffic_Tickets_Issued__Four_Year_Window
tdf <- read_csv(file.choose())
#mdf <- read_csv(file.choose())

class(tdf)
str(tdf)
colnames(tdf)
summary(tdf)

#Basic preliminary analysis of the data. 
vY<- data.table(table(tdf$`Violation Year`))
vm <- data.table(table(tdf$`Violation Month`))
sl <-data.table(table(tdf$`State of License`))
av <- data.table(table(tdf$`Age at Violation`))
G <- data.table(table(tdf$Gender))
pa <- data.table(table(tdf$`Police Agency`))
court <- data.table(table(tdf$Court))
day <- data.table(table(tdf$`Violation Day of Week`))
#Basic Plotting
require(ggplot2)
pie(vY$N)
#rm is to delete the tables on the right
rm(vY, vm, sl, av, G, pa, court)
###################################################
#Binning the Age

#Training 70%

#Test 30%

#Decision Tree to predict whether the driver will have an accident or not?

#Are drivers licence holders from the state of Florida more prone to getting tickets? 
#log regression 10 fold 
# explain how much of the probability someone is ticketed is explained by their home state
require(sqldf)
df <-sqldf::sqldf()
#Are drivers worse in the following counties NASSU, SUFFOLK, NYC based on Ticket data? 

#Are men worse drivers than females? 

#Is there an evidence of a quota on tickets based on the data? 