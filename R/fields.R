#' @title Function to choose for the right field parser function
#' @description Internal function to choose/switch to the correct
#' function to parse each field for each issue
#' @param x The fields nested data to flatten.
#' @param type The fields' name.
#' @author Matthias Brenninkmeijer
#' \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Returns a parsed, cleaned \code{data.frame} with all the fields.
#' @section Warning:
#' Internal function

choose_field_function <- function(x, type){
  y <- switch(type,
            "summary" = summary_field(x),
            "description" = description_field(x),
            "created" = created_field(x),
            "updated" = updated_field(x),
            "issuetype" = issuetype_field(x),
            "creator" = creator_field(x),
            "priority" = priority_field(x),
            "project" = project_field(x),
            "reporter" = reporter_field(x),
            "status" = status_field(x),
            "labels" = labels_field(x),
            "assignee" = assignee_field(x),
            "fixVersions" = fixVersions_field(x),
            "lastViewed" = lastViewed_field(x),
            "resolution" = resolution_field(x),
            "resolutiondate" = resolutiondate_field(x),
            "duedate" = duedate_field(x),
            "votes" = votes_field(x),
            "environment" = environment_field(x),
            "comment" = comment_field(x),
            "components" = components_field(x),
            "issuelinks" = issuelinks_field(x),
            "versions" = versions_field(x),
            "timespent" = timespent_field(x),
            "workratio" = workratio_field(x),
            "progress" = progress_field(x),
            "aggregateprogress" = aggregateprogress_field(x),
            "watches" = watches_field(x),
            "aggregatetimespent" = aggregatetimespent_field(x),
            "aggregatetimeestimate" = aggregatetimeestimate_field(x),
            "timeestimate" = timeestimate_field(x),
            "parent" = parent_field(x)
  )
  return(y)
}


summary_field <- function(x){
  #Single Variable
  df <- data.frame(summary=x[["summary"]], stringsAsFactors = FALSE)
  return(df)
}

description_field <- function(x){
  #Single Variable
  df <- data.frame(description=x[["description"]], stringsAsFactors = FALSE)
  return(df)
}

environment_field <- function(x){
  #Single Variable
  df <- data.frame(environment=x[["environment"]], stringsAsFactors = FALSE)
  return(df)
}

workratio_field <- function(x){
  #Single Variable
  df <- data.frame(workratio=x[["workratio"]], stringsAsFactors = FALSE)
  return(df)
}

timespent_field <- function(x){
  #Single Variable
  df <- data.frame(timespent=x[["timespent"]], stringsAsFactors = FALSE)
  return(df)
}

aggregatetimespent_field <- function(x){
  #Single Variable
  df <- data.frame(aggregatetimespent=x[["aggregatetimespent"]], stringsAsFactors = FALSE)
  return(df)
}

aggregatetimeestimate_field <- function(x){
  #Single Variable
  df <- data.frame(aggregatetimeestimate=x[["aggregatetimeestimate"]], stringsAsFactors = FALSE)
  return(df)
}

timeestimate_field <- function(x){
  #Single Variable
  df <- data.frame(timeestimate=x[["timeestimate"]], stringsAsFactors = FALSE)
  return(df)
}

duedate_field <- function(x){
  #Single Variable
  df <- data.frame(duedate=as.Date(x[["duedate"]]),
                 stringsAsFactors = FALSE)
  return(df)
}

created_field <- function(x){
  #Single Variable
  df <- data.frame(created=as.POSIXct(x[["created"]], format = "%Y-%m-%dT%H:%M:%S.%OS%z"),
                 stringsAsFactors = FALSE)
  return(df)
}

updated_field <- function(x){
  #Single Variable
  df <- data.frame(updated=as.POSIXct(x[["updated"]], format = "%Y-%m-%dT%H:%M:%S.%OS%z"),
                 stringsAsFactors = FALSE)
  return(df)
}

resolutiondate_field <- function(x){
  #Single Variable
  df <- data.frame(resolutiondate=as.POSIXct(x[["resolutiondate"]], format = "%Y-%m-%dT%H:%M:%S.%OS%z"),
                 stringsAsFactors = FALSE)
  return(df)
}

lastViewed_field <- function(x){
  #Single Variable
  df <- data.frame(lastViewed=as.POSIXct(x[["lastViewed"]], format = "%Y-%m-%dT%H:%M:%S.%OS%z"),
                 stringsAsFactors = FALSE)
  return(df)
}

issuetype_field<-function(x){
  #Multiple variables
  df <- data.frame(x[["issuetype"]],
                 stringsAsFactors = FALSE)
  colnames(df) <- gsub("\\.", "_", paste0("issuetype_", tolower(colnames(df))))
  return(df)
}

components_field <-function(x){
  #Multiple variables
  df <- data.frame(x[["components"]], stringsAsFactors = FALSE)
  colnames(df) <- gsub("\\.", "_", paste0("components_", tolower(colnames(df))))
  return(df)
}

