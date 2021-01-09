#' @title Retrieves the previously saved JIRA credentials
#' @description Retrieves a \code{data.frame} with the JIRA credentials previously saved into the environment under the JIRAGILER_PAT variable through the \code{save_jira_credentials()} function.
#' @return Returns a \code{data.frame} with the saved JIRA credentials
#' @author Matthias Brenninkmeijer - \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @examples
#' \dontrun{
#' save_jira_credentials(domain="https://bitvoodoo.atlassian.net",
#'                       username='__INSERT_YOUR_USERNAME_HERE__',
#'                       password='__INSERT_YOUR_PASSWORD_HERE__')
#' get_jira_credentials()
#' }
#' @export

get_jira_credentials<-function(){
  info<-Sys.getenv("JIRAGILER_PAT",NA)
  if(!is.na(info)){
    mt<-matrix( strsplit(info, split = ";")[[1]], nrow = 2)
    info<-data.frame(t(mt[2,]), stringsAsFactors = FALSE)
    colnames(info)<-mt[1,]
  }
  return(info)
}

#' @title Removes previously saved JIRA credentials
#' @description Removes the JIRA credentials, that have been previously saved into the environment under the JIRAGILER_PAT variable through the \code{save_jira_credentials()} function.
#' @param verbose Optional parameter to remove previously saved parameters
#' @return Returns a \code{data.frame} with the saved JIRA credentials
#' @author Matthias Brenninkmeijer - \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @examples
#' \dontrun{
#' save_jira_credentials(domain="https://bitvoodoo.atlassian.net")
#' remove_jira_credentials()
#' }
#' @export


remove_jira_credentials<-function(verbose=FALSE){
  Sys.unsetenv("JIRAGILER_PAT")
  if(verbose){cat("The JIRA credentials have been removed.")}
}

#' @title Saves domain and the domain's credentidals in the environment
#' @description Saves the domain and/or username and password in the users' environment. It has the advantage that it is not necessary to explicitly publish the credentials in the users code. Just do it one time and you are set. To update any of the parameters just save again and it will overwrite the older credential.
#' @param domain The users' JIRA server domain to retrieve information from. An example would be \href{https://bitvoodoo.atlassian.net}{}. It will be saved in the environment as JIRAGILER_DOMAIN.
#' @param username The users' username to authenticate to the \code{domain}. It will be saved in the environment as JIRAGILER_USERNAME.
#' @param password The users' password to authenticate to the \code{domain}. It will be saved in the environment as JIRAGILER_PASSWORD. If \code{verbose} is set to \code{TRUE}, it will message asterisks.
#' @param verbose Optional parameter to inform the user when the users' crendentials have been saved.
#' @return Saves the credentials in the users environment - it does not return any object.
#' @author Matthias Brenninkmeijer - \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @examples
#' \dontrun{
#' save_jira_credentials(domain="https://bitvoodoo.atlassian.net",
#'                       username='__INSERT_YOUR_USERNAME_HERE__',
#'                       password='__INSERT_YOUR_PASSWORD_HERE__')
#' }
#' @export

save_jira_credentials <-function(domain=NULL, username=NULL, password=NULL, verbose=FALSE){
  if(is.null(c(domain, username, password))){
    stop(call. = FALSE, "At least the domain or both the username and password must be informed.")
  }
  if(!is.null(domain)){
    env_name<-sprintf("DOMAIN;%s", domain)
  }
  if(!is.null(username) && !is.null(password)){
    env_name<-paste0(env_name,";", sprintf("USERNAME;%s", username))
    env_name<-paste0(env_name,";", sprintf("PASSWORD;%s", password))
  }else if(length(c(username, password))==1){
    stop(call. = FALSE, "Both username and password must be informed to save credentials to be able to authenticate.")
  }
  Sys.setenv("JIRAGILER_PAT"=env_name)
  if(verbose){
    df<-get_jira_credentials()
    cat(sprintf("<The following credentials have been saved in the environment>\n%s",
    gsub("PASSWORD = .*$","PASSWORD = ********", paste0(sprintf("%s = %s", colnames(df), df[1,]), collapse = "\n"))))
  }
}


#' @title Returns the supported JQL fields
#' @description Function shows all the supported JQL fields that are available to choose for the \code{get_jira_issues()} function.
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
      "workratio",
      "parent"))}

