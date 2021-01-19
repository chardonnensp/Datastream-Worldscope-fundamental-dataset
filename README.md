# About
This guide aims to fully describe how to download and merge Refinitiv (formerly Thomson Reuters) Datastream Worldscope data into one comprehensive dataset of yearly stock quoted financial statements.

# Motivation
Empirical databases such as Compustat provide a fully structured dataset of stock quoted firms. However, the Compustat access may be available in some institutions. Refinitiv Eikon offers an unstructured alternative. Because of the lack in structure, different individuals may result in different Worldscope datasets which limits the reproducability of studies. Therefore, this repository is a proposition on how to download and merge Worldscope data via the Refinitiv Eikon Excel Add-in. Unfortunately, I cannot provide the full dataset because the data is owned by Refinitiv. Although the templates for the data download are provided. 

# Requirements
To access the Refinitv Eikon database, your institution needs to have an account. Further, you need Microsoft Excel with the installed Add-in, which can be downloaded here: https://eikon.thomsonreuters.com/index.html 

# Overview
This guide consists of three different parts: 
1. Selecting the firms and downloading firm identifiers. 
2. Downloading the time-series data.
3. Merging the data. 

# Selecting the firms and downloading firm identifiers:
a) Make the following selections as shown in the screenshot:

  a1) Open the "Refinitiv Eikon Datastream" tab  
  a2) Go on "Find Series"  
  a3) Category: Equities  
  a4) Type: Equity, exclude ETF's, and other type of funds  
  a5) Security: Major, exclude minor securities  
  a6) Quote: Primary, exclues secondary quotes  
  
 ![Refiniv Eikon Datastream selection parameters](/Static%20Data%20selection.PNG?raw=true "Refiniv Eikon Datastream selection parameters")
 
 Now you have a world wide selection of all qualified equities! In January 2021 those are over 133 000 firms. 
 To export those firms, they must be fewer than 10 000. 

b) Select some of the countries you want to download data by filtering them in "Market" that your selection does not exceed 10 000 firms. Then you will see a small Excel symbol on the top right corner of the window. Klick on it!  
If your selected countries have more than 10 000 firms (e.g. the United States) use the sector filters (or any other filters) to temporarly include and exclude firms. 
 ![Market selection ](/Market%20selection.PNG?raw=true "Refiniv Eikon Datastream selection parameters")
 
c) Combine your downloaded Excel sheets by arranging the output underneigh each other. Make sure you only copy the data and not the variable names. 

d) The native sector classification in column J might not be sufficient for most studies. Therfore, it is necessairy to retrieve additional industry identifiers (here we add the Datastream industry group (INDC) and the SIC (WC07021). Open the template and paste in your static data. Click in cell M1 and adapt the following highlighted row length of your static data. 

