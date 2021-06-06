#' @title Retrieves the previously saved JIRA credentials
#' @description Retrieves a \code{data.frame} with the JIRA credentials
#' previously saved into the environment under the JIRAGILER_PAT variable
#' through the \code{save_jira_credentials()} function.
#' @return Returns a \code{data.frame} with the saved JIRA credentials
#' @examples
#' \dontrun{
#' save_jira_credentials(domain="https://bugreports.qt.io",
#'                       username='__INSERT_YOUR_USERNAME_HERE__',
#'                       password='__INSERT_YOUR_PASSWORD_HERE__')
#' get_jira_credentials()
#' }
#' @export

get_jira_credentials <- function(){
  info <- Sys.getenv("JIRAGILER_PAT",NA)
  if(!is.na(info)){
    mt <- matrix( strsplit(info, split = ";")[[1]], nrow = 2)
    info <- data.frame(t(mt[2,]), stringsAsFactors = FALSE)
    colnames(info) <- mt[1,]
  }else{
    info <- NULL
  }
  return(info)
}

#' @title Removes previously saved JIRA credentials
#' @description Removes the JIRA credentials, that have been previously
#' saved into the environment under the JIRAGILER_PAT variable through
#' the \code{save_jira_credentials()} function.
#' @param verbose Optional parameter to remove previously saved parameters
#' @return Returns a \code{data.frame} with the saved JIRA credentials
#' @examples
#' \dontrun{
#' save_jira_credentials(domain="https://bugreports.qt.io")
#' remove_jira_credentials()
#' }
#' @export


remove_jira_credentials <- function(verbose=FALSE){
  Sys.unsetenv("JIRAGILER_PAT")
  if(verbose){ cat("The JIRA credentials have been removed.") }
}

#' @title Saves domain and the domain's credentials in the environment
#' @description Saves the domain and/or username and password in
#' the users' environment. It has the advantage that it is not necessary
#' to explicitly publish the credentials in the users code. Just do it one
#' time and you are set. To update any of the parameters just save again and
#' it will overwrite the older credential.
#' @param domain The users' JIRA server domain to retrieve information from.
#' An example would be \href{https://bugreports.qt.io}{https://bugreports.qt.io}.
#' It will be saved in the environment as JIRAGILER_DOMAIN.
#' @param username The users' username to authenticate to the \code{domain}.
#' It will be saved in the environment as JIRAGILER_USERNAME.
#' @param password The users' password to authenticate to the \code{domain}.
#' It will be saved in the environment as JIRAGILER_PASSWORD. If \code{verbose}
#' is set to \code{TRUE}, it will message asterisks.
#' @param verbose Optional parameter to inform the user when the users'
#' credentials have been saved.
#' @return Saves the credentials in the users environment - it does not return any object.
#' @examples
#' \dontrun{
#' save_jira_credentials(domain="https://bugreports.qt.io",
#'                       username='__INSERT_YOUR_USERNAME_HERE__',
#'                       password='__INSERT_YOUR_PASSWORD_HERE__')
#' }
#' @export

save_jira_credentials <- function(domain=NULL,
                                  username=NULL,
                                  password=NULL,
                                  verbose=FALSE){
  if(is.null(c(domain, username, password))){
    stop(call. = FALSE,
         "At least the domain or both the username and password must be informed.")
  }
  if(!is.null(domain)){
    env_name <- sprintf("DOMAIN;%s", domain)
  }
  if(!is.null(username) && !is.null(password)){
    env_name <- paste0(env_name, ";", sprintf("USERNAME;%s", username))
    env_name <- paste0(env_name, ";", sprintf("PASSWORD;%s", password))
  }else if(length(c(username, password)) == 1){
    stop(call. = FALSE,
         "Both username and password must be informed to save credentials to be able to authenticate.")
  }
  Sys.setenv("JIRAGILER_PAT" = env_name)
  if(verbose){
    df <- get_jira_credentials()
    cat(sprintf("<The following credentials have been saved in the environment>\n%s",
                gsub("PASSWORD = .*$","PASSWORD = ********",
                     paste0(sprintf("%s = %s", colnames(df), df[1,]), collapse = "\n"))))
  }
}