#' @title Returns default JQL fields used
#' @description Internal function used to define the default JQL fields used for the \code{get_jira_issues()} function.
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
    y<-as.POSIXct(x, format = "%Y-%m-%dT%H:%M:%S.%OS%z")
  }else{
    y<-x
  }
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
  colnames(y) <- gsub("\\.", "_", tolower(colnames(y)))
  return(y)
}

#' @title Retrieves all projects as a \code{data.frame}
#' @description Makes a request to JIRA's latest REST API to retrieve all projects and their basic project information (Name, Key, Id, Description, etc.).
#' @param domain Custom JIRA domain URL as for example \href{https://bitvoodoo.atlassian.net}{https://bitvoodoo.atlassian.net}. Can be passed as a parameter or can be previously defined through the \code{save_jira_credentials()} function.
#' @param username Username used to authenticate the access to the JIRA \code{domain}. If both username and password are not passed no authentication is made and only public domains can bet accessed. Optional parameter.
#' @param password Password used to authenticate the access to the JIRA \code{domain}. If both username and password are not passed no authentication is made and only public domains can bet accessed. Optional parameter.
#' @param expand Specific JIRA fields the user wants to obtain for a specific field. Optional parameter.
#' @param verbose Explicitly informs the user of the JIRA API request process.
#' @author Matthias Brenninkmeijer \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Returns a \code{data.frame} with a list of projects for which the user has the BROWSE, ADMINISTER or PROJECT_ADMIN project permission.
#' @seealso For more information about Atlassians JIRA API go to \href{https://docs.atlassian.com/software/jira/docs/api/REST/8.3.3/}{JIRA API Documentation}
#' @examples
#' \dontrun{
#' get_jira_projects("https://bitvoodoo.atlassian.net")
#' }
#' @section Warning:
#' The function works with the latest JIRA REST API and to work you need to have a internet connection. Calling the function too many times might block your access, you will receive a 403 error code. To unblock your access you will have to access interactively through your browser, signing out and signing in again, and might even have to enter a CAPTCHA at \href{https://jira.yourdomain.com/secure/Dashboard.jspa}{jira.enterprise.com/secure/Dashboard.jspa}. This only happens if the API is called upon multiple times in a short period of time.
#' @export

get_jira_projects <- function(domain = NULL,
                       username = NULL,
                       password = NULL,
                       expand = NULL,
                       verbose=FALSE){
  credentials<-get_jira_credentials()
  if(is.null(domain) && !all(is.na(credentials))){
    domain<-credentials$DOMAIN
    username<-credentials$USERNAME
    password<-credentials$PASSWORD
  } else if(!is.character(domain) || length(domain) != 1){
    stop(call. = FALSE, "Domain is an obligatory parameter. No domain saved in credentials and no domain passed as parameter.")
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
    path = list(type = "rest", call = "api", robust = "latest", kind = "project"),
    query = if(!is.null(expand)){list(expand = conc(expand))}
  )
  call_raw <- httr::GET(url,  encode = "json",  if(verbose){httr::verbose()}, auth, httr::user_agent("github.com/matbmeijer/JirAgileR"))
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
  df<-unnest_df(call)
  return(df)
}

#' @title Get the JIRA server information as a \code{data.frame}
#' @description Makes a request to JIRA's latest REST API to retrieve all the necessary information regarding the JIRA server version.
#' @param domain Custom JIRA domain URL as for example \href{https://bitvoodoo.atlassian.net}{https://bitvoodoo.atlassian.net}. Can be passed as a parameter or can be previously defined through the \code{save_jira_credentials()} function.
#' @param username Username used to authenticate the access to the JIRA \code{domain}. If both username and password are not passed no authentication is made and only public domains can bet accessed. Optional parameter.
#' @param password Password used to authenticate the access to the JIRA \code{domain}. If both username and password are not passed no authentication is made and only public domains can bet accessed. Optional parameter.
#' @param verbose Explicitly informs the user of the JIRA API request process.
#' @author Matthias Brenninkmeijer \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Returns a \code{data.frame} with all the JIRA server information
#' @seealso For more information about Atlassians JIRA API go to \href{https://docs.atlassian.com/software/jira/docs/api/REST/8.3.3/}{JIRA API Documentation}
#' @examples
#' \dontrun{
#' get_jira_server_info("https://bitvoodoo.atlassian.net")
#' }
#' @section Warning:
#' The function works with the latest JIRA REST API and to work you need to have a internet connection. Calling the function too many times might block your access, you will receive a 403 error code. To unblock your access you will have to access interactively through your browser, signing out and signing in again, and might even have to enter a CAPTCHA at \href{https://jira.yourdomain.com/secure/Dashboard.jspa}{jira.enterprise.com/secure/Dashboard.jspa}. This only happens if the API is called upon multiple times in a short period of time.
#' @export

