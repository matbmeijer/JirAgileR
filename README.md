JirAgileR
================

<img src="https://travis-ci.org/matbmeijer/JirAgileR.svg?branch=master"/>

### Objective

<img src="https://www.atlassian.com/dam/jcr:e33efd9e-e0b8-4d61-a24d-68a48ef99ed5/Jira%20Software@2x-blue.png" position="right" width="200"/>

The objective of **JirAgileR** is to bring the power of the project
management tool **JIRA** to **R**. By doing so, users benefit from the
best capabilities of both platforms. More specifically, the package is a
wrapper around [JIRA’s REST
API](https://developer.atlassian.com/server/jira/platform/rest-apis/),
allowing users to analyze proyects or issues from JIRA in R. The
underlying powertrain of the API is the ***Jira Query Language** (JQL)*.
You can find more information about it
[here](https://confluence.atlassian.com/jiracore/blog/2015/07/search-jira-like-a-boss-with-jql).
All used functions return as a result a `data.frame`.

#### 2019-04-05 Functionalities

1.  Extract all projects with its basic information (e.g. Name, ID, Key,
    Type, Category etc.)
2.  Extract all issues spefic to user defined JIRA query (it allows to
    expand both JIRA’s default fields as well as user defined custom
    JIRA fields)
3.  Extract comments and comments details from JIRA issues.

#### Roadmap

1.  Define an integrated class within the package
2.  Include *pipes* to facilitate analysis
3.  Include plotting graphs

### Installation

You can install the latest release of JirAgileR from
[Github](https://github.com/matbmeijer/JirAgileR) with the following
commands in R:

``` r
if (!require("devtools")) install.packages("devtools")
devtools::install_github("matbmeijer/JirAgileR")
```

### Example

This is a basic example which shows you how to obtain a simple table of
issues of a project and create a tabular report. You will need a
username and your password to authenticate in your domain:

``` r
library(JirAgileR, quietly = T)
library(knitr, quietly = T)

Domain <- "https://bitvoodoo.atlassian.net"
JQL_query <- "project='CONGRATS'"
Search_field <- c("summary","created", "status")

df<-JiraQuery2R(domain = Domain, query = JQL_query, fields = Search_field)

kable(df, row.names = F, padding = 0)
```

| id    | key         | self                                                          | summary                                                        | created    | status      |
| :---- | :---------- | :------------------------------------------------------------ | :------------------------------------------------------------- | :--------- | :---------- |
| 57446 | CONGRATS-29 | <https://bitvoodoo.atlassian.net/rest/api/latest/issue/57446> | Display issue of standard profile picture in Internet Explorer | 2019-03-25 | In Progress |
| 57383 | CONGRATS-27 | <https://bitvoodoo.atlassian.net/rest/api/latest/issue/57383> | Congrats - Define performance tests                            | 2019-02-04 | Open        |
| 57327 | CONGRATS-26 | <https://bitvoodoo.atlassian.net/rest/api/latest/issue/57327> | Congrats Data Center Checklist                                 | 2018-11-07 | Closed      |
| 57249 | CONGRATS-24 | <https://bitvoodoo.atlassian.net/rest/api/latest/issue/57249> | Congrats for Confluence Data Center compatibility              | 2018-09-12 | In Progress |
| 57157 | CONGRATS-23 | <https://bitvoodoo.atlassian.net/rest/api/latest/issue/57157> | If max entries is above 100 user icons overlap with Congrats   | 2018-07-03 | Closed      |
| 57041 | CONGRATS-20 | <https://bitvoodoo.atlassian.net/rest/api/latest/issue/57041> | “You already congratulated” message missing after refresh      | 2018-03-19 | Closed      |
| 56904 | CONGRATS-18 | <https://bitvoodoo.atlassian.net/rest/api/latest/issue/56904> | Add a dialogue for users that urges them to fill in dates      | 2017-12-05 | Closed      |
| 56797 | CONGRATS-17 | <https://bitvoodoo.atlassian.net/rest/api/latest/issue/56797> | Synchronisation with the //Seibert/Media CUP                   | 2017-09-26 | Open        |
| 56796 | CONGRATS-16 | <https://bitvoodoo.atlassian.net/rest/api/latest/issue/56796> | Add an Interface to configure the sync fields                  | 2017-09-26 | Open        |
| 56795 | CONGRATS-15 | <https://bitvoodoo.atlassian.net/rest/api/latest/issue/56795> | Synchronisation with the Communardo UPP                        | 2017-09-26 | Open        |
| 55800 | CONGRATS-11 | <https://bitvoodoo.atlassian.net/rest/api/latest/issue/55800> | Display of age for birthday configurable                       | 2017-04-05 | Closed      |
| 52800 | CONGRATS-6  | <https://bitvoodoo.atlassian.net/rest/api/latest/issue/52800> | Do not display inactive users in Congrats Macro                | 2016-11-24 | Closed      |
| 51806 | CONGRATS-3  | <https://bitvoodoo.atlassian.net/rest/api/latest/issue/51806> | Incomplete rendering if placed in tabs                         | 2016-10-21 | Closed      |
| 50050 | CONGRATS-1  | <https://bitvoodoo.atlassian.net/rest/api/latest/issue/50050> | Display current event in the center                            | 2016-08-09 | Closed      |
