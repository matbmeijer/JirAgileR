# JirAgileR

The objective of JirAgileR is to ease the interaction between the JIRA REST v2 API and R. Currently it allows you to extract all issues of a JIRA project as a data.frame to continue your analysis in R. Future ideas is to integrate visualization options and exports as pdf slides and/or .pptx slide. Other options are to come.

## Installation

You can install the latest release of JirAgileR from [Github](https://github.com/matbmeijer/JirAgileR) with:

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
