############################ get_jira_credentials() ############################
test_that("get_jira_credentials(): Returns NA or column name DOMAIN",{
  expect_true(is.null(get_jira_credentials())||grepl("DOMAIN",names(get_jira_credentials())))
  expect_error(get_jira_credentials("test"))
})

########################## remove_jira_credentials() ###########################
test_that("remove_jira_credentials(): Does not return output but also messages verbose",{
  expect_null(remove_jira_credentials())
  expect_output(remove_jira_credentials( verbose = TRUE))
})

########################### save_jira_credentials() ############################
test_that("save_jira_credentials(): Does not return output but also messages verbose",{
  expect_null(save_jira_credentials(domain="test"))
  expect_null(save_jira_credentials(domain="test", username = "test", password = "test"))
  expect_error(save_jira_credentials(domain="test", username = "test"))
  expect_output(save_jira_credentials(domain="test", verbose = TRUE))
  expect_error(save_jira_credentials())
})

############################ supported_jql_fields() ############################
test_that("supported_jql_fields(): Field vector equal & and is.vector",{
  expect_equal(supported_jql_fields(), c("aggregateprogress", "aggregatetimeestimate", "aggregatetimespent",
                                         "assignee", "comment", "components", "created", "creator", "description",
                                         "duedate", "environment", "fixVersions", "issuelinks", "issuetype",
                                         "labels", "lastViewed", "priority", "progress", "project", "reporter",
                                         "resolution", "resolutiondate", "status", "summary", "timeestimate",
                                         "timespent", "updated", "versions", "votes", "watches", "workratio", "parent"))
  expect_error(supported_jql_fields("test"))
})

############################## basic_jql_fields() ##############################
test_that("basic_jql_fields(): Field vector equal & and is.vector",{
  expect_equal(basic_jql_fields(), c("status", "priority", "created", "reporter", "summary", "description",
                                     "assignee", "updated", "issuetype", "fixVersions"))
  expect_error(basic_jql_fields("test"))
})

#################################### conc() ####################################
test_that("conc(): Concatones to a single string and unique values",{
  expect_length(conc(c("test1", "test2", "test3", "test3")), 1)
  expect_identical(conc(c("test1", "test2", "test3", "test3")), "test1,test2,test3")
  expect_error(conc())
})

################################## to_date() ###################################
test_that("to_date(): Empty value returns error",{
  expect_error(to_date())
  expect_identical(to_date("test"), "test")
  expect_identical(to_date("2018-10-22T14:47:03.000+0200"), as.POSIXct("2018-10-22T14:47:03.000+0200", format = "%Y-%m-%dT%H:%M:%S.%OS%z"))
  expect_identical(class(to_date("2018-10-22T14:47:03.000+0200")), c("POSIXct", "POSIXt"))
})

################################# unnest_df() ##################################
test_that("unnest_df(): Empty value returns error and returns data.frame",{
  expect_error(unnest_df())
  expect_identical(class(unnest_df(data.frame(a=1:3, b=c("a","b", "c")))), "data.frame")
  expect_length(data.frame(a=1:3, b=c("a","b", "c")), 2)
  expect_identical(class(unnest_df(structure(list(a = 1:2,data = structure(list(b = c(43, 21)),class = "data.frame",
                                                             row.names = c(NA, -2L))), row.names = 1:2, class = "data.frame"))),"data.frame")
})

############################# get_jira_projects() ##############################
test_that("get_jira_projects(): Returns data.frame",{
  expect_identical(class(get_jira_projects(domain="https://bugreports.qt.io", expand = "lead", verbose = TRUE)), "data.frame")
  expect_error(get_jira_projects(domain = 1))
  expect_error(get_jira_projects(domain = "1"))
  expect_error(get_jira_projects(domain ="https://www.google.com/", username = "test", password = "test"))
})

########################### get_jira_server_info() #############################
test_that("get_jira_server_info(): Returns data.frame",{
  expect_identical(class(get_jira_server_info(domain="https://bugreports.qt.io", verbose = TRUE)), "data.frame")
  expect_error(get_jira_server_info(domain = 1))
  expect_error(get_jira_server_info(domain = "1"))
  expect_error(get_jira_server_info(domain ="https://www.google.com/",  username = "test", password = "test"))
})

########################### get_jira_server_info() #############################
test_that("get_jira_groups(): Returns data.frame",{
  expect_identical(class(get_jira_groups(domain="https://bugreports.qt.io", verbose = TRUE)), "data.frame")
  expect_error(get_jira_groups(domain = 1))
  expect_error(get_jira_groups(domain = "1"))
  expect_error(get_jira_groups(domain ="https://www.google.com/", username = "test", password = "test"))
})

