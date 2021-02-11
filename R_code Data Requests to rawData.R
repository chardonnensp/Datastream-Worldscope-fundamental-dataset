### This script imports and treats dynamic and static data to a rawdata file.

## Install the following libraries if you have not yet done so.  
'install.packages("tidyverse")
install.packages("reshape2")
install.packages("data.table")
install.packages("psych") 
install.packages("readxl")
'

## Load the libraries
library(tidyverse)
library(reshape2)
library(data.table)
library(psych)
library(readxl)


ptm <- proc.time()


#### Dynamic and Static Data----
### Dynamic Data
startyear <- 1986
endyear <- 2019

## import
my_files <- list.files(path = "rawdata/TSData/", 
                       pattern = "\\.xlsx$", full.names = TRUE) 

my_data <- lapply(X = my_files, 
                  FUN = read_xlsx, 
                  col_names = FALSE)

my_files <- list.files(path = "rawdata/TSData/", 
                       pattern = "\\.xlsx$") 


names(my_data) <- gsub("\\.xlsx$", "", my_files) # name dataframes in list according to xlsx name

colname <- c("Symbol", startyear:endyear) #create string of column names
my_data <- lapply(my_data, setNames, colname) # set column names for each DF in list

## melt
my_data <- melt(my_data, id = c("Symbol")) # melt yearly data. Years as columns turn into SymbolYears rows

## data manipulation
colnames(my_data) <- c("Symbol", "Year", "Value", "Variable") # name variables
my_data$Symbol <- as.factor(my_data$Symbol) # force Symbol into factor
my_data$Year <- as.integer(my_data$Year)+startyear-1 # force Year into integer
my_data$Variable <- as.factor(my_data$Variable) # force Variable into factor


# dcast variables into seperate columns
TSdata <- dcast(my_data, Symbol + Year ~ Variable, value.var = "Value") # create a column for every different value
rm(my_data)

# force all Values into numeric except Symbol, Year and Accounting standard (which are the first three)
colname <- c(4:length(TSdata))

TSdata[colname] <- lapply(TSdata[colname], as.numeric)


## reorder variables
nums <- names(TSdata)
nums <- names(TSdata[3:length(nums)]) # remove Symbol and Year
nums <- sort(nums) # sort variables alphabetically
nums <- c("Symbol", "Year", nums) # add Symbol and Year
TSdata <- TSdata[, nums] # reorder variables



### Static Data 
## import static Data
rawStaticData <- read_xlsx("rawdata/StaticData/StaticData.xlsx")

colname <- c("CompanyName", "Symbol", "RIC", "StartDate", "History", "Category", "Exchange", "Country", "Currency", "Sector", "FullName", "Activity", "Industry", "SIC")
names(rawStaticData) <- colname

## Data cleaning
rawStaticData <- rawStaticData[, c("Symbol", "CompanyName", "Currency", "Country", "Industry", "Sector", "SIC", "Activity", "History")]

test <- rawStaticData %>%
  select(Symbol, CompanyName, Currency, Country, Industry, Sector, SIC, Activity, History) %>%
  str_locate_all()

str_replace_all(test$CompanyName, " (XET)", replacement = "")

str_sub(test$CompanyName, "() (XET)")
str_remove(test$CompanyName, "XET")


gsub(' (XET)', '', test$CompanyName,)




str(test)

# Create 2 digit SIC code
rawStaticData$SICshort <- as.character(rawStaticData$SIC)
rawStaticData$SICshort <- as.numeric(substr(rawStaticData$SICshort, 1, 2))

rawStaticData$Region <- replace(rawStaticData$Country, !rawStaticData$Country == "United States", "European")
rawStaticData$Region <- replace(rawStaticData$Region, rawStaticData$Region == "United States", "US")
rawStaticData$Region <- as.factor(rawStaticData$Region)
str(rawStaticData)


## Rename variables
rawStaticData$Region2 <- gsub("European", "EU", rawStaticData$Region) # create shortname of Region EU instead of European 

#N of duplicates
nrow(rawStaticData) - length(unique(rawStaticData$Symbol))

### join dynamic and static data
rawData <- rawStaticData %>% inner_join(TSdata)
nrow(rawData)

rm(rawStaticData, TSdata)

write.csv2(rawData, "rawdata/rawData.csv", row.names=FALSE)

