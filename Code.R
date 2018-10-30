install.packages("readr")
install.packages("VIM")
install.packages("tidyverse")
install.packages("data.table")

library(readr)
library(VIM)
library(tidyverse)
library(data.table)

#importing the Traffic_Tickets_Issued__Four_Year_Window
tdf <- read_csv(file.choose())

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

