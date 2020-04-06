
# JirAgileR<img src="man/figures/logo.png" align="right" height=140/>

[![Build
Status](https://travis-ci.org/matbmeijer/JirAgileR.svg?branch=master)](https://travis-ci.org/matbmeijer/JirAgileR)
[![Build
status](https://ci.appveyor.com/api/projects/status/b3fole2aw1qsw2x9?svg=true)](https://ci.appveyor.com/project/matbmeijer/jiragiler)

## Objective

The **JirAgileR** R package has the mission to bring the power of the
project management tool 🔧 **JIRA** to **R**. By doing so, users benefit
from the best capabilities of both platforms. More specifically, the
package is a wrapper around [JIRA’s REST
API](https://developer.atlassian.com/server/jira/platform/rest-apis/),
allowing users to easily analyze JIRA proyects and issues from within R.
The underlying powertrain of the API is the ***Jira Query Language**
(JQL)*. You can find more information about it
[here](https://confluence.atlassian.com/jiracore/blog/2015/07/search-jira-like-a-boss-with-jql).

<figure>

<img src="man/figures/process.png" style="width:469px;height=184px">

<figcaption>

<a href="https://r4ds.had.co.nz/"><i>Source: R For Data Science - Hadley
Wickham</i></a>

</figcaption>

</figure>

The focus of this package lies in the following workflow aspects:

  - **Import**
  - **Tidy**

Hence, for easy transformation and manipulation, each function returns a
`data.frame` with **tidy data**, following main rules where each row is
a single observation of an **issue** or a **project**, each column is a
variable and each value must have its own cell.

More information about the package can be found
[here](https://matbmeijer.github.io/JirAgileR/).

### Functionalities as of 06 of April, 2020

1.  Extract all project names with their basic information (e.g. Name,
    ID, Key, Type, Category etc.).
2.  Retrieve all issues specific to a user defined JIRA query with
    hand-picked fields and all the associated information. Currently,
    the package supports the following JIRA fields:
      - *aggregateprogress*
      - *aggregatetimeestimate*
      - *aggregatetimespent*
      - *assignee*
      - *comment*
      - *components*
      - *created*
      - *creator*
      - *description*
      - *duedate*
      - *environment*
      - *fixVersions*
      - *issuelinks*
      - *issuetype*
      - *labels*
      - *lastViewed*
      - *priority*
      - *progress*
      - *project*
      - *reporter*
      - *resolution*
      - *resolutiondate*
      - *status*
      - *summary*
      - *timeestimate*
      - *timespent*
      - *updated*
      - *versions*
      - *votes*
      - *watches*
      - *workratio*

##### Note

1.  To get all the information about the supported JQL fields visit the
    folling
    [link](https://support.atlassian.com/jira-service-desk-cloud/docs/advanced-search-reference-jql-fields/)
    The package supports extracting comments, yet as one issue may
    contain multiple comments, the `data.frame` is flattened to a
    combination of issues and comments. Thus, the information of an
    issue may be repeated the number of comments each issue has.

### Roadmap

  - 🔲 Define integrated *Reference Classes* within the package
  - 🔲 Include plotting graphs 📊
  - 🔲 Abilty to save domain, username & password as secret tokens in
    environment 🔐
  - 🔲 Abilty to obtain all available JIRA fields of a project
  - 🔲 Remove `data.table` dependency
  - ✅ Include *pipes* to facilitate analysis
  - ✅ Improve package robustness
  - ✅ Include http status error codes
  - ✅ Give user visibility of supported fields

## Installation

You can install the latest release of this package from
[Github](https://github.com/matbmeijer/JirAgileR) with the following
commands in `R`:

``` r
if (!require("devtools")) install.packages("devtools")
devtools::install_github("matbmeijer/JirAgileR")
```

## Example

This is a basic example which shows you how to obtain a simple table of
issues of a project and create a tabular report. Most of the times, you
will need a username and your password to authenticate in your domain.
Possible fields to obtain (which will populate the `data.frame` columns)
can be found
[here](https://support.atlassian.com/jira-service-desk-cloud/docs/advanced-search-reference-jql-fields/).

``` r
library(JirAgileR, quietly = T)
library(knitr, quietly = T)

Domain <- "https://bitvoodoo.atlassian.net"
JQL_query <- "project='CONGRATS'"
Search_field <- c("summary","created", "status")
# Other possible fields are for example c("project", "key", "type", "priority", "resolution", "labels", "description", "links")

JiraQuery2R(domain = Domain, query = JQL_query, fields = Search_field) %>% 
  dplyr::select(key, summary, created, status_name, status_description, status_statuscategory_name) %>%
  knitr::kable(row.names = F, padding = 0)
```

| key         | summary                                                        | created             | status\_name     | status\_description                                                                                                            | status\_statuscategory\_name |
| :---------- | :------------------------------------------------------------- | :------------------ | :--------------- | :----------------------------------------------------------------------------------------------------------------------------- | ---------------------------- |
| CONGRATS-39 | Make the year of birth anonymous                               | 2019-11-06 16:02:32 | Open             | The issue is open and ready for the assignee to start work on it.                                                              | To Do                        |
| CONGRATS-38 | Changing the display of events                                 | 2019-11-06 15:52:42 | Open             | The issue is open and ready for the assignee to start work on it.                                                              | To Do                        |
| CONGRATS-37 | Add additional parameters for Events                           | 2019-11-06 08:57:14 | Open             | The issue is open and ready for the assignee to start work on it.                                                              | To Do                        |
| CONGRATS-36 | UI misaligned when error is displayed in the settings          | 2019-10-15 14:41:30 | Awaiting Release | A resolution has been taken, and it is awaiting verification by reporter. From here issues are either reopened, or are closed. | Done                         |
| CONGRATS-32 | Confluence 7 Support                                           | 2019-08-26 11:10:25 | Awaiting Release | A resolution has been taken, and it is awaiting verification by reporter. From here issues are either reopened, or are closed. | Done                         |
| CONGRATS-30 | Finish up for marketplace                                      | 2019-05-16 15:06:52 | Closed           | The issue is considered finished, the resolution is correct. Issues which are closed can be reopened.                          | Done                         |
| CONGRATS-29 | Display issue of standard profile picture in Internet Explorer | 2019-03-25 12:55:12 | Closed           | The issue is considered finished, the resolution is correct. Issues which are closed can be reopened.                          | Done                         |
| CONGRATS-28 | Occasions change to next user after 12 pm                      | 2019-02-27 11:39:44 | Closed           | The issue is considered finished, the resolution is correct. Issues which are closed can be reopened.                          | Done                         |
| CONGRATS-27 | Congrats - Define performance tests                            | 2019-02-04 10:39:08 | Closed           | The issue is considered finished, the resolution is correct. Issues which are closed can be reopened.                          | Done                         |
| CONGRATS-26 | Congrats Data Center Checklist                                 | 2018-11-07 14:32:53 | Closed           | The issue is considered finished, the resolution is correct. Issues which are closed can be reopened.                          | Done                         |
| CONGRATS-24 | Congrats for Confluence Data Center compatibility              | 2018-09-12 16:37:16 | Closed           | The issue is considered finished, the resolution is correct. Issues which are closed can be reopened.                          | Done                         |
| CONGRATS-23 | If max entries is above 100 user icons overlap with Congrats   | 2018-07-03 11:05:41 | Closed           | The issue is considered finished, the resolution is correct. Issues which are closed can be reopened.                          | Done                         |
| CONGRATS-20 | “You already congratulated” message missing after refresh      | 2018-03-19 16:47:12 | Closed           | The issue is considered finished, the resolution is correct. Issues which are closed can be reopened.                          | Done                         |
| CONGRATS-18 | Add a dialogue for users that urges them to fill in dates      | 2017-12-05 11:21:53 | Closed           | The issue is considered finished, the resolution is correct. Issues which are closed can be reopened.                          | Done                         |
| CONGRATS-17 | Synchronisation with the //Seibert/Media CUP                   | 2017-09-26 16:08:01 | Closed           | The issue is considered finished, the resolution is correct. Issues which are closed can be reopened.                          | Done                         |
| CONGRATS-16 | Add an Interface to configure the sync fields                  | 2017-09-26 16:02:30 | Awaiting Release | A resolution has been taken, and it is awaiting verification by reporter. From here issues are either reopened, or are closed. | Done                         |
| CONGRATS-15 | Synchronisation with the Communardo UPP                        | 2017-09-26 15:59:11 | Awaiting Release | A resolution has been taken, and it is awaiting verification by reporter. From here issues are either reopened, or are closed. | Done                         |
| CONGRATS-11 | Display of age for birthday configurable                       | 2017-04-05 14:09:07 | Closed           | The issue is considered finished, the resolution is correct. Issues which are closed can be reopened.                          | Done                         |
| CONGRATS-6  | Do not display inactive users in Congrats Macro                | 2016-11-24 11:28:06 | Closed           | The issue is considered finished, the resolution is correct. Issues which are closed can be reopened.                          | Done                         |
| CONGRATS-3  | Incomplete rendering if placed in tabs                         | 2016-10-21 16:15:30 | Closed           | The issue is considered finished, the resolution is correct. Issues which are closed can be reopened.                          | Done                         |
| CONGRATS-1  | Display current event in the center                            | 2016-08-09 11:52:53 | Closed           | The issue is considered finished, the resolution is correct. Issues which are closed can be reopened.                          | Done                         |
