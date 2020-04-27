
# JirAgileR<img src="man/figures/logo.png" align="right" height=140/>

[![Build
Status](https://travis-ci.org/matbmeijer/JirAgileR.svg?branch=master)](https://travis-ci.org/matbmeijer/JirAgileR)
[![Build
status](https://ci.appveyor.com/api/projects/status/b3fole2aw1qsw2x9?svg=true)](https://ci.appveyor.com/project/matbmeijer/jiragiler)
[![Codecov test
coverage](https://codecov.io/gh/matbmeijer/JirAgileR/branch/master/graph/badge.svg)](https://codecov.io/gh/matbmeijer/JirAgileR?branch=master)

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
You can find a cheatsheet
[here](https://3kllhk1ibq34qk6sp3bhtox1-wpengine.netdna-ssl.com/wp-content/uploads/2017/12/atlassian-jql-cheat-sheet-2.pdf).

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
variable and each value must have its own cell. Thus, it integrates well
with both the `dplyr` and `data.table` R libraries.

More information about the package can be found at the following link:
[(https://matbmeijer.github.io/JirAgileR/](https://matbmeijer.github.io/JirAgileR/).

### Functionalities as of 27 of April, 2020

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

  - To get all the information about the supported JQL fields visit the
    following
    [link](https://support.atlassian.com/jira-service-desk-cloud/docs/advanced-search-reference-jql-fields/).
    The package supports extracting comments, yet as one issue may
    contain multiple comments, the `data.frame` is flattened to a
    combination of issues and comments. Thus, the information of an
    issue may be repeated the number of comments each issue has.

### Roadmap

  - 🔲 Retrieve JIRA boards information
  - 🔲 Define integrated *Reference Classes* within the package
  - 🔲 Include plotting graphs 📊
  - 🔲 Abilty to obtain all available JIRA fields of a project
  - ✅ Added `get_jira_server_info()` function to retrieve JIRA server
    information
  - ✅ Remove `data.table` dependency
  - ✅ Abilty to save domain, username & password as secret tokens in
    environment 🔐
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

## Examples

This is a basic example which shows you how to obtain a simple table of
issues of a project and create a tabular report. Most of the times, you
will need a username and your password to authenticate in your domain.
Possible fields to obtain (which will populate the `data.frame` columns)
can be found
[here](https://support.atlassian.com/jira-service-desk-cloud/docs/advanced-search-reference-jql-fields/).

``` r
library(JirAgileR, quietly = T)
library(knitr, quietly = T)
library(dplyr, quietly = T)

# Save credentials to pass them only one time
save_jira_credentials(domain = "https://bitvoodoo.atlassian.net")

# Get full list of projects in domain
get_jira_projects() %>% 
  select(key, name)  %>% 
  kable(row.names = F, padding = 0)
```

| key         | name                                    |
| :---------- | :-------------------------------------- |
| MACRODOC    | Macro Documentation for Confluence      |
| THEME       | Enterprise Theme for Confluence         |
| SBB         | SBB Widgets for Confluence              |
| SD          | Sequence Diagram                        |
| CFSYNC      | Custom Field Option Synchroniser        |
| TEMPBLOG    | Templates for Blog Posts for Confluence |
| REDIRECT    | Homepage Redirect for Confluence        |
| LABEL       | Label Scheduler for Confluence          |
| PANELBOX    | Advanced Panelboxes for Confluence      |
| REG         | bitvoodoo Registration for Confluence   |
| LABELFIX    | Label Fixer                             |
| NTCLOUD     | Navitabs - Tabs for Confluence Cloud    |
| NAVITABS    | Navitabs - Tabs for Confluence          |
| LANGUAGE    | Language Macros for Confluence          |
| SUPPLIER    | Viewtracker Supplier                    |
| SCHEDULER   | Content Scheduler for Confluence        |
| BVDEVOPS    | DevOps                                  |
| SYNCTEST    | SyncTest                                |
| VIEWTRACKER | Viewtracker - Analytics for Confluence  |
| VTCLOUD     | Viewtracker Cloud                       |
| CONGRATS    | Congrats for Confluence                 |
| EXTLINK     | External Links for Confluence           |

``` r
# Retrieve the issues from a single project - in this case the project CONGRATS. See documentation to define which fields to see
get_jira_issues(jql_query = "project='CONGRATS'",
                fields = c("summary","created", "status")) %>% 
  select(key, summary, created, status_name, status_description, status_statuscategory_name) %>%
  head(5) %>%
  kable(row.names = F, padding = 0)
```

| key         | summary                                               | created             | status\_name     | status\_description                                                                                                            | status\_statuscategory\_name |
| :---------- | :---------------------------------------------------- | :------------------ | :--------------- | :----------------------------------------------------------------------------------------------------------------------------- | ---------------------------- |
| CONGRATS-39 | Make the year of birth anonymous                      | 2019-11-06 16:02:32 | Open             | The issue is open and ready for the assignee to start work on it.                                                              | To Do                        |
| CONGRATS-38 | Changing the display of events                        | 2019-11-06 15:52:42 | Open             | The issue is open and ready for the assignee to start work on it.                                                              | To Do                        |
| CONGRATS-37 | Add additional parameters for Events                  | 2019-11-06 08:57:14 | Open             | The issue is open and ready for the assignee to start work on it.                                                              | To Do                        |
| CONGRATS-36 | UI misaligned when error is displayed in the settings | 2019-10-15 14:41:30 | Awaiting Release | A resolution has been taken, and it is awaiting verification by reporter. From here issues are either reopened, or are closed. | Done                         |
| CONGRATS-32 | Confluence 7 Support                                  | 2019-08-26 11:10:25 | Awaiting Release | A resolution has been taken, and it is awaiting verification by reporter. From here issues are either reopened, or are closed. | Done                         |
