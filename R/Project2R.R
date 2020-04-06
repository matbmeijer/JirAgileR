#' @title Returns the supported JQL fields
#' @description Function shows all the supported JQL fields that are available to choose for the \code{JiraQuery2R()} function.
#' @author Matthias Brenninkmeijer \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Returns a character vector of all the supported JQL fields.
#' @export

supported_jql_fields<-function(){
  return(
    c("aggregateprogress",
      "aggregatetimeestimate",
      "aggregatetimespent",
      "assignee",
      "comment",
      "components",
      "created",
      "creator",
      "description",
      "duedate",
      "environment",
      "fixVersions",
      "issuelinks",
      "issuetype",
      "labels",
      "lastViewed",
      "priority",
      "progress",
      "project",
      "reporter",
      "resolution",
      "resolutiondate",
      "status",
      "summary",
      "timeestimate",
      "timespent",
      "updated",
      "versions",
      "votes",
      "watches",
      "workratio"))}

#' @title Returns default JQL fields used
#' @description Internal function used to define the default JQL fields used for the \code{JiraQuery2R()} function.
#' @author Matthias Brenninkmeijer \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Returns a \code{character} vector with the default JQL fields.
#' @section Warning:
#' Internal function

basic_jql_fields<-function(){
  fields <- c("status",
              "priority",
              "created",
              "reporter",
              "summary",
              "description",
              "assignee",
              "updated",
              "issuetype",
              "fixVersions")
  return(fields)
}

#' @title Concatenates multiple strings
#' @description Internal function with an opinionated default behaviour to concatenate charcter values.
#' @param x A single character vector to concatenate together.
#' @param y By default a \code{,} string used to define the character to collapse the \code{x} parameter.
#' @param decr Optional logical parameter that defines the sorting order, by default set to \code{FALSE}, which results in an alphabetical order.
#' @param unique Optional logical parameter to concatenate only unique values, by default set to \code{TRUE}
#' @author Matthias Brenninkmeijer \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Returns a single character string.
#' @section Warning:
#' Internal function

conc<-function(x, y=",", decr=FALSE, unique=TRUE){
  x<-sort(unique(x), decreasing = decr)
  return(paste0(x, collapse = y))
}

#' @title Transforms JIRA date character to POSIXlt format
#' @description Internal function to parse the date from JIRA character vectors.
#' @param x Character vector to transform into a \code{POSIXlt}.
#' @author Matthias Brenninkmeijer \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Returns a \code{POSIXlt} object vector.
#' @section Warning:
#' Internal function

to_date<-function(x){
  if(all(grepl("\\d{4}-\\d{2}-\\d{2}", x))){
    y<-as.POSIXlt(x, format = "%Y-%m-%dT%H:%M:%S.%OS%z")
  }else{
    y<-x
  }
}

#' @title Function to inform the user about possible error codes
#' @description Internal function show potential error code messages to the user.
#' @param x REST API response status error code.
#' @author Matthias Brenninkmeijer \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Returns a single character string with an error message.
#' @section Warning:
#' Internal function

error_response<-function(x){
  y<-switch(as.character(x),
                     "400"="<Server response error code 400 - Bad Request>",
                     "401"="<Server response error code 401 - Unauthorized>",
                     "402"="<Server response error code 402 - Payment Required>",
                     "403"="<Server response error code 403 - Forbidden>",
                     "404"="<Server response error code 404 - Not Found>",
                     "405"="<Server response error code 405 - Method Not Allowed>",
                     "406"="<Server response error code 406 - Not Acceptable>",
                     "407"="<Server response error code 407 - Proxy Authentication Required>",
                     "408"="<Server response error code 408 - Request Timeout>",
                     "429"="<Server response error code 429 - Too Many Requests>",
                     "500"="<Server response error code 500 - Internal Server Error>",
                     "502"="<Server response error code 502 - Bad Gateway>",
                     "503"="<Server response error code 503 - Service Unavailable>")
  return(y)
}

#' @title Unnest a nested \code{data.frame}
#' @description Unnests/flattens a nested \code{data.frame}
#' @param x A nested \code{data.frame} object
#' @author Matthias Brenninkmeijer - \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Returns a flattened \code{data.frame}.
#' @section Warning:
#' Internal function

unnest_df <- function(x) {
  y <- do.call(data.frame, c(x, list(stringsAsFactors=FALSE)))
  if("data.frame" %in% unlist(lapply(y, class))){
    y<-unnest_df(y)
  }
  return(y)
}

