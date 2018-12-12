<img src="https://www.atlassian.com/dam/jcr:e33efd9e-e0b8-4d61-a24d-68a48ef99ed5/Jira%20Software@2x-blue.png" position="right" width="200"/>

The objective of **JirAgileR** is to bring the power of the project
management tool **JIRA** to **R**. By doing so, users benefit from the
best capabilities of both platforms. More specifically, the package is a
wrapper around JIRA’s REST API, allowing users to analyze JIRA’s
extracted data in R.

**Current Functionalities:**

-   Extract all projects with its basic information (e.g. Name, ID, Key,
    Type, Category etc.)
-   Extract all issues spefic to user defined JIRA query (it allows to
    expand both JIRA’s default fields as well as user defined custom
    JIRA fields)

Roadmap:

Instead of building a diferent class object to facilitate the analysis
within R a regular `data.frame` is returned. In future the objective is
to integrate visualization options and exports as pdf slides and/or
.pptx slide. Other options are to come.

Installation
------------

You can install the latest release of JirAgileR from
[Github](https://github.com/matbmeijer/JirAgileR) with the following
commands in R:

    if (!require("devtools")) install.packages("devtools")
    devtools::install_github("matbmeijer/JirAgileR")

Example
-------

This is a basic example which shows you how to obtain a simple table of
issues of a project and create a tabular report in CSV format. You will
need a username and your password to authenticate in your domain:

    library(JirAgileR)

    Domain <- "https://bitvoodoo.atlassian.net"
    JQL_query <- "project='CONGRATS'"
    Search_field <- c("summary","created", "reporter")

    df<-JiraQuery2R(domain = Domain, query = JQL_query, fields = Search_field)

    ## 
    Downloading: 2.2 kB     
    Downloading: 2.2 kB     
    Downloading: 2.3 kB     
    Downloading: 2.3 kB     
    Downloading: 2.3 kB     
    Downloading: 2.3 kB     
    Downloading: 2.3 kB     
    Downloading: 2.3 kB

    library(knitr)
    kable(df, caption = "CONGRATS status")

<table>
<caption>CONGRATS status</caption>
<thead>
<tr class="header">
<th style="text-align: left;">id</th>
<th style="text-align: left;">key</th>
<th style="text-align: left;">self</th>
<th style="text-align: left;">summary</th>
<th style="text-align: left;">created</th>
<th style="text-align: left;">reporter displayName</th>
<th style="text-align: left;">reporter name</th>
<th style="text-align: left;">reporter displayName 1</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">57327</td>
<td style="text-align: left;">CONGRATS-26</td>
<td style="text-align: left;"><a href="https://bitvoodoo.atlassian.net/rest/api/latest/issue/57327" class="uri">https://bitvoodoo.atlassian.net/rest/api/latest/issue/57327</a></td>
<td style="text-align: left;">Congrats Data Center Checklist</td>
<td style="text-align: left;">2018-11-07</td>
<td style="text-align: left;">Sascha Häusler</td>
<td style="text-align: left;"><a href="mailto:sascha.haeusler@bitvoodoo.ch">sascha.haeusler@bitvoodoo.ch</a></td>
<td style="text-align: left;">Sascha Häusler</td>
</tr>
<tr class="even">
<td style="text-align: left;">57249</td>
<td style="text-align: left;">CONGRATS-24</td>
<td style="text-align: left;"><a href="https://bitvoodoo.atlassian.net/rest/api/latest/issue/57249" class="uri">https://bitvoodoo.atlassian.net/rest/api/latest/issue/57249</a></td>
<td style="text-align: left;">Congrats for Confluence Data Center compatibility</td>
<td style="text-align: left;">2018-09-12</td>
<td style="text-align: left;">Robin Stohler</td>
<td style="text-align: left;">Robin</td>
<td style="text-align: left;">Robin Stohler</td>
</tr>
<tr class="odd">
<td style="text-align: left;">57157</td>
<td style="text-align: left;">CONGRATS-23</td>
<td style="text-align: left;"><a href="https://bitvoodoo.atlassian.net/rest/api/latest/issue/57157" class="uri">https://bitvoodoo.atlassian.net/rest/api/latest/issue/57157</a></td>
<td style="text-align: left;">If max entries is above 100 user icons overlap with Congrats</td>
<td style="text-align: left;">2018-07-03</td>
<td style="text-align: left;">Niklas Becker [bitvoodoo]</td>
<td style="text-align: left;">Niklas</td>
<td style="text-align: left;">Niklas Becker [bitvoodoo]</td>
</tr>
<tr class="even">
<td style="text-align: left;">57041</td>
<td style="text-align: left;">CONGRATS-20</td>
<td style="text-align: left;"><a href="https://bitvoodoo.atlassian.net/rest/api/latest/issue/57041" class="uri">https://bitvoodoo.atlassian.net/rest/api/latest/issue/57041</a></td>
<td style="text-align: left;">“You already congratulated” message missing after refresh</td>
<td style="text-align: left;">2018-03-19</td>
<td style="text-align: left;">Niklas Becker [bitvoodoo]</td>
<td style="text-align: left;">Niklas</td>
<td style="text-align: left;">Niklas Becker [bitvoodoo]</td>
</tr>
<tr class="odd">
<td style="text-align: left;">56904</td>
<td style="text-align: left;">CONGRATS-18</td>
<td style="text-align: left;"><a href="https://bitvoodoo.atlassian.net/rest/api/latest/issue/56904" class="uri">https://bitvoodoo.atlassian.net/rest/api/latest/issue/56904</a></td>
<td style="text-align: left;">Add a dialogue for users that urges them to fill in dates</td>
<td style="text-align: left;">2017-12-05</td>
<td style="text-align: left;">Niklas Becker [bitvoodoo]</td>
<td style="text-align: left;">Niklas</td>
<td style="text-align: left;">Niklas Becker [bitvoodoo]</td>
</tr>
<tr class="even">
<td style="text-align: left;">56797</td>
<td style="text-align: left;">CONGRATS-17</td>
<td style="text-align: left;"><a href="https://bitvoodoo.atlassian.net/rest/api/latest/issue/56797" class="uri">https://bitvoodoo.atlassian.net/rest/api/latest/issue/56797</a></td>
<td style="text-align: left;">Synchronisation with the //Seibert/Media CUP</td>
<td style="text-align: left;">2017-09-26</td>
<td style="text-align: left;">Oliver Strässer</td>
<td style="text-align: left;"><a href="mailto:oliver.straesser@bitvoodoo.ch">oliver.straesser@bitvoodoo.ch</a></td>
<td style="text-align: left;">Oliver Strässer</td>
</tr>
<tr class="odd">
<td style="text-align: left;">56796</td>
<td style="text-align: left;">CONGRATS-16</td>
<td style="text-align: left;"><a href="https://bitvoodoo.atlassian.net/rest/api/latest/issue/56796" class="uri">https://bitvoodoo.atlassian.net/rest/api/latest/issue/56796</a></td>
<td style="text-align: left;">Add an Interface to configure the sync fields</td>
<td style="text-align: left;">2017-09-26</td>
<td style="text-align: left;">Oliver Strässer</td>
<td style="text-align: left;"><a href="mailto:oliver.straesser@bitvoodoo.ch">oliver.straesser@bitvoodoo.ch</a></td>
<td style="text-align: left;">Oliver Strässer</td>
</tr>
<tr class="even">
<td style="text-align: left;">56795</td>
<td style="text-align: left;">CONGRATS-15</td>
<td style="text-align: left;"><a href="https://bitvoodoo.atlassian.net/rest/api/latest/issue/56795" class="uri">https://bitvoodoo.atlassian.net/rest/api/latest/issue/56795</a></td>
<td style="text-align: left;">Synchronisation with the Communardo UPP</td>
<td style="text-align: left;">2017-09-26</td>
<td style="text-align: left;">Oliver Strässer</td>
<td style="text-align: left;"><a href="mailto:oliver.straesser@bitvoodoo.ch">oliver.straesser@bitvoodoo.ch</a></td>
<td style="text-align: left;">Oliver Strässer</td>
</tr>
<tr class="odd">
<td style="text-align: left;">55800</td>
<td style="text-align: left;">CONGRATS-11</td>
<td style="text-align: left;"><a href="https://bitvoodoo.atlassian.net/rest/api/latest/issue/55800" class="uri">https://bitvoodoo.atlassian.net/rest/api/latest/issue/55800</a></td>
<td style="text-align: left;">Display of age for birthday configurable</td>
<td style="text-align: left;">2017-04-05</td>
<td style="text-align: left;">Daniele Talerico</td>
<td style="text-align: left;"><a href="mailto:daniele.talerico@bitvoodoo.ch">daniele.talerico@bitvoodoo.ch</a></td>
<td style="text-align: left;">Daniele Talerico</td>
</tr>
<tr class="even">
<td style="text-align: left;">52800</td>
<td style="text-align: left;">CONGRATS-6</td>
<td style="text-align: left;"><a href="https://bitvoodoo.atlassian.net/rest/api/latest/issue/52800" class="uri">https://bitvoodoo.atlassian.net/rest/api/latest/issue/52800</a></td>
<td style="text-align: left;">Do not display inactive users in Congrats Macro</td>
<td style="text-align: left;">2016-11-24</td>
<td style="text-align: left;">Sharon Funke</td>
<td style="text-align: left;"><a href="mailto:sharon.funke@bitvoodoo.ch">sharon.funke@bitvoodoo.ch</a></td>
<td style="text-align: left;">Sharon Funke</td>
</tr>
<tr class="odd">
<td style="text-align: left;">51806</td>
<td style="text-align: left;">CONGRATS-3</td>
<td style="text-align: left;"><a href="https://bitvoodoo.atlassian.net/rest/api/latest/issue/51806" class="uri">https://bitvoodoo.atlassian.net/rest/api/latest/issue/51806</a></td>
<td style="text-align: left;">Incomplete rendering if placed in tabs</td>
<td style="text-align: left;">2016-10-21</td>
<td style="text-align: left;">Sharon Funke</td>
<td style="text-align: left;"><a href="mailto:sharon.funke@bitvoodoo.ch">sharon.funke@bitvoodoo.ch</a></td>
<td style="text-align: left;">Sharon Funke</td>
</tr>
<tr class="even">
<td style="text-align: left;">50050</td>
<td style="text-align: left;">CONGRATS-1</td>
<td style="text-align: left;"><a href="https://bitvoodoo.atlassian.net/rest/api/latest/issue/50050" class="uri">https://bitvoodoo.atlassian.net/rest/api/latest/issue/50050</a></td>
<td style="text-align: left;">Display current event in the center</td>
<td style="text-align: left;">2016-08-09</td>
<td style="text-align: left;">Oliver Strässer</td>
<td style="text-align: left;"><a href="mailto:oliver.straesser@bitvoodoo.ch">oliver.straesser@bitvoodoo.ch</a></td>
<td style="text-align: left;">Oliver Strässer</td>
</tr>
</tbody>
</table>
