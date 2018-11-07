#' @title Obtain project issues as \code{df}
#' @description Calls JIRA's v2 Rest API with basic authentication to get all issues of a JIRA project.
#' @param dn Custom JIRA domain URL as for example \href{https://bitvoodoo.atlassian.net}{https://bitvoodoo.atlassian.net}
#' @param user Username used to authenticate access to JIRA your domain. If no username and password is given no authentication is made.
#' @param password Password used to authenticate access to JIRA domain. If no username and password is given no authentication is made.
#' @param project Exact name of the JIRA project e.g. 'Package Development'.
#' @param search Currently defaults to \code{"name"}. In future the objective is to be able to search by name and ID of the project or even single issue.
#' @author Matthias Brenninkmeijer \href{https://github.com/matbmeijer}{Github}
#' @return Returns a formatted \code{data.frame} with all issues as rows and with the default columns 'Key', 'Status', 'Version', 'Assignee_Name', 'Assignee_Email', 'Description', 'Created', 'Updated', 'Summary', 'Priority' and 'Type'.
#' @seealso For more information about Atlassians JIRA API go to \href{https://docs.atlassian.com/software/jira/docs/api/REST/7.6.1/}{https://docs.atlassian.com/software/jira/docs/api/REST/7.6.1/}
#' @examples
#' Project2R("https://bitvoodoo.atlassian.net", project="Congrats for Confluence", search="name")
#' @section Warning:
#' The function works with the JIRA REST v2 API and to workyou need to have a internet connection. Calling the function too many times might block your access and you will have to access manually online and enter a CAPTCHA at \href{https://jira.yourdomain.com/secure/Dashboard.jspa}{jira.enterprise.com/secure/Dashboard.jspa}
#' @export

Project2R <- function(dn, user=NULL, password=NULL, project, search="name"){
  i <- 0L
  l <- 1L
  info_message <- " call to JIRA REST API executing. Due to download size calls may take a while."
  jira_rest <- "/rest/api/2/search?jql=project="
  jira_fields <- "&fields=fixVersions,status,assignee,description,created,updated,summary,issuetype,priority"
  authentication <- NULL
  if(!is.null(user)&!is.null(password)){
    authentication <- httr::authenticate(as.character(user), as.character(password), "basic")
  }
  if(search=="name"){
    first_api_url <- paste0(gsub("/$", "", dn), jira_rest, "\"", utils::URLencode(project),"\"", "&startAt=", i, "&maxResults=50",jira_fields)
    message(paste0(l, info_message))
    first_api_call <- httr::GET(first_api_url, encode = "json", authentication)
    jira_raw <- httr::content(first_api_call, as = "parsed")
    issue_n <- jira_raw$startAt + length(jira_raw$issues)
    jira_result<-list(jira_raw)
    while(issue_n!=jira_raw$total){
      i <- i+50L
      foll_api_url<- paste0(gsub("/$", "", dn), jira_rest, "\"", utils::URLencode(project), "\"", "&startAt=", i, "&maxResults=50",jira_fields)
      l <- l + 1L
      message(paste0(l, info_message))
      foll_api_call <- httr::GET(foll_api_url, encode = "json", authentication)
      jira_raw <- httr::content(foll_api_call, as = "parsed")
      issue_n <- jira_raw$startAt + length(jira_raw$issues)
      jira_result<-append(jira_result,list(jira_raw))
    }
  }
  jira_result<-lapply(jira_result,"[[","issues")
  jira_result<-unlist(jira_result, recursive = F)
  df<-lapply(jira_result, function(x) data.frame(
    Key=ifelse(!is.null(x[["key"]]),x[["key"]], NA),
    Status=ifelse(!is.null(x[["fields"]][["status"]][["name"]]),x[["fields"]][["status"]][["name"]], NA),
    Version=ifelse(!!length(x[["fields"]][["fixVersions"]]),x[["fields"]][["fixVersions"]][[1]][["name"]], NA),
    Assignee_Name=ifelse(!is.null(x[["fields"]][["assignee"]][["displayName"]]),x[["fields"]][["assignee"]][["displayName"]], NA),
    Assignee_Email=ifelse(!is.null(x[["fields"]][["assignee"]][["emailAddress"]]),x[["fields"]][["assignee"]][["emailAddress"]], NA),
    Description=ifelse(!is.null(x[["fields"]][["description"]]),x[["fields"]][["description"]], NA),
    Created=as.Date(ifelse(!is.null(x[["fields"]][["created"]]),x[["fields"]][["created"]], NA)),
    Updated=as.Date(ifelse(!is.null(x[["fields"]][["udpated"]]),x[["fields"]][["updated"]], NA)),
    Summary=ifelse(!is.null(x[["fields"]][["summary"]]),x[["fields"]][["summary"]], NA),
    Priority=ifelse(!is.null(x[["fields"]][["priority"]]),x[["fields"]][["priority"]], NA),
    Type=ifelse(!is.null(x[["fields"]][["issuetype"]][["name"]]),x[["fields"]][["issuetype"]][["name"]], NA)
    , stringsAsFactors = F)
  )
  if(requireNamespace("data.table", quietly=TRUE)){
    ##only load really necessary packages
    df<-data.table::rbindlist(df)
  }else{
    df <- do.call("rbind", df)
  }
  return(df)
}

