###############################################################################################
# IST 707 Final Project 
# AUTHORS: Bradley Choi
# AUTHORS: Nicholas Brown
# DATE CREATED: 10/30/2018
#
# The following data used is from the Data.gov the tdf is the Traffic Tick Issued within a four 
# -year window https://catalog.data.gov/dataset/traffic-tickets-issued-beginning-2008
###############################################################################################


###############################################################################################
# PACKAGES
###############################################################################################

#install.packages("readr")
#install.packages("tidyverse")
#install.packages("VIM")
#install.packages("data.table")
#install.packages("ggplot2")
#install.packages("sqldf")  
#install.packages("e1071")
#install.packages("arules")
#install.packages("arulesViz")

library(arules)
library(arulesViz)
library(readr)
library(VIM)
library(tidyverse)
library(data.table)
library(ggplot2)
library(sqldf)
library(e1071)

###############################################################################################
# DATA IMPORT AND PREPROCESSING
###############################################################################################

#importing the Case Information Three Year_Window
cdf <- read_csv(file.choose())
#importing the Individual Information Three Year_Window
idf <- read_csv(file.choose())
#importing the Vehicle Information Three Year_Window
vidf <- read_csv(file.choose())
#importing the Violation Information Three Year_Window
vdf <- read_csv(file.choose())

colnames(cdf)
colnames(idf)
colnames(vidf)
colnames(vdf)

#£oining two entities with the same keys
df <- sqldf::sqldf("select *
                   from vdf join idf ON idf.'Case Individual ID' = vdf.'Case Individual ID'
                   ")
summary(df)
a<-aggr(df)
a
#Removing unecessary Column
df$`Transported By` <- NULL
#changing Column Names
names(df)[1:18] <- c("Year", "Violation_Description", "Violation_Code", "Case_Individual_ID", "Year_5", "Case_Individual_ID_6", "Case_Vehicle_ID", "Victim_Status", "Role_Type", "Seating_Position", "Ejection", "License_State_Code", "Sex", "Safety_Equipment", "Injury_Descriptor", "Injury_Location", "Injury_Severity", "Age")
colnames(df)

#exporting the data
data.table::fwrite(df, "Identity&Violation.csv")

#£oining two entities with the same keys 
ndf <- sqldf::sqldf("select *
                    from idf join vidf ON idf.'Case Vehicle ID' = vidf.'Case Vehicle ID'
                    ")
summary(ndf)
b <- aggr(ndf)
b

rm(cdf, idf, vdf, vidf, ndf)
#Basic preliminary analysis of the data. 
#Basic Plotting
#Clean Up

###################################################
# SPLITTING DATA INTO TRAINING AND TEST SETS
###################################################
#Binning the Age

#Training 70%

#Test 30%

###############################################################################################
# DECISION TREE
#   TODO: create a decision Tree to predict whether the driver will have an accident or not
###############################################################################################


###############################################################################################
# MULTINOMIAL NAIVE BAYES
#   TODO: Can we predict drivers licence holders from the state of Florida more prone to 
#   getting tickets?
###############################################################################################



###############################################################################################
# ASSOCATION RULES MINING
#   TODO: create a list of arules to categorize types of drivers getting ticket, feed data from
#   - other models.
###############################################################################################



###############################################################################################
# SUPPORT VECTOR MACHINE
#   TODO:  
###############################################################################################



#Are drivers licence holders from the state of Florida more prone to getting tickets? 
#log regression 10 fold 
# explain how much of the probability someone is ticketed is explained by their home state
df <-sqldf::sqldf()
#Are drivers worse in the following counties NASSU, SUFFOLK, NYC based on Ticket data? 

#Are men worse drivers than females? 

