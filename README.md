# JirAgileR <img src="https://www.atlassian.com/dam/jcr:e33efd9e-e0b8-4d61-a24d-68a48ef99ed5/Jira%20Software@2x-blue.png" align="right" width="200"/>

The objective of **JirAgileR** is to bring the power of the project management tool **JIRA** to **R**. By doing so, users benefit from the best capabilities of both platforms. More speficially, it a connects to JIRA REST API, and users can continue their analysis with the extracted data in R.  

**Current Functionalities:**

* Extract all projects with its basic information (e.g. Name, ID, Key, Type, Category etc.)
* Extract all issues spefic to user defined JIRA query (it allows to expand both JIRA's default fields as well as user defined custom JIRA fields)

Roadmap:



Instead of building a diferent class object to facilitate the analysis within R a regular `data.frame` is returned. The following ideasFuture ideas is to integrate visualization options and exports as pdf slides and/or .pptx slide. Other options are to come.

## Installation

You can install the latest release of JirAgileR from [Github](https://github.com/matbmeijer/JirAgileR) with the following commands in R:

``` r
if (!require("devtools")) install.packages("devtools")
devtools::install_github("matbmeijer/JirAgileR")
```

## Example

This is a basic example which shows you how to obtain a simple table of issues of a project and create a tabular report in CSV format. You will need a username and your password to authenticate in your domain:

``` r
library(JirAgileR)

Domain <- "https://jira.yourdomain.com"
ProjectName <- "Your Project"
Username <- "YourUsername"
Password <- "YourPassword"

df<-Project2R(dn=Domain,user=Username,password=Password, project=ProjectName, search="name")

getwd()
setwd("C:/Users/ComputerUsername/Downloads")

filename <- paste0("Status JIRA ",ProjectName , format(Sys.Date(),"%Y%m%d"), ".csv")
write.csv(df,filename, row.names = FALSE)
```
