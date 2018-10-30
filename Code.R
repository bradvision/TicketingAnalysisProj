library(readr)
library(VIM)
library(tidyverse)
library(data.table)
#importing the Traffic_Tickets_Issued__Four_Year_Window
tdf <- read_csv(file.choose())

class(tdf)
str(tdf)
summary(tdf)

#Basic preliminary analysis of the data. 
vY<- data.table(table(tdf$`Violation Year`))
vm <- data.table(table(tdf$`Violation Month`))
sl <-data.table(table(tdf$`State of License`))
av <- data.table(table(tdf$`Age at Violation`))