issuelinks_field <- function(x){
  #Multiple variables
  df <- data.frame(x[["issuelinks"]], stringsAsFactors = FALSE)
  colnames(df) <- gsub("\\.", "_", paste0("issuelinks_", tolower(colnames(df))))
  return(df)
}

versions_field <- function(x){
  #Multiple variables
  df <- data.frame(x[["versions"]], stringsAsFactors = FALSE)
  colnames(df) <- gsub("\\.", "_", paste0("versions_", tolower(colnames(df))))
  return(df)
}

votes_field <- function(x){
  #Multiple variables
  df <- data.frame(x[["votes"]], stringsAsFactors = FALSE)
  colnames(df) <- gsub("\\.", "_", paste0("votes_", tolower(colnames(df))))
  return(df)
}

resolution_field <- function(x){
  #Multiple variables
  df <- data.frame(x[["resolution"]], stringsAsFactors = FALSE)
  colnames(df) <- gsub("\\.", "_", paste0("resolution_", tolower(colnames(df))))
  return(df)
}

creator_field <- function(x){
  #Multiple variables
  df <- data.frame(x[["creator"]], stringsAsFactors = FALSE)
  colnames(df) <- gsub("\\.", "_", paste0("creator_", tolower(colnames(df))))
  return(df)
}

priority_field <- function(x){
  #Multiple variables
  df <- data.frame(x[["priority"]], stringsAsFactors = FALSE)
  colnames(df) <- gsub("\\.", "_", paste0("priority_", tolower(colnames(df))))
  return(df)
}

progress_field <- function(x){
  #Multiple variables
  df <- data.frame(x[["progress"]], stringsAsFactors = FALSE)
  colnames(df) <- gsub("\\.", "_", paste0("progress_", tolower(colnames(df))))
  return(df)
}

aggregateprogress_field <- function(x){
  #Multiple variables
  df <- data.frame(x[["aggregateprogress"]], stringsAsFactors = FALSE)
  colnames(df) <- gsub("\\.", "_", paste0("aggregateprogress_", tolower(colnames(df))))
  return(df)
}

watches_field <- function(x){
  #Multiple variables
  df <- data.frame(x[["watches"]], stringsAsFactors = FALSE)
  colnames(df) <- gsub("\\.", "_", paste0("watches_", tolower(colnames(df))))
  return(df)
}

parent_field <- function(x){
  #Multiple variables
  df <- data.frame(x[["parent"]], stringsAsFactors = FALSE)
  colnames(df) <- gsub("\\.", "_", paste0("parent_", tolower(colnames(df))))
  return(df)
}

project_field <- function(x){
  #Multiple variables, nested
  df <- data.frame(x[["project"]], stringsAsFactors = FALSE)
  colnames(df) <- gsub("\\.", "_", paste0("project_", tolower(colnames(df))))
  return(df)
}

assignee_field <- function(x){
  #Multiple variables, nested
  df <- data.frame(x[["assignee"]], stringsAsFactors = FALSE)
  colnames(df) <- gsub("\\.", "_", paste0("assignee_", tolower(colnames(df))))
  return(df)
}

reporter_field <- function(x){
  #Multiple variables, nested
  df <- data.frame(x[["reporter"]], stringsAsFactors = FALSE)
  colnames(df) <- gsub("\\.", "_", paste0("reporter_", tolower(colnames(df))))
  return(df)
}

status_field <- function(x){
  #Multiple variables, nested
  df <- data.frame(x[["status"]], stringsAsFactors = FALSE)
  colnames(df) <- gsub("\\.", "_", paste0("status_", tolower(colnames(df))))
  return(df)
}

labels_field <- function(x){
  #list
  df <- data.frame(labels=conc(unlist(x$labels)), stringsAsFactors = FALSE)
  return(df)
}

fixVersions_field <- function(x){
  #list
  df <- data.frame(x[["fixVersions"]], stringsAsFactors = FALSE)
  colnames(df) <- gsub("\\.", "_", paste0("fixVersions_", tolower(colnames(df))))
  return(df)
}

comment_field <- function(x){
  #nested list
  if(length(x[["comment"]][["comments"]]) > 0){
    wide <- data.frame(x[["comment"]], stringsAsFactors = FALSE)
    wide_col <- colnames(wide)[!colnames(wide) %in% c("maxResults","total", "startAt")]
    long_col <- gsub("\\.\\d*$","", wide_col, perl = TRUE)
    df <- stats::reshape(wide,
                         direction='long',
                         varying=wide_col,
                         timevar='var',
                         times=1:max(table(long_col)),
                         v.names=unique(names(table(long_col))),
                         idvar='name')
    rownames(df) <- NULL
    df$var <- NULL
  }else{
    y <- x[["comment"]]
    df <- data.frame(y[lengths(y)>0], stringsAsFactors = FALSE)
  }
  colnames(df) <- gsub("\\.", "_", paste0("comment_", tolower(colnames(df))))
  df <- data.frame(lapply(df, to_date), stringsAsFactors = FALSE)
  return(df)
}