############################ get_jira_permissions() ############################
test_that("get_jira_permissions(): Returns data.frame",{
  # Change url -> expect_identical(class(get_jira_permissions(domain="https://issues.redhat.com", verbose = TRUE)), "data.frame")
  expect_error(get_jira_permissions(domain = 1))
  expect_error(get_jira_permissions(domain = "1"))
  expect_error(get_jira_permissions(domain ="https://www.google.com/", username = "test", password = "test"))
})

############################## get_jira_issues() ###############################
test_that("get_jira_issues(): Empty value returns error and returns data.frame",{
  expect_error(get_jira_issues())
  expect_identical(class(get_jira_issues(domain="https://bugreports.qt.io",
                                         jql_query = "project='QTWB'",
                                         fields = "summary", verbose = TRUE)), "data.frame")
  expect_identical(class(get_jira_issues(domain="https://bugreports.qt.io",
                                         jql_query = "project='QTWB'",
                                         fields = "summary", verbose = TRUE, as.data.frame = TRUE)), "data.frame")
  expect_error(get_jira_issues(domain = "https://www.google.com", username = "test", password = "test"))
  expect_error(get_jira_issues(domain = 1, username = "test", password = "test"))
})

############################ get_jira_dashboards() #############################
test_that("get_jira_dashboards(): Empty value returns error and returns data.frame",{
  expect_error(get_jira_dashboards())
  expect_identical(class(get_jira_dashboards(domain="https://bugreports.qt.io")), "data.frame")
  expect_error(get_jira_dashboards(domain = "https://www.google.com", username = "test", password = "test"))
  expect_error(get_jira_dashboards(domain = 1, username = "test", password = "test"))
})

############################# basic_issues_info() ##############################
test_that("basic_issues_info(): Empty value returns error",{
  expect_error(basic_issues_info())
  expect_identical(
    class(basic_issues_info(list(data.frame(id=1, self="test", key="test1", stringsAsFactors = FALSE)))),
    "data.frame")
  expect_identical(names(basic_issues_info(list(data.frame(id=1, self="test", key="test1", stringsAsFactors = FALSE)))),
  c("id", "self", "key","JirAgileR_id"))
})

################################ parse_issue() #################################
test_that("parse_issue(): Empty value returns error",{
  expect_error(parse_issue())
  expect_equal(parse_issue(data.frame(created=Sys.Date()), 1),
               data.frame(JirAgileR_id=1, created=as.POSIXct(Sys.Date())))
  expect_equal(parse_issue(data.frame(created=Sys.Date()), 1),
               data.frame(JirAgileR_id=1, created=as.POSIXct(Sys.Date())))
})

########################### choose_field_function() ############################
test_that("choose_field_function(): Empty value returns error and various switches",{
  expect_error(choose_field_function())
  expect_equal(choose_field_function(data.frame(created=as.Date("2019-08-06")), type="created"),
               data.frame(created=as.POSIXct(as.Date("2019-08-06"))))
  expect_equal(choose_field_function(data.frame(duedate=as.Date("2019-08-06")), type="duedate"),
               data.frame(duedate=as.Date("2019-08-06")))
  expect_equal(choose_field_function(data.frame(resolutiondate=as.Date("2019-08-06")), type="resolutiondate"),
               data.frame(resolutiondate=as.POSIXct(as.Date("2019-08-06"))))
  expect_equal(choose_field_function(data.frame(timespent=1), type="timespent"),
               data.frame(timespent=1))
  expect_equal(choose_field_function(data.frame(description="test", stringsAsFactors = FALSE), type="description"),
               data.frame(description="test", stringsAsFactors = FALSE))
  expect_equal(choose_field_function(data.frame(summary="test", stringsAsFactors = FALSE), type="summary"),
               data.frame(summary="test", stringsAsFactors = FALSE))
  expect_equal(choose_field_function(data.frame(environment="test", stringsAsFactors = FALSE), type="environment"),
               data.frame(environment="test", stringsAsFactors = FALSE))
})

############################### summary_field() ################################
test_that("summary_field(): Empty value returns error",{
  expect_error(summary_field())
  expect_identical(
    summary_field(list(summary="test")),
    data.frame(summary="test", stringsAsFactors = FALSE)
    )
})

