###############################################################################################
# IST 707 Final Project 
# AUTHORS: Bradley Choi
# AUTHORS: Nicholas Brown
# DATE CREATED: 10/30/2018
# LAST UPDATED: 4 DECEMBER 2018
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
#install.packages("caret")
#install.packages("arulesViz")

library(arules)
library(arulesViz)
library(readr)
library(caret)
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

#Joining two entities with the same keys
df <- sqldf::sqldf("select *
                   from vdf join idf ON idf.'Case Individual ID' = vdf.'Case Individual ID'
                   ")
summary(df)
a<-aggr(df)
a
#seeing the Colnames
colnames(df)
#changing Column Names
names(df)[1:19] <- c("Year", "Violation_Description", "Violation_Code", 
                     "Case_Individual_ID", "Year_5", "Case_Individual_ID_6", 
                     "Case_Vehicle_ID", "Victim_Status", "Role_Type", "Seating_Position", 
                     "Ejection", "License_State_Code", "Sex", "Transported_By", "Safety_Equipment", 
                     "Injury_Descriptor", "Injury_Location", "Injury_Severity", "Age")
colnames(df)
#Removing unecessary Column
df$Transported_By <- NULL
#confirmation
colnames(df)
#Removing redundant attributes
df$Year <- NULL
df$Year_5 <- NULL
df$Violation_Code <- NULL 
df$Case_Individual_ID <- NULL
df$Case_Individual_ID_6 <- NULL
df$Case_Vehicle_ID <- NULL
#confirmation
colnames(df)

#exporting the data
data.table::fwrite(df, "Identity&Violation.csv")

data <- read_csv("/Users/wuonseokchoi/Identity&Violation.csv")

rm(cdf, idf, vdf, vidf)
rm(a)
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
#Weka 
###############################################################################################
# MULTINOMIAL NAIVE BAYES
#   TODO: Can we predict drivers licence holders from the state of Florida more prone to 
#   getting tickets?
###############################################################################################
#Weka
###############################################################################################
# ASSOCATION RULES MINING
#   TODO: create a list of arules to categorize types of drivers getting ticket, feed data from
#   - other models.
###############################################################################################
tdf = data.frame(sapply(df,as.factor))
colnames(tdf)
rclass(tdf)
rules <- apriori(tdf, parameter = list(supp=0.01, conf=0.5))
inspect(head(rules, 20))
rules=apriori(tdf, parameter =list(sup=0.01, conf=0.01, maxlen=3))
inspect(head(rules, 20))
rules=apriori(tdf, parameter =list(sup=0.8, conf=0.6, maxlen=3))
inspect(head(rules, 28))
rules <- apriori(tdf, parameter = list(minlen=2, supp=0.03, conf=0.6),
                 appearance = list(rhs=c("Sex=M", "Sex=F"),
                                   default="lhs"),
                 control = list(verbose=F))
inspect(head(rules, 20))

#ndf$Seating_Position <- NULL
ndf$Role_Type <- NULL
ndf$Injury_Location <- NULL
ndf$License_State_Code <- NULL #taking out the license state code as the output included false positives as the data is from NYS 
colnames(ndf)

rules=apriori(ndf, parameter =list(sup=0.03, conf=0.6, maxlen=3))
inspect(head(rules, 10))
plot(rules)
#How the Driver or the Passenger y the auto survived 
Survived <- apriori(ndf, parameter = list(minlen=2, supp=0.03, conf=0.006),
                    appearance = list(rhs=c("Victim_Status=Conscious", "Victim_Status=Semiconscious"),
                                      default="lhs"),
                    control = list(verbose=F))
inspect(head(Survived, 20))
plot(Survived, main="Conscious & Semiconscious Victims")
#Case of Driver's 
killed <- apriori(ndf, parameter=list(minlen=2, maxlen=3, supp=0.00001, conf=0.00001),
                  appearance=list(rhs=c("Injury_Severity=Killed"),
                                  default="lhs"),
                  control=list(verbose=F))
inspect(head(killed, 10))
plot(killed, main="Killed Victims")
#What causes Ejection of the Driver or the Passenger y the automobile? 
Ejection <- apriori(ndf, parameter = list(minlen=2, supp=0.003, conf=0.005, maxlen=3),
                    appearance = list(rhs=c("Ejection=Ejected", "Ejection=Partially Ejected"),
                                      default="lhs"),
                    control = list(verbose=F))

inspect(Ejection)
plot(Ejection, main="Ejected Victims")
#The top five Violations Following too Closely, Unlicensed Operator, Moved from lane Unsafely, and Driving while Intoxicated 
Violation <- apriori(ndf, parameter=list(supp=0.04, conf=0.09, maxlen=3),
                     appearance = list(rhs=c("Violation_Description=FOLLOWING TOO CLOSELY", "Violation_Description=UNLICENSED OPERATOR", "Violation_Description=MOVED FROM LANE UNSAFELY", "Violation_Description=SPEED NOT REASONABLE & PRUDENT", "Violation_Description=DRIVING WHILE INTOXICATED"),
                                       default="lhs"),
                     control=list(verbose=F))

inspect(head(Violation, 20))
plot(Violation, main="Top 5 Violations", jitter=0)
###############################################################################################
# k-means
#   TODO:  
###############################################################################################
#Weka