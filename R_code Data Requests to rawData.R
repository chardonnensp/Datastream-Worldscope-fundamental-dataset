### This script imports and treats dynamic and static data to a rawdata file.


library(tidyverse)
library(reshape2)
library(data.table)
library(psych)
library(readxl)


ptm <- proc.time()


#### Dynamic and Static Data----
### Dynamic Data
#set working directory
startyear <- 1986
endyear <- 2019

## import
my_files <- list.files(path = "rawdata/TS Data/", 
                       pattern = "\\.xlsx$", full.names = TRUE) 

my_data <- lapply(X = my_files, 
                  FUN = read_xlsx, 
                  col_names = FALSE)

my_files <- list.files(path = "rawdata/TS Data/", 
                       pattern = "\\.xlsx$") 


names(my_data) <- gsub("\\.xlsx$", "", my_files) # name dataframes in list according to xlsx name

colname <- c("Symbol", startyear:endyear) #create string of column names
my_data <- lapply(my_data, setNames, colname) # set column names for each DF in list

## melt
my_data <- melt(my_data, id = c("Symbol")) # melt yearly data. Years as columns turn into SymbolYears rows

## data manipulation
colnames(my_data) <- c("Symbol", "Year", "Value", "Variable") # name variables
#my_data$Symbol <- gsub("\\s*\\([^\\)]+\\)", "", my_data$Symbol) # remove (WC.....) after Symbol Code
my_data$Symbol <- as.factor(my_data$Symbol) # force Symbol into factor
#my_data$Symbol <- replace(my_data$Symbol, my_data$Symbol == "", NA) # replace empty Symbol fields with NA
my_data$Year <- as.integer(my_data$Year)+startyear-1 # force Year into integer
#my_data$Value <- as.numeric(as.character(my_data$Value)) # force values into nummeric
my_data$Variable <- as.factor(my_data$Variable) # force Variable into factor
#my_data <- my_data[complete.cases(my_data[ , "Symbol"]),] # remove rows with missing Symbol
str(my_data)
#head(my_data)


# dcast variables into seperate columns
TSdata <- dcast(my_data, Symbol + Year ~ Variable, value.var = "Value") # create a column for every different value
rm(my_data)

# force all Values into numeric except Symbol, Year and Accounting standard (which are the first three)
colname <- c(4:length(TSdata))

TSdata[colname] <- lapply(TSdata[colname], as.numeric)


'
## set variables back one year
nums <- names(TSdata)
bookValuesBeginningYear <- subset(TSdata, select = nums) # create subset
bookValuesBeginningYear$Year <- bookValuesBeginningYear$Year+1
nums <- paste0(nums, "_t_1") # add _t_1 to each variable
nums[1] <- "Symbol" # manually overwrite Symbol
nums[2] <- "Year" # manually overwrite Year
nums[3] <- "AccountingStandards" # manually overwrite AccountingStandards
names(bookValuesBeginningYear) <- nums # assign _t_1 names to DF
TSdata <- merge(TSdata, bookValuesBeginningYear, by=c("Symbol", "Year", "AccountingStandards"))
rm(bookValuesBeginningYear)
'
## reorder variables
nums <- names(TSdata)
nums <- names(TSdata[3:length(nums)]) # remove Symbol and Year
nums <- sort(nums) # sort variables alphabetically
nums <- c("Symbol", "Year", nums) # add Symbol and Year
TSdata <- TSdata[, nums] # reorder variables


#write_csv2(TSdata, "rawdata/TSdata.csv")
#TSdata <- read_csv2("rawdata/TSdata.xlsx")







### Static Data 
## import static Data
rawStaticData <- read_xlsx("rawdata/Static Data/StaticData.xlsx")

#rawStaticData <- as.data.table(read.csv2("Static Data/StaticData.csv", header = TRUE))
colname <- c("ISIN", "Industry", "SIC", "CompanyName", names(rawStaticData)[5:10], "Country", names(rawStaticData)[12:length(rawStaticData)])
names(rawStaticData) <- colname

## select Data
rawStaticData <- rawStaticData[, c("Symbol", "CompanyName", "Currency", "Country", "Industry", "Sector", "SIC", "Activity", "Hist.")]