#' @title Retrieves all projects as a \code{data.frame}
#' @description Makes a request to JIRA's latest REST API to retrieve all projects and their basic project information (Name, Key, Id, Description, etc.).
#' @param domain Custom JIRA domain URL as for example \href{https://bitvoodoo.atlassian.net}{https://bitvoodoo.atlassian.net}.
#' @param user Username used to authenticate the access to the JIRA \code{domain}. If both username and password are not passed no authentication is made and only public domains can bet accessed. Optional parameter.
#' @param password Password used to authenticate the access to the JIRA \code{domain}. If both username and password are not passed no authentication is made and only public domains can bet accessed. Optional parameter.
#' @param expand Specific JIRA fields the user wants to obtain for a specific field. Optional parameter.
#' @param verbose Explicitly informs the user of the JIRA API request process.
#' @author Matthias Brenninkmeijer \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Returns a \code{data.frame} with a list of projects for which the user has the BROWSE, ADMINISTER or PROJECT_ADMIN project permission.
#' @seealso For more information about Atlassians JIRA API go to \href{https://docs.atlassian.com/software/jira/docs/api/REST/8.3.3/}{JIRA API Documentation}
#' @examples
#' Projects2R("https://bitvoodoo.atlassian.net")
#' @section Warning:
#' The function works with the JIRA REST API. Thus, to work it needs an internet connection. Calling the function too many times might block your access and you will have to access manually online and enter a CAPTCHA at \href{https://jira.yourdomain.com/secure/Dashboard.jspa}{jira.yourdomain.com/secure/Dashboard.jspa}.
#' @export

Projects2R <- function(domain,
                       user = NULL,
                       password = NULL,
                       expand = NULL,
                       verbose=FALSE){
  if(!is.null(user)&!is.null(password)){
    auth <- httr::authenticate(as.character(user), as.character(password), "basic")
  } else {
    auth <- NULL
  }
  url <- httr::parse_url(domain)
  url<-httr::modify_url(
    url = url,
    scheme = if(is.null(url$scheme)){"https"},
    path = list(type = "rest", call = "api", robust = "latest", kind = "project"),
    query = if(!is.null(expand)){list(expand = conc(expand))}
  )
  call_raw <- httr::GET(url,  encode = "json",  if(verbose){httr::verbose()}, auth, httr::user_agent("github.com/matbmeijer/JirAgileR"))
  if(httr::http_error(call_raw$status_code)){
    stop(error_response(call_raw$status_code))
    }
  if (httr::http_type(call_raw) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }
  call <- jsonlite::fromJSON(httr::content(call_raw, as = "text"), simplifyDataFrame = TRUE)
  df<-unnest_df(call)
  colnames(df) <- gsub("\\.", "_", tolower(colnames(df)))
  return(df)
}

#' @title Retrieves all issues of a JIRA query as a \code{data.frame}
#' @description Calls JIRA's latest REST API, optionally with basic authentication, to get all issues of a JIRA query (JQL). Allows to specify which fields to obtain.
#' @param domain Custom JIRA domain URL as for example \href{https://bitvoodoo.atlassian.net}{https://bitvoodoo.atlassian.net}.
#' @param user Username used to authenticate the access to the JIRA \code{domain}. If both username and password are not passed no authentication is made and only public domains can bet accessed. Optional parameter.
#' @param password Password used to authenticate the access to the JIRA \code{domain}. If both username and password are not passed no authentication is made and only public domains can bet accessed. Optional parameter.
#' @param query JIRA's decoded JQL query. By definition, it works with *Fields*, *Operators*, *Keywords* and *Functions*. To learn how to create a query visit \href{https://confluence.atlassian.com/jirasoftwareserver/advanced-searching-939938733.html}{this ATLASSIAN site}.
#' @param fields Optional argument to define the specific JIRA fields to obtain. If no value is entered, by defualt the following fields are passed:
#' 'status', 'priority', 'created', 'reporter', 'summary', 'description', 'assignee', 'updated', 'issuetype', 'fixVersions'.
#' To obtain a list of all supported fields use the following function: \code{supported_jql_fields()}.
#' @param maxResults Max results authorized to obtain for each API call. By default JIRA sets this value to 50 issues.
#' @param verbose Explicitly informs the user of the JIRA API request process.
#' @param as.data.frame Defines if the function returns a flattened \code{data.frame} or the raw JIRA response.
#' @author Matthias Brenninkmeijer \href{https://github.com/matbmeijer}{Github}
#' @return Returns a flattened, formatted \code{data.frame} with the issues according to the JQL query.
#' @seealso For more information about Atlassians JIRA API visit the following link: \href{https://docs.atlassian.com/software/jira/docs/api/REST/8.3.3/}{JIRA API Documentation}.
#' @examples
#' JiraQuery2R(domain = "https://bitvoodoo.atlassian.net", query = 'project="Congrats for Confluence"')
#' @section Warning:
#' If the \code{comment} field is used as a \code{fields} parameter input, each issue and its attributes are repeated the number of comments the issue has. The function works with the latest JIRA REST API and to work you need to have a internet connection. Calling the function too many times might block your access and you will have to access manually online and enter a CAPTCHA at \href{https://jira.yourdomain.com/secure/Dashboard.jspa}{jira.enterprise.com/secure/Dashboard.jspa}
#' @export