############################# description_field() ##############################
test_that("description_field(): Empty value returns error",{
  expect_error(description_field())
  expect_identical(
    description_field(list(description="test")),
    data.frame(description="test", stringsAsFactors = FALSE)
    )
})

############################# environment_field() ##############################
test_that("environment_field(): Empty value returns error",{
  expect_error(environment_field())
  expect_identical(
    environment_field(list(environment=1)),
    data.frame(environment=1)
  )
})

############################## workratio_field() ###############################
test_that("workratio_field(): Empty value returns error",{
  expect_error(workratio_field())
  expect_identical(
    workratio_field(list(workratio=1)),
    data.frame(workratio=1)
  )
})

############################## timespent_field() ###############################
test_that("timespent_field(): Empty value returns error",{
  expect_error(timespent_field())
  expect_identical(
    timespent_field(list(timespent=1)),
    data.frame(timespent=1)
  )
})

########################## aggregatetimespent_field() ##########################
test_that("aggregatetimespent_field(): Empty value returns error",{
  expect_error(aggregatetimespent_field())
  expect_identical(
    aggregatetimespent_field(list(aggregatetimespent=1)),
    data.frame(aggregatetimespent=1)
  )
})

######################## aggregatetimeestimate_field() #########################
test_that("aggregatetimeestimate_field(): Empty value returns error",{
  expect_error(aggregatetimeestimate_field())
  expect_identical(
    aggregatetimeestimate_field(list(aggregatetimeestimate=1)),
    data.frame(aggregatetimeestimate=1)
  )
})

############################# timeestimate_field() #############################
test_that("timeestimate_field(): Empty value returns error",{
  expect_error(timeestimate_field())
  expect_identical(
    timeestimate_field(list(timeestimate=1)),
    data.frame(timeestimate=1)
  )
})

############################### duedate_field() ################################
test_that("duedate_field(): Empty value returns error",{
  expect_error(duedate_field())
  expect_identical(
    duedate_field(list(duedate=as.Date("2019-08-06"))),
    data.frame(duedate=as.Date("2019-08-06"))
  )
})

############################### created_field() ################################
test_that("created_field(): Empty value returns error & correct format",{
  expect_error(created_field())
  expect_identical(
    created_field(list(created="2019-08-06T12:15:29.000+0200")),
    data.frame(created=as.POSIXct("2019-08-06T12:15:29.000+0200", format = "%Y-%m-%dT%H:%M:%S.%OS%z"),stringsAsFactors = FALSE)
  )
})

############################### updated_field() ################################
test_that("updated_field(): Empty value returns error & correct format",{
  expect_error(updated_field())
  expect_identical(
    updated_field(list(updated="2019-08-06T12:15:29.000+0200")),
    data.frame(updated=as.POSIXct("2019-08-06T12:15:29.000+0200", format = "%Y-%m-%dT%H:%M:%S.%OS%z"),stringsAsFactors = FALSE)
  )
})

############################ resolutiondate_field() ############################
test_that("resolutiondate_field(): Empty value returns error & correct format",{
  expect_error(resolutiondate_field())
  expect_identical(
    resolutiondate_field(list(resolutiondate="2019-08-06T12:15:29.000+0200")),
    data.frame(resolutiondate=as.POSIXct("2019-08-06T12:15:29.000+0200", format = "%Y-%m-%dT%H:%M:%S.%OS%z"),stringsAsFactors = FALSE)
  )
})

############################## lastViewed_field() ##############################
test_that("lastViewed_field(): Empty value returns error & correct format",{
  expect_error(lastViewed_field())
  expect_identical(
    lastViewed_field(list(lastViewed="2019-08-06T12:15:29.000+0200")),
    data.frame(lastViewed=as.POSIXct("2019-08-06T12:15:29.000+0200", format = "%Y-%m-%dT%H:%M:%S.%OS%z"),stringsAsFactors = FALSE)
  )
})

############################## issuetype_field() ###############################
test_that("issuetype_field(): Empty value returns error",{
  expect_error(issuetype_field())
  expect_identical(class(issuetype_field(list(issuetype=data.frame(a=1, b=2)))), "data.frame")
})

############################## components_field() ##############################
test_that("components_field(): Empty value returns error",{
  expect_error(components_field())
  expect_identical(class(components_field(list(components=data.frame(a=1, b=2)))), "data.frame")
})

############################## issuelinks_field() ##############################
test_that("issuelinks_field(): Empty value returns error",{
  expect_error(issuelinks_field())
  expect_identical(class(issuelinks_field(list(issuelinks=data.frame(a=1, b=2)))), "data.frame")
})

