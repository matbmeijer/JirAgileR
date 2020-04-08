############################ get_jira_credentials() ############################
test_that("get_jira_credentials(): Returns NA or column name DOMAIN",{
  expect_true(is.na(get_jira_credentials())||grepl("DOMAIN",names(get_jira_credentials())))
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
                                         "timespent", "updated", "versions", "votes", "watches", "workratio"))
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
  expect_identical(to_date("2018-10-22T14:47:03.000+0200"), as.POSIXlt("2018-10-22T14:47:03.000+0200", format = "%Y-%m-%dT%H:%M:%S.%OS%z"))
  expect_identical(class(to_date("2018-10-22T14:47:03.000+0200")), c("POSIXlt", "POSIXt"))
})

############################### error_response() ###############################
test_that("error_response(): Character and number return same value",{
  expect_identical(error_response(400), error_response("400"))
  expect_length(error_response(401),1)
  expect_error(expect_length())
  expect_null(error_response(600))
  expect_type(error_response(402), "character")
  expect_type(error_response(403), "character")
  expect_type(error_response(404), "character")
  expect_type(error_response(405), "character")
  expect_type(error_response(406), "character")
  expect_type(error_response(407), "character")
  expect_type(error_response(408), "character")
  expect_type(error_response(429), "character")
  expect_type(error_response(500), "character")
  expect_type(error_response(502), "character")
  expect_type(error_response(503), "character")
})

################################# unnest_df() ##################################
test_that("unnest_df(): Empty value returns error and returns data.frame",{
  expect_error(unnest_df())
  expect_identical(class(unnest_df(data.frame(a=1:3, b=c("a","b", "c")))), "data.frame")
  expect_length(data.frame(a=1:3, b=c("a","b", "c")), 2)
})

############################# get_jira_projects() ##############################
test_that("get_jira_projects(): Returns data.frame",{
  expect_identical(class(get_jira_projects(domain="https://bitvoodoo.atlassian.net")), "data.frame")
  expect_error(get_jira_projects(domain = 1))
})

############################## get_jira_issues() ###############################
test_that("get_jira_issues(): Empty value returns error and returns data.frame & data.table",{
  expect_error(get_jira_issues())
  expect_identical(class(get_jira_issues(domain="https://bitvoodoo.atlassian.net",
                                         jql_query = "project='CONGRATS'",
                                         fields = "summary")), c("data.table", "data.frame"))
  expect_error(get_jira_issues(domain = 1))
})

############################# basic_issues_info() ##############################
test_that("basic_issues_info(): Empty value returns error",{
  expect_error(basic_issues_info())
  expect_identical(
    class(basic_issues_info(list(data.frame(id=1, self="test", key="test1", stringsAsFactors = FALSE)))),
    c("data.table", "data.frame"))
  expect_identical(names(basic_issues_info(list(data.frame(id=1, self="test", key="test1", stringsAsFactors = FALSE)))),
  c("id", "self", "key","JirAgileR_id"))
})

################################ parse_issue() #################################
test_that("parse_issue(): Empty value returns error",{
  expect_error(parse_issue())
  expect_equal(parse_issue(data.frame(created=Sys.Date()), 1),
               data.frame(JirAgileR_id=1, created=Sys.Date()))
})

########################### choose_field_function() ############################
test_that("choose_field_function(): Empty value returns error",{
  expect_error(choose_field_function())
  expect_equal(choose_field_function(data.frame(created=Sys.Date()), type="created"),
               data.frame(created=Sys.Date()))
  expect_equal(choose_field_function(data.frame(duedate=Sys.Date()), type="duedate"),
               data.frame(duedate=Sys.Date()))
  expect_equal(choose_field_function(data.frame(resolutiondate=Sys.Date()), type="resolutiondate"),
               data.frame(resolutiondate=Sys.Date()))
  expect_equal(choose_field_function(data.frame(timespent=Sys.Date()), type="timespent"),
               data.frame(timespent=Sys.Date()))

})

