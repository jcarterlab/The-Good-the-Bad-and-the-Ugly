library(devtools)
library(dplyr)
library(tidyverse)
library(tidyr)
library(tidytext)
library(jsonlite)
library(lubridate)
library(rlang)
library(lexRankr)

# key. 
nyt_key <- "02EVKWAkGy7oFyJtjKgjD847l5K3HpXq"

# terms
terms <- c("patriotism",
           "national identity",
           "partisan politics",
           "political polarization",
           "political divide",
           "political differences",
           "anti-semitism",
           "sexism", 
           "racism", 
           "islamophobia",
           "transphobia",
           "partisanship")

# start/end years. 
start_year <- 2010
end_year <- 2021

# start/end months. 
start_month <- "0101"
end_month <- "1231"

# get multiple start/end dates. 
get_dates <- function(date) {
  dates <- as.character(
    seq(as.numeric(paste0(start_year, date)),
        as.numeric(paste0(end_year, date)), 
        10^4)
  )
  return(dates)
}

# final start/end dates. 
start_dates <- sort(unlist(lapply(start_month, get_dates)))
end_dates <- sort(unlist(lapply(end_month, get_dates)))

# find out how many results are returned for a given year. 
get_data <- function(start_dates, end_dates, terms) {
  url <- paste0("http://api.nytimes.com/svc/search/v2/articlesearch.json?q=%22",
                terms,
                "%22&begin_date=",
                start_dates,
                "&end_date=",
                end_dates,
                "&facet_filter=true&api-key=",
                nyt_key, 
                sep="")
  # query. 
  results_counter <- 1L
  results <- list()
  search <- repeat{try({query <- fromJSON(url, flatten = TRUE)})
    # error handling. 
    if(exists("query")) {
      results <- query
      rm(query)
      break 
    } else {
      if(results_counter <= 45L) {
        message("Re-trying query: attempt ", results_counter, " of 45.")
        results_counter <- results_counter +1L
        Sys.sleep(1)
      } else {
        message("Retry limit reached: initial query unsuccessful.")
        break
      }
    }
  }
  return(results)
}

# cleans and drops unnecessary data points. 
clean_data <- function(start_dates, end_dates, terms) {
  raw_data <- get_data(start_dates, end_dates, terms)
  clean_data <- tibble(hits = raw_data$response$meta$hits)
  return(clean_data)
}

# loops through each start/end date. 
get_start_end_dates <- function(terms) {
  list <- list()
  for(i in 1:length(start_dates)){
    message("Year ", 
            i, 
            " of ", 
            length(start_dates))
    list[[i]] <- tibble(clean_data(start_dates[i], 
                                end_dates[i], 
                                terms)) %>%
      mutate(year = start_dates[i])
    Sys.sleep(5)
  }
  return(list)
}

# combines the results into a single data frame. 
get_combined_dates <- function(terms) {
  country <- get_start_end_dates(terms)
  df <- tibble(rbind_pages(country)) %>%
    mutate(year = as.numeric(substring(year, 1, 4)))
  return(df)
}

# Loops through each of the search terms. 
get_search_terms <- function() {
  terms_list <- list()
  for(i in 1:length(terms)){
    cat("\n")
    message("Term ",
            i, 
            " of ",
            length(terms))
    cat("\n")
    terms_list[[i]] <- get_combined_dates(terms[i]) %>%
      mutate(term = str_replace(terms[i], "%20", " "),
             decade = (floor(year / 10)) * 10)
  }
  return(terms_list)
}

# combines the list into a single data frame. 
final_df <- function() {
  final_object <- tibble(rbind_pages(get_search_terms()))
  return(final_object)
}

# final data frame. 
final_data_frame <- final_df()

# saves the results to a csv file.  
write_csv(final_data_frame, "change_this_name.csv")



