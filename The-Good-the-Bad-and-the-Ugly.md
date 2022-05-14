The Good, the Bad and the Ugly
================
Jack Carter
18/04/2022

## **Summary**

This project uses the number of articles containing certain terms to
show how the conversation in The New York Times (NYT) changed following
the 2016 election of Donald Trump. Just like the characters in Clint
Eastwood’s famous spaghetti western, the election elicited rhetoric
indicating good (a heightened national belonging for many (albeit mostly
white) citizens), bad (political polarization), and ugly (social
discrimination) changes in Trump’s America.

 

## 1\) The Good

![](The-Good-the-Bad-and-the-Ugly_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

## 2\) The Bad

![](The-Good-the-Bad-and-the-Ugly_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

## 3\) The Ugly

![](The-Good-the-Bad-and-the-Ugly_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

 

## **Disclaimer**

The data above show only relative changes in the number of articles for
each term between 2011 and 2022, not how many times a term appeared
overall or the context in which it was used. This means any conclusions
we make about good, bad and ugly changes in Trump’s America are only
assumptions, not necessarily facts.

 

## **Method**

### **1) Choose Terms:**

The terms were selected on the basis of trial and error in an attempt to
find underlying trends in the data during Trump’s presidency. The table
below details the number of articles for each term between 2011 and
2022.

**Terms (articles in 000s)**

| Anti-Semitism | Islamophobia | National Identity | Partisan Politics | Partisanship | Patriotism | Political Differences | Political Divide | Political Polarization | Racism | Sexism | Transphobia |
| ------------: | -----------: | ----------------: | ----------------: | -----------: | ---------: | --------------------: | ---------------: | ---------------------: | -----: | -----: | ----------: |
|          2.72 |         0.59 |              1.28 |               0.8 |         2.34 |       2.65 |                  0.44 |              0.5 |                   0.56 |  14.08 |   3.15 |        0.15 |

 

### **2) Data Collection:**

The data were collected using an API call from the New York Times. A
repeat try loop is used to ensure the full data are collected even if
the connection drops out on a particular call.

—EXAMPLE CODE SNIPET—

``` r
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
```

 

### **3) Z-score Transformation:**

The number of articles is converted to each term’s z-score. This allows
us to view the term’s relative distribution over time. It is calculated
as 1) the number of articles less the term’s mean, 2) divided by the
term’s standard deviation.

—EXAMPLE CODE SNIPET—

``` r
# gets the z-score for each term. 
get_z_score <- function(data) {
  mean <- mean(data)
  sigma <- sd(data)
  z_scores <- list()
  for(i in 1:length(data)) {
    z_scores[i] <- (data[i] - mean) / sigma
  }
  return(unlist(z_scores))
}

# gets the z-score for a list of terms. 
get_z_scores <- function(data) {
  groups <- data %>%
    group_split(term)
  z_scores <- list()
  for(i in 1:length(groups)) {
    z_scores[[i]] <- list(get_z_score(groups[[i]]$hits))
  }
  return(unlist(z_scores))
}
```

 

### **4) Loess Transformation:**

The data for each term is plotted with the use of a loess regression
line (geom\_smooth in the code below). This transforms the data into a
smooth curve for a better visualization of overall trends.

—EXAMPLE CODE SNIPET—

``` r
# creates a plot with smoothed loess regression lines. 
make_plot <- function(category, title) {
  #plot <- sorted_df %>%
    #filter(term %in% str_to_title(category)) %>%
    #ggplot(aes(x=year, 
               #y=z_score, 
               #col=term)) +
    geom_smooth(se=F, 
                span = 0.5, 
                size = 0.5)
    #ggtitle(title) +
    #ylab("Articles (z-scores)") +
    #xlab("") + 
    #my_theme
  return(plot)
}
```

 

## **Sources**

  - Boyer (2019)
    <https://www.esquire.com/news-politics/a26454551/donald-trump-interview-new-york-times-media-objectivity/>

  - New York Times (2021) <https://developer.nytimes.com/apis>

  - Rutenberg (2016)
    <https://www.nytimes.com/2016/08/08/business/balance-fairness-and-a-proudly-provocative-presidential-candidate.html>

  - Statology (2021) <https://www.statology.org/interpret-z-scores/>
