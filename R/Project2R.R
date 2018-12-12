JiraJSON2df<-function(x, fields){
  df<-list()
  if(is.null(names(x))){
    x <- unlist(x, recursive = F, use.names = T)
  }
  for(field in fields){
    if(!is.recursive(x[[field]])|length(x[[field]]) == 0){
      if(is.null(x[[field]]) | length(x[[field]])==0){
        y <- NA
      }
      else if(grepl("^\\d{4}(-\\d\\d){2}",x[[field]])){
        y <- as.Date(x[[field]])
      } else {
        y <- as.character(x[[field]])
      }
      df[[field]] <- data.frame(y, stringsAsFactors = F)
      colnames(df[[field]]) <- field
    } else if(field %in% c("reporter", "assignee", "creator")){
      df[[field]] <- data.frame(DisplayName = x[[field]]["displayName"], Name = x[[field]]["name"], EmailAddress = x[[field]]["displayName"], stringsAsFactors = F)
    } else if(field %in% c("priority","resolution", "issuetype", "status", "project")){
      df[[field]] <- data.frame(x[[field]]["name"], stringsAsFactors = F)
      colnames(df[[field]])<-field
    } else {
      df[[field]] <- data.frame(paste0(sort(unlist(x[[field]])), collapse = ", "), stringsAsFactors = F)
      colnames(df[[field]])<-field
    }
  }
  df<-do.call("cbind",df)
  colnames(df) <- gsub("\\.", " ", colnames(df))
  return(df)
}


#' @title Obtain all projects as a \code{data.frame}
#' @description Calls JIRA's latest REST API to obtain all the basic project information (Name, Key, Id, Description, etc.)
#' @param domain Custom JIRA domain URL as for example \href{https://bitvoodoo.atlassian.net}{https://bitvoodoo.atlassian.net}
#' @param user Username used to authenticate access to JIRA your domain. If both username and password are not passed no authentication is made and only public domains can bet accesed. Optional parameter.
#' @param password Password used to authenticate access to JIRA your domain. If both username and password are not passed no authentication is made and only public domains can bet accesed. Optional parameter.
#' @param expand Specific JIRA fields the user wants to obtain for a specific field. Optional parameter. By default
#' @author Matthias Brenninkmeijer \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Returns a \code{data.frame} with a list of projects for which the user has the BROWSE, ADMINISTER or PROJECT_ADMIN project permission.
#' @seealso For more information about Atlassians JIRA API go to \href{https://docs.atlassian.com/software/jira/docs/api/REST/7.6.1/}{JIRA API Documentation}
#' @examples
#' Projects2R("https://bitvoodoo.atlassian.net")
#' @section Warning:
#' The function works with the JIRA REST API. Thus, to work it needs a internet connection. Calling the function too many times might block your access and you will have to access manually online and enter a CAPTCHA at \href{https://jira.yourdomain.com/secure/Dashboard.jspa}{jira.yourdomain.com/secure/Dashboard.jspa}
#' @export

Projects2R <- function(domain, user = NULL, password = NULL, expand = NULL){
  if(!is.null(user)&!is.null(password)){
    auth <- httr::authenticate(as.character(user), as.character(password), "basic")
  } else {
    auth <- NULL
  }

  url <- httr::parse_url(domain)
  url$scheme <- "https"
  url$path <- list(type = "rest", call = "api", robust = "latest", kind = "project")
  if(!is.null(expand)){
    url$query <- list(expand = paste0(expand, collapse = ","))
  }
  url <- httr::build_url(url)

  call <- httr::GET(url,  encode = "json", auth, httr::progress(), httr::verbose(), httr::user_agent("github.com/matbmeijer/JirAgileR"))
  call_prs <- httr::content(call, as = "parsed")
  call_l<-lapply(call_prs, data.frame, stringsAsFactors=F)
  df<-data.table::rbindlist(call_l, fill = T, use.names = T)
  colnames(df) <- gsub("\\.", " ", colnames(df))
  return(df)
}

