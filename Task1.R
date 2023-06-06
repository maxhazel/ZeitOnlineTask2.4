
library("readxl")
library("dplyr")
library("ggplot2")
library("tidyr")

#read excel file from location
raw_data <- read_excel("~/Google Drive/GNI/vgrdl_r2b3_bs2021_0.xlsx", sheet = "2.4", skip=4)

# Apply a function to each row (margin parameter = 1)
index_rows <- apply(raw_data["EU-Code"], 1, function(x) nchar(x) <= 3 && !is.na(x))

filtered <- raw_data[index_rows,]

stacked <- data.frame(filtered["Gebietseinheit"], stack(filtered[9:34]))

names(stacked)[names(stacked) == "ind"] <- "Jahr" # Fix Name of column

stacked["values"] = lapply(stacked["values"], as.numeric) # Fix data type
stacked["Jahr"] = lapply(stacked["Jahr"], function(x) as.integer(as.character(x))) # Fix data type: Transform factor datatype to integer


berlin_de = filter(stacked, Gebietseinheit == "Berlin" | Gebietseinheit == "Deutschland")

ggplot(berlin_de, aes(x=Jahr,y=values,group=Gebietseinheit,color=Gebietseinheit)) +
  geom_line() +
  ggtitle("Disposable income of private households including 
          non-profit institutions serving households per inhabitant in EUR") + 
  ylab("Income (EUR)")+
  xlab("Year")+
  labs(color="")


ggplot(stacked, aes(x=Jahr,y=values,group=Gebietseinheit,color=Gebietseinheit)) +
  geom_line() +
  ggtitle("Disposable income of private households per inhabitant in EUR") + 
  ylab("Income (EUR)")+
  xlab("Year")+
  labs(color="") 

