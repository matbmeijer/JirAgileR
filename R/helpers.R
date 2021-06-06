#' @title Extract the basic key information of the issues
#' @description Internal function to extract the basic key information
#' as a \code{data.frame}.
#' @param x JIRA issue list item.
#' @return Returns \code{data.frame} with basic field information.
#' @section Warning:
#' Internal function

basic_issues_info <- function(x){
  extr_info <- lapply(x, `[`,c("id","self", "key"))
  extr_info <- lapply(extr_info, data.frame, stringsAsFactors = FALSE)
  df <- do.call(rbind, extr_info)
  df[["JirAgileR_id"]] <- seq_along(extr_info)
  return(df)
}

#' @title Extract the extensive fields of a single issue
#' @description Internal function to transform the nested more extensive
#' JIRA issue fields into a flattened \code{data.frame}
#' @param issue A JIRA issue with all its extended fields
#' @param JirAgileR_id JirAgileR ID to assign to
#' @return Returns \code{data.frame} with all the extended field information.
#' @section Warning:
#' Internal function

parse_issue <- function(issue, JirAgileR_id){
  issue<-issue[lengths(issue) != 0]
  ## parse known fields
  available_fields <- intersect(names(issue), supported_jql_fields())
  res <- lapply(available_fields, function (y) choose_field_function(issue, y))
  ## keep custom fields as is
  for (customfield in grep('^customfield', names(issue), value = TRUE)) {
    res[[customfield]] <- issue[[customfield]]
  }
  id <- data.frame("JirAgileR_id"=JirAgileR_id, stringsAsFactors = FALSE)
  df <- do.call(cbind, res)
  if(!is.null(df) && length(df)>0){
    df <- cbind(data.frame("JirAgileR_id"=JirAgileR_id), df)
  }else{
    df <- data.frame("JirAgileR_id" = JirAgileR_id)
  }
  return(df)
}

#' @title Returns default JQL fields used
#' @description Internal function used to define the default JQL
#' fields used for the \code{get_jira_issues()} function.
#' @return Returns a \code{character} vector with the default JQL fields.
#' @section Warning:
#' Internal function

basic_jql_fields <- function(){
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
#' @description Internal function with an opinionated
#' default behavior to concatenate character values.
#' @param x A single character vector to concatenate together.
#' @param y By default a \code{,} string used to define the character
#'  to collapse the \code{x} parameter.
#' @param decr Optional logical parameter that defines the sorting order,
#' by default set to \code{FALSE}, which results in an alphabetical order.
#' @param unique Optional logical parameter to concatenate only
#' unique values, by default set to \code{TRUE}
#' @return Returns a single character string.
#' @section Warning:
#' Internal function

conc <- function(x, y=",", decr=FALSE, unique=TRUE){
  x <- sort(unique(x), decreasing = decr)
  return(paste0(x, collapse = y))
}

#' @title Transforms JIRA date character to POSIXlt format
#' @description Internal function to parse the date from JIRA character vectors.
#' @param x Character vector to transform into a \code{POSIXlt}.
#' @return Returns a \code{POSIXlt} object vector.
#' @section Warning:
#' Internal function

to_date <- function(x){
  if(all(grepl("\\d{4}-\\d{2}-\\d{2}", x))){
    x <- as.POSIXct(x, format = "%Y-%m-%dT%H:%M:%S.%OS%z")
  }
  return(x)
}

#' @title Unnest a nested \code{data.frame}
#' @description Unnests/flattens a nested \code{data.frame}
#' @param x A nested \code{data.frame} object
#' @return Returns a flattened \code{data.frame}.
#' @section Warning:
#' Internal function

unnest_df <- function(x) {
  y <- do.call(data.frame, c(x, list(stringsAsFactors=FALSE)))
  if("data.frame" %in% unlist(lapply(y, class))){
    y <- unnest_df(y)
  }
  colnames(y) <- gsub("\\.", "_", tolower(colnames(y)))
  return(y)
}

#' @title Adapt the path of class \code{url}
#' @description Adapt the path of class \code{url} to consider the old path when modifying
#' @param old_path Passed path in parameter \code{domain}
#' @param path Path of API endpoint
#' @return Returns a vector of the resulting path.
#' @section Warning:
#' Internal function

adapt_list <- function(old_path, path){
  if(old_path!=""){
    path <- c(old_path, path)
  }
  return(path)
}


fill_df_NAs <- function(x, cols, classes){
  x_cols <- names(x)
  miss_cols <- setdiff(cols, x_cols)
  x[,miss_cols] <- NA
  x <- x[,cols]
  x[] <- lapply(cols, function(y) x[,y] <- transform_class(x[,y], classes[[y]]))
  x <- x[,cols]
  return(x)
}

rbind_fill <- function(l){
  r <- unique(unlist(lapply(l, nrow)))
  l <- l[r>0]
  names(l) <- NULL
  cols <- unique(unlist(lapply(l, colnames)))
  classes <- unlist(
    rapply(l, class, classes = "ANY", how = "list"), recursive = FALSE)
  classes <- lapply(cols, function(x) classes[[x]])
  names(classes) <- cols
  res <- do.call(rbind, lapply(l, fill_df_NAs, cols, classes))
  return(res)
}



transform_class <- function(x, class){
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