#' @title Obtain all issues of a JIRA query as a \code{data.frame}
#' @description Calls JIRA's latest REST API, optionally with basic authentication, to get all issues of a JIRA query (JQL). Allows to specify which fields to obtain.
#' @param domain Custom JIRA domain URL as for example \href{https://bitvoodoo.atlassian.net}{https://bitvoodoo.atlassian.net}.
#' @param user Username used to authenticate access to JIRA your domain. If both username and password are not passed no authentication is made and only public domains can bet accesed.
#' @param password Password used to authenticate access to JIRA your domain. If both username and password are not passed no authentication is made and only public domains can bet accesed.
#' @param query JIRA's decoded JQL query. By definition, it works with with **Fields**, **Operators**, **Keywords** and **Functions**. To learn how to create a query visit \href{https://confluence.atlassian.com/jirasoftwareserver/advanced-searching-939938733.html}{this ATLASSIAN site}.
#' @param fields Optional argument to define the specific JIRA fields to obtain. If no value is entered, by defualt the following fields are passed: 'status','priority','created','reporter','summary','description','assignee','updated','issuetype','fixVersions'.
#' @param maxResults Max results authorized to obtain for each API call. By default JIRA sets this value to 50 issues.
#' @author Matthias Brenninkmeijer \href{https://github.com/matbmeijer}{Github}
#' @return Returns a formatted \code{data.frame} with the issues according to the JQL query.
#' @seealso For more information about Atlassians JIRA API visit the following link: \href{https://docs.atlassian.com/software/jira/docs/api/REST/7.6.1/}{https://docs.atlassian.com/software/jira/docs/api/REST/7.6.1/}.
#' @examples
#' JiraQuery2R(domain = "https://bitvoodoo.atlassian.net", query = 'project="Congrats for Confluence"')
#' @section Warning:
#' The function works with the JIRA REST v2 API and to workyou need to have a internet connection. Calling the function too many times might block your access and you will have to access manually online and enter a CAPTCHA at \href{https://jira.yourdomain.com/secure/Dashboard.jspa}{jira.enterprise.com/secure/Dashboard.jspa}
#' @export


JiraQuery2R <- function(domain, user=NULL, password=NULL, query, fields = NULL, maxResults=NULL){
  #Set authenticatión if user and password are passed
  if(!is.null(user)&!is.null(password)){
    auth <- httr::authenticate(as.character(user), as.character(password), "basic")
  } else {
    auth <- NULL
  }
  #Set default fields to expand for if no fields are passed
  if(is.null(fields)){
    fields <- c("status","priority","created","reporter","summary","description","assignee","updated","issuetype","fixVersions")
  }

  #Set default value for maxResults - eliminate?
  if(is.null(maxResults)){
    max_issues<-50
  } else {
    max_issues<-maxResults
  }

  #Build URL
  url <- httr::parse_url(domain)
  url$scheme <- "https"
  url$path <- list(type = "rest", call = "api", robust = "latest", kind = "search")
  url$query <- list(jql=query, fields=paste0(fields, collapse = ","), startAt = "0", maxResults =max_issues)
  url_b <- httr::build_url(url)

  #Prepare for pagination of calls
  message("Preparing for API Calls. Due to pagination this might take a while.")
  issue_list <- list()
  i <- 0
  while(
    if(exists("call_prs")){
      length(issue_list) != call_prs$total
      }  else {
        TRUE
      }){
    url$query$startAt <- 0 + i*50L
    url_b <- httr::build_url(url)
    call <- httr::GET(url_b,  encode = "json", auth, httr::progress(), httr::verbose(), httr::user_agent("github.com/matbmeijer/JirAgileR"))
    call_prs <- httr::content(call, as = "parsed")
    issue_list <- append(issue_list, call_prs$issues)
    i <- i + 1
  }
  base_info <- do.call("rbind", lapply(issue_list, function(x) data.frame(t(unlist(x[c("id","key", "self")])), stringsAsFactors = F)))
  ext_info <- lapply(issue_list, `[[`, "fields")
  ext_info <- lapply(ext_info, JiraJSON2df, fields)
  ext_info <- data.table::rbindlist(ext_info, fill = T)
  df <- do.call("cbind", list(base_info, ext_info))
  return(df)
}