#' @title Returns the supported JQL fields
#' @description Function shows all the supported JQL fields that are
#' available to choose for the \code{get_jira_issues()} function.
#' @return Returns a character vector of all the supported JQL fields.
#' @export

supported_jql_fields <- function(){
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
      "workratio",
      "parent"))}


#' @title Retrieves all projects as a \code{data.frame}
#' @description Makes a request to JIRA's latest REST API to
#' retrieve all projects and their basic project information
#' (Name, Key, Id, Description, etc.).
#' @param domain Custom JIRA domain URL as for example \href{https://bugreports.qt.io}{https://bugreports.qt.io}.
#'  Can be passed as a parameter or can be previously defined
#'  through the \code{save_jira_credentials()} function.
#' @param username Username used to authenticate the access to the JIRA \code{domain}.
#' If both username and password are not passed no authentication is made and
#' only public domains can bet accessed. Optional parameter.
#' @param password Password used to authenticate the access
#' to the JIRA \code{domain}. If both username and password are not
#' passed no authentication is made and
#' only public domains can bet accessed. Optional parameter.
#' @param expand Specific JIRA fields the user wants to obtain for a specific field. Optional parameter.
#' @param verbose Explicitly informs the user of the JIRA API request process.
#' @return Returns a \code{data.frame} with a list of projects for which the user has the BROWSE,
#' ADMINISTER or PROJECT_ADMIN project permission.
#' @seealso For more information about Atlassians JIRA API go
#' to \href{https://docs.atlassian.com/software/jira/docs/api/REST/8.9.1/}{JIRA API Documentation}
#' @examples
#' \dontrun{
#' get_jira_projects("https://bugreports.qt.io")
#' }
#' @section Warning:
#' The function works with the latest JIRA REST API and to work you need
#'  to have a internet connection. Calling the function too many times
#'  might block your access, you will receive a 403 error code. To unblock
#'  your access you will have to access interactively through your browser,
#'   signing out and signing in again, and might even have to enter a
#'   CAPTCHA at https://jira.yourdomain.com/secure/Dashboard.jspa.
#'   This only happens if the API is called upon multiple
#'   times in a short period of time.
#' @export