############################### versions_field() ###############################
test_that("versions_field(): Empty value returns error",{
  expect_error(versions_field())
  expect_identical(class(versions_field(list(versions=data.frame(a=1, b=2)))), "data.frame")
})

################################ votes_field() #################################
test_that("votes_field(): Empty value returns error",{
  expect_error(votes_field())
  expect_identical(class(votes_field(list(votes=data.frame(a=1, b=2)))), "data.frame")
})

############################## resolution_field() ##############################
test_that("resolution_field(): Empty value returns error",{
  expect_error(resolution_field())
  expect_identical(class(resolution_field(list(resolution=data.frame(a=1, b=2)))), "data.frame")
})

############################### creator_field() ################################
test_that("creator_field(): Empty value returns error",{
  expect_error(creator_field())
  expect_identical(class(creator_field(list(creator=data.frame(a=1, b=2)))), "data.frame")
})

############################### priority_field() ###############################
test_that("priority_field(): Empty value returns error",{
  expect_error(priority_field())
  expect_identical(class(priority_field(list(priority=data.frame(a=1, b=2)))), "data.frame")
})

############################### progress_field() ###############################
test_that("progress_field(): Empty value returns error",{
  expect_error(progress_field())
  expect_identical(class(progress_field(list(progress=data.frame(a=1, b=2)))), "data.frame")
})

########################## aggregateprogress_field() ###########################
test_that("aggregateprogress_field(): Empty value returns error",{
  expect_error(aggregateprogress_field())
  expect_identical(class(aggregateprogress_field(list(aggregateprogress=data.frame(a=1, b=2)))), "data.frame")
})

############################### watches_field() ################################
test_that("watches_field(): Empty value returns error",{
  expect_error(watches_field())
  expect_identical(class(watches_field(list(watches=data.frame(a=1, b=2)))), "data.frame")
})

############################### parent_field() #################################
test_that("parent_field(): Empty value returns error",{
  expect_error(parent_field())
  expect_identical(class(parent_field(list(parent=data.frame(a=1, b=2)))), "data.frame")
})

############################### project_field() ################################
test_that("project_field(): Empty value returns error",{
  expect_error(project_field())
  expect_identical(class(project_field(list(project=data.frame(a=1, b=2)))), "data.frame")
})

############################### assignee_field() ###############################
test_that("assignee_field(): Empty value returns error",{
  expect_error(assignee_field())
  expect_identical(class(assignee_field(list(assignee=data.frame(a=1, b=2)))), "data.frame")
})

############################### reporter_field() ###############################
test_that("reporter_field(): Empty value returns error",{
  expect_error(reporter_field())
  expect_identical(class(reporter_field(list(reporter=data.frame(a=1, b=2)))), "data.frame")
})

################################ status_field() ################################
test_that("status_field(): Empty value returns error",{
  expect_error(status_field())
  expect_identical(class(status_field(list(status=data.frame(a=1, b=2)))), "data.frame")
})

################################ labels_field() ################################
test_that("labels_field(): Empty value returns error",{
  expect_error(labels_field())
  expect_identical(
    labels_field(list(labels=list(1, 2, 3))),
    data.frame(labels=conc(c(1,2,3)), stringsAsFactors = FALSE)
  )
})

############################# fixVersions_field() ##############################
test_that("fixVersions_field(): Empty value returns error",{
  expect_error(fixVersions_field())
  expect_identical(class(fixVersions_field(list(fixVersions=data.frame(a=1, b=2)))), "data.frame")
})

############################### comment_field() ################################
test_that("comment_field(): Empty value returns error",{
  expect_error(comment_field())
})

################################# rbind_fill() #################################
test_that("rbind_fill(): Returns binded list",{
  expect_identical(rbind_fill(
    list(data.frame(a=c(1,2),b=c("a", "b"), stringsAsFactors = FALSE),
         data.frame(b=c("z", "y"), d=c(3,4), stringsAsFactors = FALSE))),
    data.frame(a=c(1,2,NA,NA), b=c("a","b","z","y"), d=c(NA,NA,3,4), stringsAsFactors = FALSE))
})

################################ fill_df_NAs() #################################
test_that("fill_df_NAs(): Returns correct data.frame",{
expect_identical(fill_df_NAs( x=data.frame(a=c("a","b","c"),
                                           stringsAsFactors = FALSE),
                              cols =  c("a", "b", "c"), classes=list(a="character", b="logical", c="logical")),
                 data.frame(a=c("a","b","c"), b=NA, c=NA, stringsAsFactors = FALSE))
})