get_jira_server_info <- function(domain=NULL, username=NULL, password=NULL, verbose=FALSE){
  credentials<-get_jira_credentials()
  if(is.null(domain) && !all(is.na(credentials))){
    domain<-credentials$DOMAIN
    username<-credentials$USERNAME
    password<-credentials$PASSWORD
  } else if(!is.character(domain) || length(domain) != 1){
    stop(call. = FALSE, "Domain is an obligatory parameter. No domain saved in credentials and no domain passed as parameter.")
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
    path = list(type = "rest", call = "api", robust = "latest", kind = "serverInfo")
  )
  request <- httr::GET(url,  encode = "json",  if(verbose){httr::verbose()}, auth, httr::user_agent("github.com/matbmeijer/JirAgileR"))
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
#' @param domain Custom JIRA domain URL as for example \href{https://bitvoodoo.atlassian.net}{https://bitvoodoo.atlassian.net}. Can be passed as a parameter or can be previously defined through the \code{save_jira_credentials()} function.
#' @param username Username used to authenticate the access to the JIRA \code{domain}. If both username and password are not passed no authentication is made and only public domains can bet accessed. Optional parameter.
#' @param password Password used to authenticate the access to the JIRA \code{domain}. If both username and password are not passed no authentication is made and only public domains can bet accessed. Optional parameter.
#' @param verbose Explicitly informs the user of the JIRA API request process.
#' @author Matthias Brenninkmeijer \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Returns a \code{data.frame} with all the JIRA user permissions.
#' @seealso For more information about Atlassians JIRA API go to \href{https://docs.atlassian.com/software/jira/docs/api/REST/8.3.3/}{JIRA API Documentation}
#' @examples
#' \dontrun{
#' get_jira_permissions("https://jira.hyperledger.org")
#' }
#' @section Warning:
#' The function works with the latest JIRA REST API and to work you need to have a internet connection. Calling the function too many times might block your access, you will receive a 403 error code. To unblock your access you will have to access interactively through your browser, signing out and signing in again, and might even have to enter a CAPTCHA at \href{https://jira.yourdomain.com/secure/Dashboard.jspa}{jira.enterprise.com/secure/Dashboard.jspa}. This only happens if the API is called upon multiple times in a short period of time.
#' @export

get_jira_permissions <- function(domain = NULL,
                                 username = NULL,
                                 password = NULL,
                                 verbose=FALSE){
  credentials<-get_jira_credentials()
  if(is.null(domain) && !all(is.na(credentials))){
    domain<-credentials$DOMAIN
    username<-credentials$USERNAME
    password<-credentials$PASSWORD
  } else if(!is.character(domain) || length(domain) != 1){
    stop(call. = FALSE, "Domain is an obligatory parameter. No domain saved in credentials and no domain passed as parameter.")
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
    path = list(type = "rest", call = "api", robust = "latest", kind = "mypermissions")
  )
  call_raw <- httr::GET(url,  encode = "json",  if(verbose){httr::verbose()}, auth, httr::user_agent("github.com/matbmeijer/JirAgileR"))
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
#' @param domain Custom JIRA domain URL as for example \href{https://bitvoodoo.atlassian.net}{https://bitvoodoo.atlassian.net}. Can be passed as a parameter or can be previously defined through the \code{save_jira_credentials()} function.
#' @param username Username used to authenticate the access to the JIRA \code{domain}. If both username and password are not passed no authentication is made and only public domains can bet accessed. Optional parameter.
#' @param password Password used to authenticate the access to the JIRA \code{domain}. If both username and password are not passed no authentication is made and only public domains can bet accessed. Optional parameter.
#' @param maxResults Number of maximum groups to return. Set by default to \code{1000}.
#' @param verbose Explicitly informs the user of the JIRA API request process.
#' @author Matthias Brenninkmeijer \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Returns a \code{data.frame} with all the JIRA groups
#' @seealso For more information about Atlassians JIRA API go to \href{https://docs.atlassian.com/software/jira/docs/api/REST/8.3.3/}{JIRA API Documentation}
#' @examples
#' \dontrun{
#' get_jira_groups("https://bitvoodoo.atlassian.net")
#' }
#' @section Warning:
#' The function works with the latest JIRA REST API and to work you need to have a internet connection. Calling the function too many times might block your access, you will receive a 403 error code. To unblock your access you will have to access interactively through your browser, signing out and signing in again, and might even have to enter a CAPTCHA at \href{https://jira.yourdomain.com/secure/Dashboard.jspa}{jira.enterprise.com/secure/Dashboard.jspa}. This only happens if the API is called upon multiple times in a short period of time.
#' @export

get_jira_groups <- function(domain=NULL, username=NULL, password=NULL, verbose=FALSE, maxResults=1000){
  credentials<-get_jira_credentials()
  if(is.null(domain) && !all(is.na(credentials))){
    domain<-credentials$DOMAIN
    username<-credentials$USERNAME
    password<-credentials$PASSWORD
  } else if(!is.character(domain) || length(domain) != 1){
    stop(call. = FALSE, "Domain is an obligatory parameter. No domain saved in credentials and no domain passed as parameter.")
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
    path = list(type = "rest", call = "api", robust = "latest", kind = "groups", detail="picker"),
    query =list(maxResults = maxResults)
  )
  request <- httr::GET(url,  encode = "json",  if(verbose){httr::verbose()}, auth, httr::user_agent("github.com/matbmeijer/JirAgileR"))
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
  return(df)
}


#' @title Retrieves all issues of a JIRA query as a \code{data.frame}
#' @description Calls JIRA's latest REST API, optionally with basic authentication, to get all issues of a JIRA query (JQL). Allows to specify which fields to obtain.
#' @param domain Custom JIRA domain URL as for example \href{https://bitvoodoo.atlassian.net}{https://bitvoodoo.atlassian.net}. Can be passed as a parameter or can be previously defined through the \code{save_jira_credentials()} function.
#' @param username Username used to authenticate the access to the JIRA \code{domain}. If both username and password are not passed no authentication is made and only public domains can bet accessed. Optional parameter.
#' @param password Password used to authenticate the access to the JIRA \code{domain}. If both username and password are not passed no authentication is made and only public domains can bet accessed. Optional parameter.
#' @param jql_query JIRA's decoded JQL query. By definition, it works with:
#' \itemize{
#' \item Fields
#' \item Operators
#' \item Keywords
#' \item Functions
#' }
#' To learn how to create a query visit \href{https://confluence.atlassian.com/jirasoftwareserver/advanced-searching-939938733.html}{this ATLASSIAN site} or the following \href{https://3kllhk1ibq34qk6sp3bhtox1-wpengine.netdna-ssl.com/wp-content/uploads/2017/12/atlassian-jql-cheat-sheet-2.pdf}{cheatsheet}.
#' @param fields Optional argument to define the specific JIRA fields to obtain. If no value is entered, by defualt the following fields are passed:
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
#' @author Matthias Brenninkmeijer \href{https://github.com/matbmeijer}{Github}
#' @return Returns a flattened, formatted \code{data.frame} with the issues according to the JQL query.
#' @seealso For more information about Atlassians JIRA API visit the following link: \href{https://docs.atlassian.com/software/jira/docs/api/REST/8.3.3/}{JIRA API Documentation}.
#' @examples
#' get_jira_issues(domain = "https://bitvoodoo.atlassian.net",
#'                 jql_query = 'project="Congrats for Confluence"')
#' @section Warning:
#' If the \code{comment} field is used as a \code{fields} parameter input, each issue and its attributes are repeated the number of comments the issue has. The function works with the latest JIRA REST API and to work you need to have a internet connection. Calling the function too many times might block your access, you will receive a 403 error code. To unblock your access you will have to access interactively through your browser, signing out and signing in again, and might even have to enter a CAPTCHA at \href{https://jira.yourdomain.com/secure/Dashboard.jspa}{jira.enterprise.com/secure/Dashboard.jspa}. This only happens if the API is called upon multiple times in a short period of time.
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
  if(is.null(domain) && !all(is.na(credentials))){
    domain<-credentials$DOMAIN
    username<-credentials$USERNAME
    password<-credentials$PASSWORD
  } else if(!is.character(domain) ||length(domain) != 1){
    stop(call. = FALSE, "Domain is an obligatory parameter. No domain saved in credentials and no domain passed as parameter.")
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
                   path = list(type = "rest", call = "api", robust = "latest", kind = "search"),
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
    call_raw <- httr::GET(url_b,  encode = "json", if(verbose){httr::verbose()}, auth, httr::user_agent("github.com/matbmeijer/JirAgileR"))
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

#' @title Extract the basic key information of the issues
#' @description Internal function to extract the basic key information as a \code{data.frame}.
#' @param x JIRA issue list item.
#' @author Matthias Brenninkmeijer \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Returns \code{data.frame} with basic field information.
#' @section Warning:
#' Internal function

basic_issues_info<-function(x){
  extr_info<-lapply(x, `[`,c("id","self", "key"))
  extr_info<-lapply(extr_info, data.frame, stringsAsFactors = FALSE)
  df<-do.call(rbind, extr_info)
  df[["JirAgileR_id"]]<-seq_along(extr_info)
  return(df)
}

#' @title Extract the extensive fields of a single issue
#' @description Internal function to transform the nested more extensive JIRA issue fields into a flattened \code{data.frame}
#' @param issue A JIRA issue with all its extended fields
#' @param JirAgileR_id JirAgiler ID to assign to
#' @author Matthias Brenninkmeijer \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Returns \code{data.frame} with all the extended field information.
#' @section Warning:
#' Internal function

parse_issue<-function(issue, JirAgileR_id){
  issue<-issue[lengths(issue) != 0]
  available_fields<-names(issue)
  res<-lapply(available_fields, function (y) choose_field_function(issue, y))
  id<-data.frame("JirAgileR_id"=JirAgileR_id, stringsAsFactors = FALSE)
  df<-do.call(cbind, res)
  if(!is.null(df) && length(df)>0){
    df<-cbind(data.frame("JirAgileR_id"=JirAgileR_id), df)
  }else{
    df<-data.frame("JirAgileR_id"=JirAgileR_id)
  }
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
            "timeestimate"=timeestimate_field(x),
            "parent"=parent_field(x)
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
  df<-data.frame(created=as.POSIXct(x[["created"]], format = "%Y-%m-%dT%H:%M:%S.%OS%z"),stringsAsFactors = FALSE)
  return(df)
}

updated_field<-function(x){
  #Single Variable
  df<-data.frame(updated=as.POSIXct(x[["updated"]], format = "%Y-%m-%dT%H:%M:%S.%OS%z"),stringsAsFactors = FALSE)
  return(df)
}

resolutiondate_field<-function(x){
  #Single Variable
  df<-data.frame(resolutiondate=as.POSIXct(x[["resolutiondate"]], format = "%Y-%m-%dT%H:%M:%S.%OS%z"),stringsAsFactors = FALSE)
  return(df)
}

lastViewed_field<-function(x){
  #Single Variable
  df<-data.frame(lastViewed=as.POSIXct(x[["lastViewed"]], format = "%Y-%m-%dT%H:%M:%S.%OS%z"),stringsAsFactors = FALSE)
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

parent_field<-function(x){
  #Multiple variables
  df<-data.frame(x[["parent"]], stringsAsFactors = FALSE)
  colnames(df)<-gsub("\\.", "_", paste0("parent_", tolower(colnames(df))))
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


fill_df_NAs<-function(x, cols, classes){
  x_cols <- names(x)
  miss_cols <- setdiff(cols, x_cols)
  x[,miss_cols] <- NA
  x <- x[,cols]
  x[]<-lapply(cols, function(y) x[,y]<-transform_class(x[,y], classes[[y]]))
  x <- x[,cols]
  return(x)
}

rbind_fill<-function(l){
  r<-unique(unlist(lapply(l, nrow)))
  l<-l[r>0]
  names(l)<-NULL
  cols <- unique(unlist(lapply(l, colnames)))
  classes <- unlist(rapply(l, class, classes = "ANY", how = "list"), recursive = FALSE)
  classes <- lapply(cols, function(x) classes[[x]])
  names(classes) <- cols
  res <- do.call(rbind, lapply(l, fill_df_NAs, cols, classes))
  return(res)
}



transform_class<- function(x, class){
  y <- switch(class[1],
              "character"=as.character(x),
              "logical"=as.logical(x),
              "Date"=as.Date(x, origin="1970-01-01"),
              "integer"=as.integer(x),
              "numeric"=as.numeric(x),
              "POSIXct"=as.POSIXct(x, origin="1970-01-01"),
              "POSIXt"=as.POSIXct(x, origin="1970-01-01"),
              "factor"=as.factor(x))
  return(y)
}
