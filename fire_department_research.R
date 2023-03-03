library(tidyverse)
setwd("~/comp-293A")

fire_department <- read.csv("./Fire_Department_Calls_for_Service.csv")
#View(fire_department)
head(fire_department)
str(fire_department)
summary(fire_department)

## Script to get the dataset if want the newest data
## Warning, this could take a very long time, possibly longer than 30 mins
# install.packages("RSocrata")
#library("RSocrata")
#fire_department <- read.socrata(
#  "https://data.sfgov.org/resource/nuek-vuh3.json",
#)
# write_csv(fire_department, "Fire_Department_Calls_for_Service.csv")
