
# JirAgileR<img src="man/figures/logo.png" align="right" height=140/>

<!-- badges: start -->

[![R-CMD-check](https://github.com/matbmeijer/JirAgileR/workflows/R-CMD-check/badge.svg)](https://github.com/matbmeijer/JirAgileR/actions)
<!-- badges: end -->

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

-   **Import**
-   **Tidy**

Hence, for easy transformation and manipulation, each function returns a
`data.frame` with **tidy data**, following main rules where each row is
a single observation of an **issue** or a **project**, each column is a
variable and each value must have its own cell. Thus, it integrates well
with both the `dplyr` and `data.table` R libraries.

More information about the package can be found at the following link:
[(https://matbmeijer.github.io/JirAgileR/](https://matbmeijer.github.io/JirAgileR/).

### Functionalities as of 01 of June, 2021

1.  Extract all project names with their basic information (e.g. Name,
    ID, Key, Type, Category etc.).
2.  Retrieve all issues specific to a user defined JIRA query with
    hand-picked fields and all the associated information. Currently,
    the package supports the following JIRA fields:
    -   *aggregateprogress*
    -   *aggregatetimeestimate*
    -   *aggregatetimespent*
    -   *assignee*
    -   *comment*
    -   *components*
    -   *created*
    -   *creator*
    -   *description*
    -   *duedate*
    -   *environment*
    -   *fixVersions*
    -   *issuelinks*
    -   *issuetype*
    -   *labels*
    -   *lastViewed*
    -   *priority*
    -   *progress*
    -   *project*
    -   *reporter*
    -   *resolution*
    -   *resolutiondate*
    -   *status*
    -   *summary*
    -   *timeestimate*
    -   *timespent*
    -   *updated*
    -   *versions*
    -   *votes*
    -   *watches*
    -   *workratio*
    -   *parent*

##### Note

-   To get all the information about the supported JQL fields visit the
    following
    [link](https://support.atlassian.com/jira-service-desk-cloud/docs/advanced-search-reference-jql-fields/).
    The package supports extracting comments, yet as one issue may
    contain multiple comments, the `data.frame` is flattened to a
    combination of issues and comments. Thus, the information of an
    issue may be repeated the number of comments each issue has.

### Roadmap

-   🔲 Retrieve JIRA boards information
-   🔲 Define integrated *Reference Classes* within the package
-   🔲 Include plotting graphs 📊
-   🔲 Abilty to obtain all available JIRA fields of a project
-   ✅ Added `get_jira_permissions()` function to retrieve JIRA user
    permissions
-   ✅ Added `get_jira_groups()` function to retrieve JIRA groups
-   ✅ Added `get_jira_server_info()` function to retrieve JIRA server
    information
-   ✅ Remove `data.table` dependency
-   ✅ Abilty to save domain, username & password as secret tokens in
    environment 🔐
-   ✅ Include *pipes* to facilitate analysis
-   ✅ Improve package robustness
-   ✅ Include http status error codes
-   ✅ Give user visibility of supported fields

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
save_jira_credentials(domain = "https://bugreports.qt.io")

# Get full list of projects in domain
get_jira_projects() %>% 
  select(key, name)  %>% 
  kable(row.names = F, padding = 0)
```

| key          | name                                        |
|:-------------|:--------------------------------------------|
| COIN         | Coin                                        |
| QBS          | Qbs (“Cubes”)                               |
| QTBUG        | Qt                                          |
| QT3DS        | Qt 3D Studio                                |
| AUTOSUITE    | Qt Automotive Suite                         |
| QTJIRA       | Qt Bugtracking interface                    |
| QTCREATORBUG | Qt Creator                                  |
| QDS          | Qt Design Studio                            |
| QTEXT        | Qt Extensions                               |
| QTMCU        | Qt for MCUs                                 |
| PYSIDE       | Qt for Python                               |
| QTIFW        | Qt Installer Framework                      |
| QTMOBILITY   | Qt Mobility                                 |
| QTPLAYGROUND | Qt Playground Projects                      |
| QTWEBSITE    | Qt Project Website                          |
| QTQAINFRA    | Qt Quality Assurance Infrastructure         |
| QTCOMPONENTS | Qt Quick Components (Deprecated, use QTBUG) |
| QSR          | Qt Safe Renderer                            |
| QTSOLBUG     | Qt Solutions                                |
| QTVSADDINBUG | Qt Visual Studio Tools                      |
| QTWB         | Qt WebBrowser                               |
| QTSYSADM     | Qt-Project.org Sysadmin (defunct)           |

``` r
# Retrieve the issues from a single project - in this case the project CONGRATS. See documentation to define which fields to see
get_jira_issues(jql_query = "project='QTWB'",
                fields = c("summary","created", "status")) %>% 
  select(key, summary, created, status_name, status_description, status_statuscategory_name) %>%
  head(5) %>%
  kable(row.names = F, padding = 0)
```

| key     | summary                                                                       | created             | status\_name | status\_description                                                 | status\_statuscategory\_name |
|:--------|:------------------------------------------------------------------------------|:--------------------|:-------------|:--------------------------------------------------------------------|:-----------------------------|
| QTWB-60 | webkit-qtwe bkit-23/Source/WTF/wtf/dtoa/bignum.cc:762: suspicious increment ? | 2021-05-12 22:56:00 | Reported     | The issue has been reported, but no validation has been done on it. | To Do                        |
| QTWB-58 | win7 touchscreen can’t click html-select dropdown list                        | 2021-04-08 09:09:00 | Reported     | The issue has been reported, but no validation has been done on it. | To Do                        |

\|QTWB-54\|Printing -
<tbody>
prints on top of
<thead>

\|2020-07-01 00:02:00\|Need More Info\|More information is needed to be
able to proceed \|Done \| \|QTWB-51\|qtwebengine select file
\|2020-05-12 01:23:00\|Closed \|The issue is considered finished, the
resolution is correct. Issues which are closed can be reopened.\|Done \|
\|QTWB-50\|No URLRequestContext for NSS HTTP handler. host:
ocsp.digicert.com \|2020-05-06 08:37:00\|Closed \|The issue is
considered finished, the resolution is correct. Issues which are closed
can be reopened.\|Done \|