############################### summary_field() ################################
test_that("summary_field(): Empty value returns error",{
  expect_error(summary_field())
})

############################# description_field() ##############################
test_that("description_field(): Empty value returns error",{
  expect_error(description_field())
})

############################# environment_field() ##############################
test_that("environment_field(): Empty value returns error",{
  expect_error(environment_field())
})

############################## workratio_field() ###############################
test_that("workratio_field(): Empty value returns error",{
  expect_error(workratio_field())
})

############################## timespent_field() ###############################
test_that("timespent_field(): Empty value returns error",{
  expect_error(timespent_field())
})

########################## aggregatetimespent_field() ##########################
test_that("aggregatetimespent_field(): Empty value returns error",{
  expect_error(aggregatetimespent_field())
})

######################## aggregatetimeestimate_field() #########################
test_that("aggregatetimeestimate_field(): Empty value returns error",{
  expect_error(aggregatetimeestimate_field())
})

############################# timeestimate_field() #############################
test_that("timeestimate_field(): Empty value returns error",{
  expect_error(timeestimate_field())
})

############################### duedate_field() ################################
test_that("duedate_field(): Empty value returns error",{
  expect_error(duedate_field())
})

############################### created_field() ################################
test_that("created_field(): Empty value returns error",{
  expect_error(created_field())
})

############################### updated_field() ################################
test_that("updated_field(): Empty value returns error",{
  expect_error(updated_field())
})

############################ resolutiondate_field() ############################
test_that("resolutiondate_field(): Empty value returns error",{
  expect_error(resolutiondate_field())
})

############################## lastViewed_field() ##############################
test_that("lastViewed_field(): Empty value returns error",{
  expect_error(lastViewed_field())
})

############################## issuetype_field() ###############################
test_that("issuetype_field(): Empty value returns error",{
  expect_error(issuetype_field())
})

############################## components_field() ##############################
test_that("components_field(): Empty value returns error",{
  expect_error(components_field())
})

############################## issuelinks_field() ##############################
test_that("issuelinks_field(): Empty value returns error",{
  expect_error(issuelinks_field())
})

############################### versions_field() ###############################
test_that("versions_field(): Empty value returns error",{
  expect_error(versions_field())
})

################################ votes_field() #################################
test_that("votes_field(): Empty value returns error",{
  expect_error(votes_field())
})

############################## resolution_field() ##############################
test_that("resolution_field(): Empty value returns error",{
  expect_error(resolution_field())
})

############################### creator_field() ################################
test_that("creator_field(): Empty value returns error",{
  expect_error(creator_field())
})

############################### priority_field() ###############################
test_that("priority_field(): Empty value returns error",{
  expect_error(priority_field())
})

############################### progress_field() ###############################
test_that("progress_field(): Empty value returns error",{
  expect_error(progress_field())
})

########################## aggregateprogress_field() ###########################
test_that("aggregateprogress_field(): Empty value returns error",{
  expect_error(aggregateprogress_field())
})

############################### watches_field() ################################
test_that("watches_field(): Empty value returns error",{
  expect_error(watches_field())
})

############################### project_field() ################################
test_that("project_field(): Empty value returns error",{
  expect_error(project_field())
})

############################### assignee_field() ###############################
test_that("assignee_field(): Empty value returns error",{
  expect_error(assignee_field())
})

############################### reporter_field() ###############################
test_that("reporter_field(): Empty value returns error",{
  expect_error(reporter_field())
})

################################ status_field() ################################
test_that("status_field(): Empty value returns error",{
  expect_error(status_field())
})

################################ labels_field() ################################
test_that("labels_field(): Empty value returns error",{
  expect_error(labels_field())
})

############################# fixVersions_field() ##############################
test_that("fixVersions_field(): Empty value returns error",{
  expect_error(fixVersions_field())
})

############################### comment_field() ################################
test_that("comment_field(): Empty value returns error",{
  expect_error(comment_field())
})