get_jira_projects <- function(domain = NULL,
                              username = NULL,
                              password = NULL,
                              expand = NULL,
                              verbose=FALSE){
  credentials <- get_jira_credentials()
  if(is.null(domain) && !is.null(credentials)){
    domain <- credentials$DOMAIN
    username <- credentials$USERNAME
    password <- credentials$PASSWORD
  } else if(!is.character(domain) || length(domain) != 1){
    stop(call. = FALSE,
         "Domain is an obligatory parameter.
         No domain saved in credentials and no domain passed as parameter.")
  }
  if(!is.null(username) && !is.null(password)){
    auth <- httr::authenticate(as.character(username), as.character(password), "basic")
  } else {
    auth <- NULL
  }
  url <- httr::parse_url(domain)
  url <- httr::modify_url(
    url = url,
    scheme = if(is.null(url$scheme)){"https"},
    path = adapt_list(url$path, c("rest", "api", "latest", "project")),
    query = if(!is.null(expand)){list(expand = conc(expand))}
  )
  call_raw <- httr::GET(url,
                        encode = "json",
                        if(verbose){httr::verbose()},
                        auth,
                        httr::user_agent("github.com/matbmeijer/JirAgileR"))
  if(httr::http_error(call_raw$status_code)){
    stop(sprintf("Error Code %s - %s",
                 call_raw$status_code,
                 httr::http_status(call_raw$status_code)$message),
         call. = FALSE)
  }
  if (httr::http_type(call_raw) != "application/json") {
    stop(call. = FALSE, "API did not return json")
  }
  call <- jsonlite::fromJSON(httr::content(call_raw, as = "text"), simplifyDataFrame = TRUE)
  df <- unnest_df(call)
  return(df)
}

#' @title Get the JIRA server information as a \code{data.frame}
#' @description Makes a request to JIRA's latest REST API to retrieve all
#' the necessary information regarding the JIRA server version.
#' @param domain Custom JIRA domain URL as for
#' example \href{https://bugreports.qt.io}{https://bugreports.qt.io}.
#' Can be passed as a parameter or can be previously defined through
#'  the \code{save_jira_credentials()} function.
#' @param username Username used to authenticate the access to the JIRA \code{domain}.
#' If both username and password are not passed no authentication is made and only
#'  public domains can bet accessed. Optional parameter.
#' @param password Password used to authenticate the access to the JIRA \code{domain}.
#' If both username and password are not passed no authentication is made and only
#'  public domains can bet accessed. Optional parameter.
#' @param verbose Explicitly informs the user of the JIRA API request process.
#' @return Returns a \code{data.frame} with all the JIRA server information
#' @seealso For more information about Atlassians JIRA API go
#' to \href{https://docs.atlassian.com/software/jira/docs/api/REST/8.9.1/}{JIRA API Documentation}
#' @examples
#' \dontrun{
#' get_jira_server_info("https://bugreports.qt.io")
#' }
#' @section Warning:
#' The function works with the latest JIRA REST API and to work you need to have
#' a internet connection. Calling the function too many times might block your
#' access, you will receive a 403 error code. To unblock your access you will
#' have to access interactively through your browser, signing out and signing
#' in again, and might even have to enter a CAPTCHA at https://jira.yourdomain.com/secure/Dashboard.jspa.
#' This only happens if the API is called upon multiple times in a short period of time.
#' @export

get_jira_server_info <- function(domain=NULL, username=NULL, password=NULL, verbose=FALSE){
  credentials <- get_jira_credentials()
  if(is.null(domain) && !is.null(credentials)){
    domain<-credentials$DOMAIN
    username<-credentials$USERNAME
    password<-credentials$PASSWORD
  } else if(!is.character(domain) || length(domain) != 1){
    stop(call. = FALSE,
         "Domain is an obligatory parameter.
         No domain saved in credentials and no domain passed as parameter.")
  }
  if(!is.null(username) && !is.null(password)){
    auth <- httr::authenticate(as.character(username), as.character(password), "basic")
  } else {
    auth <- NULL
  }
  url <- httr::parse_url(domain)
  url<-httr::modify_url(
    url = url,
    scheme = if(is.null(url$scheme)){"https"},
    path = adapt_list(url$path, c("rest", "api", "latest", "serverInfo"))
  )
  request <- httr::GET(url,
                       encode = "json",
                       if(verbose){httr::verbose()},
                       auth,
                       httr::user_agent("github.com/matbmeijer/JirAgileR"))
  if(httr::http_error(request$status_code)){
    stop(sprintf("Error Code %s - %s",
                 request$status_code,
                 httr::http_status(request$status_code)$message),
         call. = FALSE)
  }
  if (httr::http_type(request) != "application/json") {
    stop(call. = FALSE, "API did not return json")
  }
  call<-jsonlite::fromJSON(httr::content(request, as = "text"))
  call$versionNumbers<- paste0(call$versionNumbers, collapse = ".")
  call$buildDate<- as.POSIXct(call$buildDate, format = "%Y-%m-%dT%H:%M:%S.%OS%z")
  df <- data.frame(call, stringsAsFactors = FALSE)
  return(df)
}

#' @title Get all the JIRA server permissions as a \code{data.frame}
#' @description Makes a request to JIRA's latest REST API to retrieve the users' permissions.
#' @param domain Custom JIRA domain URL as for
#' example \href{https://bugreports.qt.io}{https://bugreports.qt.io}. Can be passed
#' as a parameter or can be previously defined through the \code{save_jira_credentials()} function.
#' @param username Username used to authenticate the access to the JIRA \code{domain}.
#' If both username and password are not passed no authentication is made
#' and only public domains can bet accessed. Optional parameter.
#' @param password Password used to authenticate the access to the JIRA \code{domain}.
#' If both username and password are not passed no authentication is made
#' and only public domains can bet accessed. Optional parameter.
#' @param verbose Explicitly informs the user of the JIRA API request process.
#' @return Returns a \code{data.frame} with all the JIRA user permissions.
#' @seealso For more information about Atlassians JIRA API
#' go to \href{https://docs.atlassian.com/software/jira/docs/api/REST/8.9.1/}{JIRA API Documentation}
#' @examples
#' \dontrun{
#' get_jira_permissions("https://bugreports.qt.io")
#' }
#' @section Warning:
#' The function works with the latest JIRA REST API and to work you need to have
#' a internet connection. Calling the function too many times might block your access,
#' you will receive a 403 error code. To unblock your access you will have to access
#' interactively through your browser, signing out and signing in again, and might
#' even have to enter a CAPTCHA at https://jira.yourdomain.com/secure/Dashboard.jspa.
#' This only happens if the API is called upon multiple times in a short period of time.
#' @export

get_jira_permissions <- function(domain = NULL,
                                 username = NULL,
                                 password = NULL,
                                 verbose=FALSE){
  credentials<-get_jira_credentials()
  if(is.null(domain) && !is.null(credentials)){
    domain<-credentials$DOMAIN
    username<-credentials$USERNAME
    password<-credentials$PASSWORD
  } else if(!is.character(domain) || length(domain) != 1){
    stop(call. = FALSE,
         "Domain is an obligatory parameter.
         No domain saved in credentials and no domain passed as parameter.")
  }
  if(!is.null(username) && !is.null(password)){
    auth <- httr::authenticate(as.character(username), as.character(password), "basic")
  } else {
    auth <- NULL
  }
  url <- httr::parse_url(domain)
  url<-httr::modify_url(
    url = url,
    scheme = if(is.null(url$scheme)){"https"},
    path = adapt_list(url$path, c("rest", "api", "latest", "mypermissions"))
  )
  call_raw <- httr::GET(url,
                        encode = "json",
                        if(verbose){httr::verbose()},
                        auth,
                        httr::user_agent("github.com/matbmeijer/JirAgileR"))
  if(httr::http_error(call_raw$status_code)){
    stop(sprintf("Error Code %s - %s",
                 call_raw$status_code,
                 httr::http_status(call_raw$status_code)$message),
         call. = FALSE)
  }
  if (httr::http_type(call_raw) != "application/json") {
    stop(call. = FALSE, "API did not return json")
  }
  call <- jsonlite::fromJSON(httr::content(call_raw, as = "text"), simplifyDataFrame = TRUE)
  df <- lapply(call$permissions, data.frame, stringsAsFactors = FALSE)
  df <- rbind_fill(df)
  return(df)
}

#' @title Get JIRA server groups \code{data.frame}
#' @description Makes a request to JIRA's latest REST API to retrieve all the groups in JIRA.
#' @param domain Custom JIRA domain URL as for example
#' \href{https://bugreports.qt.io}{https://bugreports.qt.io}. Can be passed
#' as a parameter or can be previously defined through the \code{save_jira_credentials()} function.
#' @param username Username used to authenticate the access to the JIRA \code{domain}.
#'  If both username and password are not passed no authentication is made and only
#'   public domains can bet accessed. Optional parameter.
#' @param password Password used to authenticate the access to the JIRA \code{domain}.
#'  If both username and password are not passed no authentication is made and only
#'  public domains can bet accessed. Optional parameter.
#' @param maxResults Number of maximum groups to return. Set by default to \code{1000}.
#' @param verbose Explicitly informs the user of the JIRA API request process.
#' @return Returns a \code{data.frame} with all the JIRA groups
#' @seealso For more information about Atlassians JIRA API go
#' to \href{https://docs.atlassian.com/software/jira/docs/api/REST/8.9.1/}{JIRA API Documentation}
#' @examples
#' \dontrun{
#' get_jira_groups("https://bugreports.qt.io")
#' }
#' @section Warning:
#' The function works with the latest JIRA REST API and to work you need to have a
#' internet connection. Calling the function too many times might block your access,
#' you will receive a 403 error code. To unblock your access you will have to access
#' interactively through your browser, signing out and signing in again, and might
#' even have to enter a CAPTCHA at https://jira.yourdomain.com/secure/Dashboard.jspa.
#' This only happens if the API is called upon multiple times in a short period of time.
#' @export

get_jira_groups <- function(domain=NULL,
                            username=NULL,
                            password=NULL,
                            verbose=FALSE,
                            maxResults=1000){
  credentials <- get_jira_credentials()
  if(is.null(domain) && !is.null(credentials)){
    domain<-credentials$DOMAIN
    username<-credentials$USERNAME
    password<-credentials$PASSWORD
  } else if(!is.character(domain) || length(domain) != 1){
    stop(call. = FALSE,
         "Domain is an obligatory parameter.
         No domain saved in credentials and no domain passed as parameter.")
  }
  if(!is.null(username) && !is.null(password)){
    auth <- httr::authenticate(as.character(username), as.character(password), "basic")
  } else {
    auth <- NULL
  }
  url <- httr::parse_url(domain)
  url<-httr::modify_url(
    url = url,
    scheme = if(is.null(url$scheme)){"https"},
    path = adapt_list(url$path, c("rest", "api", "latest", "groups", "picker")),
    query =list(maxResults = maxResults)
  )
  request <- httr::GET(url,
                       encode = "json",
                       if(verbose){httr::verbose()},
                       auth,
                       httr::user_agent("github.com/matbmeijer/JirAgileR"))
  if(httr::http_error(request$status_code)){
    stop(sprintf("Error Code %s - %s",
                 request$status_code,
                 httr::http_status(request$status_code)$message),
         call. = FALSE)
  }
  if (httr::http_type(request) != "application/json") {
    stop(call. = FALSE, "API did not return json")
  }
  call<-jsonlite::fromJSON(httr::content(request, as = "text"))

  call$groups$labels <- unlist(lapply(call$groups$labels, paste0, collapse=", "), use.names = FALSE)
  call$groups$labels[call$groups$labels == ""]<-NA
  df <- call$groups
  if(is.null(nrow(df))){
    df <- data.frame(df)
  }
  return(df)
}


#' @title Retrieves all issues of a JIRA query as a \code{data.frame}
#' @description Calls JIRA's latest REST API, optionally with basic authentication,
#'  to get all issues of a JIRA query (JQL). Allows to specify which fields to obtain.
#' @param domain Custom JIRA domain URL as for example
#' \href{https://bugreports.qt.io}{https://bugreports.qt.io}. Can be passed as a
#' parameter or can be previously defined through the \code{save_jira_credentials()} function.
#' @param username Username used to authenticate the access to the JIRA \code{domain}.
#'  If both username and password are not passed no authentication is made and only
#'   public domains can bet accessed. Optional parameter.
#' @param password Password used to authenticate the access to the JIRA \code{domain}.
#'  If both username and password are not passed no authentication is made and only
#'   public domains can bet accessed. Optional parameter.
#' @param jql_query JIRA's decoded JQL query. By definition, it works with:
#' \itemize{
#' \item Fields
#' \item Operators
#' \item Keywords
#' \item Functions
#' }
#' To learn how to create a query visit
#' \href{https://confluence.atlassian.com/jirasoftwareserver/advanced-searching-939938733.html}{this ATLASSIAN site}
#' or the following \href{https://3kllhk1ibq34qk6sp3bhtox1-wpengine.netdna-ssl.com/wp-content/uploads/2017/12/atlassian-jql-cheat-sheet-2.pdf}{cheatsheet}.
#' @param fields Optional argument to define the specific JIRA fields to obtain.
#'  If no value is entered, by default the following fields are passed:
#' \itemize{
#' \item status
#' \item priority
#' \item created
#' \item reporter
#' \item summary
#' \item description
#' \item assignee
#' \item updated
#' \item issuetype
#' \item fixVersions
#' }
#' To obtain a list of all supported fields use the following function: \code{supported_jql_fields()}.
#' @param maxResults Max results authorized to obtain for each API call. By default JIRA sets this value to 50 issues.
#' @param verbose Explicitly informs the user of the JIRA API request process.
#' @param as.data.frame Defines if the function returns a flattened \code{data.frame} or the raw JIRA response.
#' @return Returns a flattened, formatted \code{data.frame} with the issues according to the JQL query.
#' @seealso For more information about Atlassians JIRA API visit the following link:
#' \href{https://docs.atlassian.com/software/jira/docs/api/REST/8.9.1/}{JIRA API Documentation}.
#' @examples
#' get_jira_issues(domain = "https://bugreports.qt.io",
#'                 jql_query = 'project="QTWB"')
#' @section Warning:
#' If the \code{comment} field is used as a \code{fields} parameter input, each issue and its
#' attributes are repeated the number of comments the issue has. The function works with the
#'  latest JIRA REST API and to work you need to have a internet connection. Calling the function
#'  too many times might block your access, you will receive a 403 error code. To unblock your
#'  access you will have to access interactively through your browser, signing out and signing
#'  in again, and might even have to enter a CAPTCHA at
#'  https://jira.yourdomain.com/secure/Dashboard.jspa. This only happens if the API
#'  is called upon multiple times in a short period of time.
#' @export

get_jira_issues <- function(domain=NULL,
                            username=NULL,
                            password=NULL,
                            jql_query,
                            fields=basic_jql_fields(),
                            maxResults=50,
                            verbose=FALSE,
                            as.data.frame=TRUE){
  credentials<-get_jira_credentials()
  if(is.null(domain) && !is.null(credentials)){
    domain<-credentials$DOMAIN
    username<-credentials$USERNAME
    password<-credentials$PASSWORD
  } else if(!is.character(domain) ||length(domain) != 1){
    stop(call. = FALSE,
         "Domain is an obligatory parameter.
         No domain saved in credentials and no domain passed as parameter.")
  }

  #Set authentication if username and password are passed
  if(!is.null(username)&&!is.null(password)){
    auth <- httr::authenticate(as.character(username), as.character(password), "basic")
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
                        path = adapt_list(url$path, c("rest", "api", "latest", "search")),
                        query=list(jql=jql_query,
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
    url$query$startAt <- length(issue_list)
    url_b <- httr::build_url(url)
    call_raw <- httr::GET(url_b,
                          encode = "json",
                          if(verbose){httr::verbose()},
                          auth,
                          httr::user_agent("github.com/matbmeijer/JirAgileR"))
    if(httr::http_error(call_raw$status_code)){
      stop(sprintf("Error Code %s - %s",
                   call_raw$status_code,
                   httr::http_status(call_raw$status_code)$message),
           call. = FALSE)
    }
    if (httr::http_type(call_raw) != "application/json") {
      stop(call. = FALSE, "API did not return json")
    }
    call <- jsonlite::fromJSON(httr::content(call_raw, "text"), simplifyVector = FALSE)
    issue_list <- append(issue_list, call$issues)
    i <- i + 1
    if(length(issue_list)== call$total){
      break
    }
  }
  if(length(issue_list) == 0){
    return(stats::setNames(data.frame(matrix(ncol = length(fields), nrow = 0)), fields))
  }
  base_info <- basic_issues_info(issue_list)
  ext_info <- lapply(issue_list, `[[`, "fields")
  if(as.data.frame){
    ext_info<-lapply(seq_along(ext_info), function(x) parse_issue(issue = ext_info[[x]], JirAgileR_id = x))
    ext_info<-rbind_fill(ext_info)
    df <- merge(base_info, ext_info,by="JirAgileR_id", all=TRUE)
    df[["JirAgileR_id"]]<-NULL
  }else{
    df<-list(base_info=base_info, ext_info=ext_info)
  }
  return(df)
}

#' @title Retrieves all dashboards a \code{data.frame}
#' @description Calls JIRA's latest REST API, optionally with
#'  basic authentication, to get all dashboards
#' @param domain Custom JIRA domain URL as for example
#' \href{https://bugreports.qt.io}{https://bugreports.qt.io}. Can be passed as a parameter
#'  or can be previously defined through the \code{save_jira_credentials()} function.
#' @param username Username used to authenticate the access to the JIRA \code{domain}.
#' If both username and password are not passed no authentication is made and only
#' public domains can bet accessed. Optional parameter.
#' @param password Password used to authenticate the access to the JIRA \code{domain}.
#' If both username and password are not passed no authentication is made and only
#' public domains can bet accessed. Optional parameter.
#' @param maxResults Max results authorized to obtain for each API call. By default
#' JIRA sets this value to 20 issues.
#' @param verbose Explicitly informs the user of the JIRA API request process.
#' @return Returns a flattened, formatted \code{data.frame} with the dashboards in the domain.
#' @seealso For more information about Atlassians JIRA API visit the following link:
#' \href{https://docs.atlassian.com/software/jira/docs/api/REST/8.9.1/}{JIRA API Documentation}.
#' @examples
#' get_jira_dashboards(domain = "https://bugreports.qt.io")
#' @export

get_jira_dashboards <- function(domain=NULL,
                                username=NULL,
                                password=NULL,
                                maxResults=20L,
                                verbose=FALSE){
  credentials <- get_jira_credentials()
  if(is.null(domain) && !all(is.na(credentials))){
    domain <- credentials$DOMAIN
    username <- credentials$USERNAME
    password <- credentials$PASSWORD
  } else if(!is.character(domain) ||length(domain) != 1){
    stop(call. = FALSE,
         "Domain is an obligatory parameter.
         No domain saved in credentials and no domain passed as parameter.")
  }

  #Set authentication if username and password are passed
  if(!is.null(username) && !is.null(password)){
    auth <- httr::authenticate(as.character(username), as.character(password), "basic")
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
                        path = adapt_list(url$path, c("rest", "api",  "latest", "dashboard")),
                        query=list(startAt = "0",
                                   maxResults = maxResults))
  url <- httr::parse_url(url)
  #Prepare for pagination of calls
  if(verbose){message("Preparing for API Calls. Due to pagination this might take a while.")}
  issue_list <- list()
  i <- 0
  repeat{
    url$query$startAt <- 0 + i*maxResults
    url_b <- httr::build_url(url)
    call_raw <- httr::GET(url_b,
                          encode = "json",
                          if(verbose){httr::verbose()},
                          auth,
                          httr::user_agent("github.com/matbmeijer/JirAgileR"))
    if(httr::http_error(call_raw$status_code)){
      stop(sprintf("Error Code %s - %s",
                   call_raw$status_code,
                   httr::http_status(call_raw$status_code)$message),
           call. = FALSE)
    }
    if (httr::http_type(call_raw) != "application/json") {
      stop(call. = FALSE, "API did not return json")
    }
    call <- jsonlite::fromJSON(httr::content(call_raw, "text"), simplifyVector = TRUE)
    issue_list <- append(issue_list, list(call$dashboards))
    i <- i + 1
    if(length(issue_list)== ceiling(call$total/maxResults)){
      break
    }
  }
  df <- do.call(rbind, issue_list)
  return(df)
}

