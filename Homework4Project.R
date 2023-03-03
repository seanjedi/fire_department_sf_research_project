library(tidyverse)
setwd("~/comp-293A")

data <- read_csv("Fire_Department_Calls_for_Service.csv")

names(data)<-make.names(names(data),unique = TRUE)

data <- drop_na(data)

data <- mutate(data, timetaken = as.numeric(as.POSIXct(Available.DtTm, format = "%m/%d/%Y %I:%M:%S %p") - as.POSIXct(Response.DtTm, format = "%m/%d/%Y %I:%M:%S %p")))

data <- mutate(data, arrivalTime = as.numeric(as.POSIXct(On.Scene.DtTm, format = "%m/%d/%Y %I:%M:%S %p") - as.POSIXct(Received.DtTm, format = "%m/%d/%Y %I:%M:%S %p")))

data %>%
  #filter(Call.Type == "Marine Fire" | Call.Type == "Outside Fire" | Call.Type == "Structure Fire" | Call.Type == "Train / Rain Fire" | Call.Type == "Vehicle Fire") %>%
  filter(Call.Type.Group == "Fire") %>%
  mutate(timetaken = as.numeric(as.POSIXct(Available.DtTm, format = "%m/%d/%Y %I:%M:%S %p") - as.POSIXct(Response.DtTm, format = "%m/%d/%Y %I:%M:%S %p"))) %>%
  ggplot(aes(Number.of.Alarms, timetaken, group=Number.of.Alarms, fill=Number.of.Alarms)) + geom_boxplot() + 
  labs(x = "Number of alarms at this incident", y = "Time until the responding unit becomes available (seconds)")

data %>%
  #filter(Call.Type == "Marine Fire" | Call.Type == "Outside Fire" | Call.Type == "Structure Fire" | Call.Type == "Train / Rain Fire" | Call.Type == "Vehicle Fire") %>%
  filter(Call.Type.Group == "Fire") %>%
  ggplot(aes(Number.of.Alarms, arrivalTime, group=Number.of.Alarms, fill=Number.of.Alarms)) + geom_boxplot() + 
  labs(x = "Number of alarms at this incident", y = "Time until a unit arrives (seconds)")

ggsave("ProjectPlot1.png")

# This is cool! It looks like as the number of alarms increases the median time for a unit to become available again increases as well. The number of alarms is a categorical variable because it can only take on a value from 1-5.

data %>%
  #filter(Call.Type == "Marine Fire" | Call.Type == "Outside Fire" | Call.Type == "Structure Fire" | Call.Type == "Train / Rain Fire" | Call.Type == "Vehicle Fire") %>%
  filter(Call.Type.Group == "Fire") %>%
  group_by(Incident.Number) %>%
  summarise(count = n(), callfinishtime = max(timetaken), type=Call.Type) %>%
  #filter(type != "Other" & count > 0) %>%
  ggplot(aes(count, callfinishtime, color=type)) + geom_jitter() +
  labs(x = "Number of units responding", y = "Time until the last responding unit becomes available (seconds)")

data %>%
  #filter(Call.Type == "Marine Fire" | Call.Type == "Outside Fire" | Call.Type == "Structure Fire" | Call.Type == "Train / Rain Fire" | Call.Type == "Vehicle Fire") %>%
  filter(Call.Type.Group == "Fire") %>%
  group_by(Incident.Number) %>%
  summarise(count = n(), callfinishtime = max(arrivalTime), type=Call.Type) %>%
  #filter(type != "Other" & count > 0) %>%
  ggplot(aes(count, callfinishtime, color=type)) + geom_jitter() +
  labs(x = "Number of units responding", y = "Time until the last responding unit arrives (seconds)")


data %>%
  filter(Call.Type == "Marine Fire" | Call.Type == "Outside Fire" | Call.Type == "Structure Fire" | Call.Type == "Train / Rain Fire" | Call.Type == "Vehicle Fire") %>%
  #filter(type != "Other" & count > 0) %>%
  #filter(Call.Type.Group == "Fire") %>%
  mutate(category=cut(Final.Priority, 2, labels=c("Non-Emergency", "Emergency"))) %>%
  summarise(count = n(), alarms=Number.of.Alarms, priority=category) %>%
  ggplot(aes( alarms, count, color=priority)) + geom_jitter() 


ggsave("ProjectPlot2.png")
  
# This one too! It looks like the time for an incident to be resolved increases with how many units have responded, which could be an indicator of how severe the incident is. The number of units responding is a quantitative variable because it can assume any integer value.