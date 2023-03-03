library("tidyverse")
setwd("~/comp-293A")
fire <- read.csv("./Fire_Department_Calls_for_Service.csv")
# head(fire)
summary(fire_first_million)
# View(fire)

# Cutting down data to the first million since otherwise it will be too large
n = 500000
fire_half_million = tail(fire, n)
head(fire_half_million)
#n = 1000000
#fire_million = tail(fire, n)
dev.new(width = 1280, height = 720, unit = "px")

fire_half_million %>%
  drop_na() %>%
  group_by(Analysis.Neighborhoods, Call.Type)%>%
  summarize(count = n()) %>%
  filter(Call.Type == "Alarms" |  Call.Type == "Structure Fire" | Call.Type == "Outside Fire" | Call.Type == "Traffic Collision") %>%
  ggplot(aes(Analysis.Neighborhoods, count, color=Call.Type)) + geom_point()
ggsave("fire_department_plot1.png")

fire_half_million %>%
  drop_na() %>%
  group_by(Zipcode.of.Incident, Call.Type)%>%
  summarize(count = n()) %>%
  filter(Call.Type == "Alarms" | Call.Type=="Explosion" | Call.Type=="Oil Spill" | Call.Type=="Administrative") %>%
  ggplot(aes(Zipcode.of.Incident, count, color=Call.Type)) + geom_point()

fire_half_million %>% 
  drop_na() %>%
  ggplot(aes(Zipcode.of.Incident, Number.of.Alarms, color=Call.Type)) + geom_point()

fire_half_million %>%
  drop_na() %>%
  ggplot(aes(Call.Type, Analysis.Neighborhoods)) + geom_boxplot()

unique(fire_half_million$Call.Type)
fire_half_million %>%
  drop_na() %>%
  filter(Call.Type=="Elevator / Escalator Rescue" |Call.Type=="Alarms" |Call.Type=="Medical Incident" |Call.Type=="Structure Fire" |Call.Type=="Other" |Call.Type=="Marine Fire" |Call.Type=="Traib / Rail Fire"|Call.Type=="Vehicle Fire")%>%
  ggplot(aes(Call.Type, Analysis.Neighborhoods)) + geom_boxplot()

ggsave("fire_department_plot2.png")
