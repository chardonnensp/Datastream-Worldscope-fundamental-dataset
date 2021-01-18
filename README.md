# About
This guide aims to fully describe how to download and merge Refinitiv (formerly Thomson Reuters) Datastream Worldscope data into one comprehensive dataset of yearly stock quoted financial statements. 

# Motivation
Empirical databases such as Compustat provide a fully structured dataset of stock quoted firms. However, the Compustat access may be costly for some institutions. Refinitiv Eikon offers an unstructured alternative. Because of the lack in structure, different individuals may result in different Worldscope datasets which limits the reproducability of studies. Therefore, this repository is a proposition on how to download and merge Worldscope data via the Refinitiv Eikon Excel Add-in. 

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
 
 Now you have a world wide selection of all qualified equities! In January 2021 those are over 75 000 firms. 
 To export those firms, they must be fewer than 10 000. 
