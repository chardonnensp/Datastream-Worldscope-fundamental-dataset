# About
This guide aims to be a full instruction on how to download and merge Refinitiv (formerly Thomson Reuters) Datastream Worldscope data into one comprehensive dataset of yearly stock quoted financial statements.

# Motivation
Empirical databases such as Compustat provide a fully structured dataset of stock quoted firms. However, the Compustat access may not be available in some institutions due to its costliness. Refinitiv Eikon offers an unstructured alternative. Because of the lack in a structured dataset, different individuals may result with different data which limits the reproducibility  of studies. Therefore, this repository offers a proposition on how to download and merge Worldscope data via the Refinitiv Eikon Excel Add-in. Unfortunately, I cannot provide the full dataset because the data is owned by Refinitiv. Although some templates for the data download are provided. 

# Alternatives
For very small requests, the Datastream Web Service API might be an alternative (https://developers.refinitiv.com/content/dam/devportal/api-families/eikon/datastream-web-service/documentation/manuals-and-guides/datastream-refinitiv-dsws-r.pdf).

# Requirements
To access the Refinitiv Eikon database, your institution needs to have an account. Further, you need Microsoft Excel with the installed Add-in, which can be downloaded here: https://eikon.thomsonreuters.com/index.html 

# Before you start


# Guide
## Overview
This guide consists of three steps: 
1. Selecting the firms and downloading firm identifiers. 
2. Downloading the time-series data.
3. Merging the data. 

## Selecting the firms and downloading firm identifiers:
a) Follow the selections as shown in the screenshot:

  a1) Open the "Refinitiv Eikon Datastream" tab  
  a2) Go on "Find Series"  
  a3) Category: Equities  
  a4) Type: Equity, exclude ETF's, and other type of funds  
  a5) Security: Major, exclude minor securities  
  a6) Quote: Primary, exclude secondary quotes  
  
 ![Refiniv Eikon Datastream selection parameters](/Screenshots/Static%20Data%20selection.PNG?raw=true "Refiniv Eikon Datastream selection parameters")
 
 Now you have a worldwide selection of all qualified equities! In January 2021 those are over 133 000 firms. To export those firms to Excel, they must be fewer than 10 000. 

b) Select some of the countries you want to download data for by filtering them in "Market" that the number of selected is below 10 000 firms. Then a small Excel symbol on the top right corner of the window appears. Klick on it!  
If your selected countries have more than 10 000 firms (e.g. the United States) use the sector filters (or any other filters) to temporarily  include and exclude firms. 
 ![Market selection ](/Screenshots/Market%20selection.PNG?raw=true "Refiniv Eikon Datastream selection parameters")
 
c) Combine your downloaded Excel sheets by copying the output underneath each other. Make sure you only copy the data and not the variable headers such as Name, Symbol, RIC and so forth. 

d) The native sector classification in column J might not be sufficient for most studies. Therefore, it is necessary  to retrieve additional industry identifiers (here we add the Datastream industry group (INDC) and the SIC (WC07021). Open the template (![StaticData_template](/Templates/StaticData_template.xlsx?raw=true "StaticData_template") and paste your static data in the template. 

e) Click in cell M1 and adapt the following highlighted row length of your static data. It may take a while to retrieve the data, depending on the number of firms. 
![Row length](/Screenshots/Row%20length.PNG?raw=true "Refiniv Eikon Datastream selection parameters")

f) Save the file in the folder /rawdata/Static Data. Now your static data is ready. 


## Downloading the time-series data:
a) Open the .xlsx file ![TSData_template](/Templates/TSData_template.xlsx?raw=true "TSData_template"). 

b) Paste your data in column  B from your StaticData.xlsx into column A of your TSData_template.xslx. Skip the column header. 

c) Click on cell B1, where the Datastream formula is rooted and if needed make the following changes:
  c1) Adapt the row number to the length of your column A. 
  c2) Change the expression if needed (here WC08001 refers to the market capitalization).
  c3) Change the start date. 
  c4) Change the end date.

d) Refresh the data. This might take a while, depending on the size of the request. 

e) Save the file in the folder /rawdata/TS Data. Choose the filename carefully as it will be the variable name in the final dataset. 

f) Duplicate the file and save it under a different variable name. 

g) Open it and change the expression. The ![Thomson Financial Worldscope](/Templates/Thomson%20Financial%20Worldscope.pdf?raw=true "Thomson Financial Worldscope") provides a comprehensive list of the Worldscope code. If you look up for instance the code for total assets (02999), your formula must have the expression "WC02999" to work. 


## Merging the data:
a) Open the R code. 

b) Make sure you saved your files in the corresponding folder. 

c) Run the code. You now should have a structured dataset containing Worldscope data.



## I hope this guide is helpful to you. Any feedback is greatly appreciated!