JiraQuery2R <- function(domain,
                        user=NULL,
                        password=NULL,
                        query,
                        fields=basic_jql_fields(),
                        maxResults=50,
                        verbose=FALSE,
                        as.data.frame=TRUE){
  stopifnot(is.character(domain), length(domain) == 1)
  stopifnot(is.character(query), length(query) == 1)

  #Set authenticatión if user and password are passed
  if(!is.null(user)&&!is.null(password)){
    auth <- httr::authenticate(as.character(user), as.character(password), "basic")
  } else {
    auth <- NULL
  }

  #Build URL
  if(!grepl("https|http", domain)){
    url <- httr::parse_url(domain)
    url$hostname<-domain
  } else {
    url <- httr::parse_url(domain)
  }
  url<-httr::modify_url(url = url,
                   scheme = if(is.null(url$scheme)){"https"},
                   path = list(type = "rest", call = "api", robust = "latest", kind = "search"),
                   query=list(jql=query,
                              fields=conc(fields),
                              startAt = "0",
                              maxResults = maxResults)
                   )


  url <- httr::parse_url(url)
  #Prepare for pagination of calls
  if(verbose){message("Preparing for API Calls. Due to pagination this might take a while.")}
  issue_list <- list()
  i <- 0
  repeat{
    url$query$startAt <- 0 + i*50L
    url_b <- httr::build_url(url)
    call_raw <- httr::GET(url_b,  encode = "json", if(verbose){httr::verbose()}, auth, httr::user_agent("github.com/matbmeijer/JirAgileR"))
    if(httr::http_error(call_raw$status_code)){
      stop(error_response(call_raw$status_code))
    }
    if (httr::http_type(call_raw) != "application/json") {
      stop("API did not return json", call. = FALSE)
    }
    call <- jsonlite::fromJSON(httr::content(call_raw, "text"), simplifyVector = FALSE)
    issue_list <- append(issue_list, call$issues)
    i <- i + 1
    if(length(issue_list)== call$total){
      break
    }
  }
  base_info <- basic_issues_info(issue_list)
  ext_info <- lapply(issue_list, `[[`, "fields")
  if(as.data.frame){
    ext_info<-lapply(ext_info, parse_issue)
    ext_info<-data.table::rbindlist(ext_info, fill = TRUE)
    df <- do.call("cbind", list(base_info, ext_info))
  }else{
    df<-list(base_info=base_info, ext_info=ext_info)
  }
  return(df)
}

#' @title Extract the basic key information of the issues
#' @description Internal function to extract the basic key information as a \code{data.frame}.
#' @param x JIRA issue list item.
#' @author Matthias Brenninkmeijer \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Returns \code{data.frame} with basic field information.
#' @section Warning:
#' Internal function

basic_issues_info<-function(x){
  extr_info<-lapply(x, `[`,c("id","self", "key"))
  data.table::rbindlist(extr_info, use.names = TRUE, fill = TRUE)
}

#' @title Extract the extensive fields of a single issue
#' @description Internal function to transform the nested more extensive JIRA issue fields into a flattened \code{data.frame}
#' @param x A JIRA issue with all its extended fields
#' @author Matthias Brenninkmeijer \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Returns \code{data.frame} with all the extended field information.
#' @section Warning:
#' Internal function

parse_issue<-function(x){
  x<-x[lengths(x) != 0]
  available_fields<-names(x)
  res<-lapply(available_fields, function (y) choose_field_function(x, y))
  df<-do.call(cbind, res)
  return(df)
}

#' @title Function to choose for the right field parser function
#' @description Internal function to choose/switch to the correct function to parse each field for each issue
#' @param x The fields nested data to flatten.
#' @param type The fields' name.
#' @author Matthias Brenninkmeijer \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Returns a parsed, cleaned \code{data.frame} with all the fields.
#' @section Warning:
#' Internal function