rawStaticData$SICshort <- as.character(rawStaticData$SIC)
rawStaticData$SICshort <- as.numeric(substr(rawStaticData$SICshort, 1, 2))


## create Regions US and European
#NCountries <- rawStaticData[, .N, by = "Country"]
#NCountries <- NCountries[order(NCountries$N, decreasing = T),]

rawStaticData$Region <- replace(rawStaticData$Country, !rawStaticData$Country == "United States", "European")
rawStaticData$Region <- replace(rawStaticData$Region, rawStaticData$Region == "United States", "US")
rawStaticData$Region <- as.factor(rawStaticData$Region)
str(rawStaticData)

### old mapping
'
#Replace individual European countries with Region "European"
rawStaticData$Region <- as.character(rawStaticData$Region)
#US: USA, JP: Japan, CN: China, CA: Canada, GB: Great Britain, IN: India, ZA: South Africa, KR: Korea, TW: Taiwan, FR: France, HK: Hongkong, 
#DE: Germany, MY: Malaysia, VN: Vietnam, SE: Sweden, SG: Singapur, TH: Thailand, RU: Russia, IL: Israel, PL: Poland, ID: Indonesia, BR: Brazil, 
#IT: Italy, CH: Switzerland, GR: Greece, TR: Turkey, NO: Norway, PK: Pakistan, ES: Spain, NL: Netherlands, DK: Denmark, PH: Philippines, 
#BE: Belgium, CL: Chile, BG: Bulgaria, LK: Sri Lanka, JO: Jordan, EG: Egypt, FI: Finland, MX: Mexico, NZ: New Zealand, KW: Kuwait, PE: Peru, 
#AT: Austria, IE: Ireland, SA: Saudi Arabia, RO: Rumania, CY: Cyprus, NG: Nigeria, BM: Bermuda, UA: Ukraine, AR: Argentina, AE: Emirates, 
#PT: Portugal, OM: Oman, HR: Croatia, RS: Serbia, GG: Georgia, LU: Luxemburg, CO: Colombia, JE: Jemen, KY: Cayman Islands, IM: Isle of Men (UK), 
#VG: Virgin Islands (UK)
rawStaticData$Region <- replace(rawStaticData$Region, rawStaticData$Region == "GB" | rawStaticData$Region == "FR" | rawStaticData$Region == "DE" | 
                            rawStaticData$Region == "SE" | rawStaticData$Region == "PL" | rawStaticData$Region == "IT" | rawStaticData$Region == "CH" | 
                            rawStaticData$Region == "GR" | rawStaticData$Region == "NO" | rawStaticData$Region == "ES" | rawStaticData$Region == "NL" | 
                            rawStaticData$Region == "DK" | rawStaticData$Region == "BE" | rawStaticData$Region == "BG" | rawStaticData$Region == "FI" | 
                            rawStaticData$Region == "AT" | rawStaticData$Region == "IE" | rawStaticData$Region == "RO" | rawStaticData$Region == "CY" | 
                            rawStaticData$Region == "UA" | rawStaticData$Region == "PT" | rawStaticData$Region == "HR" | rawStaticData$Region == "RS" | 
                            rawStaticData$Region == "LU", "European")
rawStaticData$Region <- as.factor(rawStaticData$Region)
#rawStaticData <- rawStaticData[Region == "European" | Region == "US", ] # only use European and US data 
#(not activated, because only firms located in European / US markets are taken into consideration)
summary(rawStaticData$Country)'

## Rename variables
rawStaticData$Region2 <- gsub("European", "EU", rawStaticData$Region) # create shortname of Region EU instaed of European 

#N of duplicates
nrow(rawStaticData) - length(unique(rawStaticData$Symbol))


### join dynamic and static data
rawData <- rawStaticData %>% inner_join(TSdata)
nrow(rawData)

rm(rawStaticData, TSdata)

write.csv2(rawData, "rawdata/rawData.csv", row.names=FALSE)
#rawData <- read_csv2("../Requests-to-rawData/rawdata/rawData.csv")
