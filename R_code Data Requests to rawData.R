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
my_data <- my_data %>%
  rename(Year = variable, 
         Value = value,
         Variable = L1) 

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
## Import, rename and select relevant variables
rawStaticData <- read_xlsx("rawdata/StaticData/StaticData.xlsx") %>%
  rename(CompanyName = Name,
         History = Hist.,
         Country = Market,
         Industry = `IND. GROUP MNEM`,
         SIC = `SIC CODE 1`) %>%
  select(Symbol, CompanyName, Currency, Country, Exchange, Industry, Sector, SIC, Activity, History)

# Some European Companynames are duplicates with "(XET)" expression, with or without space before. Remove those expressions.
newName <- str_remove(rawStaticData$CompanyName, "\\s\\(XET\\)")
newName <- str_remove(newName, "\\(XET\\)")
rawStaticData$CompanyName <- newName
rm(newName)
  
# Remove firms that have a duplicate name
rawStaticData <- rawStaticData %>%
  distinct(CompanyName, .keep_all = T)

# Create Region classifier
rawStaticData$Region <- replace(rawStaticData$Country, !rawStaticData$Country == "United States", "European")
rawStaticData$Region <- replace(rawStaticData$Region, rawStaticData$Region == "United States", "US")
rawStaticData$Region <- as.factor(rawStaticData$Region)


### join dynamic and static data
rawData <- rawStaticData %>% inner_join(TSdata)
rm(rawStaticData, TSdata)

### Write data
write.csv2(rawData, "rawdata/rawData.csv", row.names=FALSE)