choose_field_function<-function(x, type){
  y<-switch(type,
            "summary"=summary_field(x),
            "description"=description_field(x),
            "created"=created_field(x),
            "updated"=updated_field(x),
            "issuetype"=issuetype_field(x),
            "creator"=creator_field(x),
            "priority"=priority_field(x),
            "project"=project_field(x),
            "reporter"=reporter_field(x),
            "status"=status_field(x),
            "labels"=labels_field(x),
            "assignee"=assignee_field(x),
            "fixVersions"=fixVersions_field(x),
            "lastViewed"=lastViewed_field(x),
            "resolution"=resolution_field(x),
            "resolutiondate"=resolutiondate_field(x),
            "duedate"=duedate_field(x),
            "votes"=votes_field(x),
            "environment"=environment_field(x),
            "comment"=comment_field(x),
            "components"=components_field(x),
            "issuelinks"=issuelinks_field(x),
            "versions"=versions_field(x),
            "timespent"=timespent_field(x),
            "workratio"=workratio_field(x),
            "progress"=progress_field(x),
            "aggregateprogress"=aggregateprogress_field(x),
            "watches"=watches_field(x),
            "aggregatetimespent"=aggregatetimespent_field(x),
            "aggregatetimeestimate"=aggregatetimeestimate_field(x),
            "timeestimate"=timeestimate_field(x)
  )
  return(y)
}


summary_field<-function(x){
  #Single Variable
  df<-data.frame(summary=x[["summary"]], stringsAsFactors = FALSE)
  return(df)
}

description_field<-function(x){
  #Single Variable
  df<-data.frame(description=x[["description"]], stringsAsFactors = FALSE)
  return(df)
}

environment_field<-function(x){
  #Single Variable
  df<-data.frame(environment=x[["environment"]], stringsAsFactors = FALSE)
  return(df)
}

workratio_field<-function(x){
  #Single Variable
  df<-data.frame(workratio=x[["workratio"]], stringsAsFactors = FALSE)
  return(df)
}

timespent_field<-function(x){
  #Single Variable
  df<-data.frame(timespent=x[["timespent"]], stringsAsFactors = FALSE)
  return(df)
}

aggregatetimespent_field<-function(x){
  #Single Variable
  df<-data.frame(aggregatetimespent=x[["aggregatetimespent"]], stringsAsFactors = FALSE)
  return(df)
}

aggregatetimeestimate_field<-function(x){
  #Single Variable
  df<-data.frame(aggregatetimeestimate=x[["aggregatetimeestimate"]], stringsAsFactors = FALSE)
  return(df)
}

timeestimate_field<-function(x){
  #Single Variable
  df<-data.frame(timeestimate=x[["timeestimate"]], stringsAsFactors = FALSE)
  return(df)
}

duedate_field<-function(x){
  #Single Variable
  df<-data.frame(duedate=as.Date(x[["duedate"]]),stringsAsFactors = FALSE)
  return(df)
}

created_field<-function(x){
  #Single Variable
  df<-data.frame(created=as.POSIXlt(x[["created"]], format = "%Y-%m-%dT%H:%M:%S.%OS%z"),stringsAsFactors = FALSE)
  return(df)
}

updated_field<-function(x){
  #Single Variable
  df<-data.frame(updated=as.POSIXlt(x[["updated"]], format = "%Y-%m-%dT%H:%M:%S.%OS%z"),stringsAsFactors = FALSE)
  return(df)
}

resolutiondate_field<-function(x){
  #Single Variable
  df<-data.frame(resolutiondate=as.POSIXlt(x[["resolutiondate"]], format = "%Y-%m-%dT%H:%M:%S.%OS%z"),stringsAsFactors = FALSE)
  return(df)
}

lastViewed_field<-function(x){
  #Single Variable
  df<-data.frame(lastViewed=as.POSIXlt(x[["lastViewed"]], format = "%Y-%m-%dT%H:%M:%S.%OS%z"),stringsAsFactors = FALSE)
  return(df)
}

issuetype_field<-function(x){
  #Multiple variables
  df<-data.frame(x[["issuetype"]], stringsAsFactors = FALSE)
  colnames(df)<-gsub("\\.", "_", paste0("issuetype_", tolower(colnames(df))))
  return(df)
}

components_field<-function(x){
  #Multiple variables
  df<-data.frame(x[["components"]], stringsAsFactors = FALSE)
  colnames(df)<-gsub("\\.", "_", paste0("components_", tolower(colnames(df))))
  return(df)
}

issuelinks_field<-function(x){
  #Multiple variables
  df<-data.frame(x[["issuelinks"]], stringsAsFactors = FALSE)
  colnames(df)<-gsub("\\.", "_", paste0("issuelinks_", tolower(colnames(df))))
  return(df)
}

versions_field<-function(x){
  #Multiple variables
  df<-data.frame(x[["versions"]], stringsAsFactors = FALSE)
  colnames(df)<-gsub("\\.", "_", paste0("versions_", tolower(colnames(df))))
  return(df)
}

votes_field<-function(x){
  #Multiple variables
  df<-data.frame(x[["votes"]], stringsAsFactors = FALSE)
  colnames(df)<-gsub("\\.", "_", paste0("votes_", tolower(colnames(df))))
  return(df)
}

resolution_field<-function(x){
  #Multiple variables
  df<-data.frame(x[["resolution"]], stringsAsFactors = FALSE)
  colnames(df)<-gsub("\\.", "_", paste0("resolution_", tolower(colnames(df))))
  return(df)
}

creator_field<-function(x){
  #Multiple variables
  df<-data.frame(x[["creator"]], stringsAsFactors = FALSE)
  colnames(df)<-gsub("\\.", "_", paste0("creator_", tolower(colnames(df))))
  return(df)
}

priority_field<-function(x){
  #Multiple variables
  df<-data.frame(x[["priority"]], stringsAsFactors = FALSE)
  colnames(df)<-gsub("\\.", "_", paste0("priority_", tolower(colnames(df))))
  return(df)
}

progress_field<-function(x){
  #Multiple variables
  df<-data.frame(x[["progress"]], stringsAsFactors = FALSE)
  colnames(df)<-gsub("\\.", "_", paste0("progress_", tolower(colnames(df))))
  return(df)
}

aggregateprogress_field<-function(x){
  #Multiple variables
  df<-data.frame(x[["aggregateprogress"]], stringsAsFactors = FALSE)
  colnames(df)<-gsub("\\.", "_", paste0("aggregateprogress_", tolower(colnames(df))))
  return(df)
}

watches_field<-function(x){
  #Multiple variables
  df<-data.frame(x[["watches"]], stringsAsFactors = FALSE)
  colnames(df)<-gsub("\\.", "_", paste0("watches_", tolower(colnames(df))))
  return(df)
}

project_field<-function(x){
  #Multiple variables, nested
  df<-data.frame(x[["project"]], stringsAsFactors = FALSE)
  colnames(df)<-gsub("\\.", "_", paste0("project_", tolower(colnames(df))))
  return(df)
}

assignee_field<-function(x){
  #Multiple variables, nested
  df<-data.frame(x[["assignee"]], stringsAsFactors = FALSE)
  colnames(df)<-gsub("\\.", "_", paste0("assignee_", tolower(colnames(df))))
  return(df)
}

reporter_field<-function(x){
  #Multiple variables, nested
  df<-data.frame(x[["reporter"]], stringsAsFactors = FALSE)
  colnames(df)<-gsub("\\.", "_", paste0("reporter_", tolower(colnames(df))))
  return(df)
}

status_field<-function(x){
  #Multiple variables, nested
  df<-data.frame(x[["status"]], stringsAsFactors = FALSE)
  colnames(df)<-gsub("\\.", "_", paste0("status_", tolower(colnames(df))))
  return(df)
}

labels_field<-function(x){
  #list
  df<-data.frame(labels=conc(unlist(x$labels)), stringsAsFactors = FALSE)
  return(df)
}

fixVersions_field<-function(x){
  #list
  df<-data.frame(x[["fixVersions"]], stringsAsFactors = FALSE)
  colnames(df)<-gsub("\\.", "_", paste0("fixVersions_", tolower(colnames(df))))
  return(df)
}

comment_field<-function(x){
  #nested list
  if(length(x[["comment"]][["comments"]])>0){
    wide<-data.frame(x[["comment"]], stringsAsFactors = FALSE)
    wide_col<-colnames(wide)[!colnames(wide) %in% c("maxResults","total", "startAt")]
    long_col<-gsub("\\.\\d*$","", wide_col, perl = TRUE)
    df<-stats::reshape(wide, direction='long',
                varying=wide_col,
                timevar='var',
                times=1:max(table(long_col)),
                v.names=unique(names(table(long_col))),
                idvar='name')
    rownames(df)<-NULL
    df$var<-NULL
  }else{
    y<-x[["comment"]]
    df<-data.frame(y[lengths(y)>0], stringsAsFactors = FALSE)
  }
  colnames(df)<-gsub("\\.", "_", paste0("comment_", tolower(colnames(df))))
  df<-data.frame(lapply(df, to_date), stringsAsFactors = FALSE)
  return(df)
}
