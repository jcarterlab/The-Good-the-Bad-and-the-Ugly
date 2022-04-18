The Good, the Bad and the Ugly
================
Jack Carter
18/04/2022

## **Summary**

This project shows how the conversation in the New York Times (NYT)
changed following the 2016 election of Donald Trump. A strong sense of
national belonging is undoubtedly good for any country, yet Trump’s rise
also appears to have been accompanied by growing political partisanship
and increased social discrimination.

 

## 1\) The Good

![](The-Good-the-Bad-and-the-Ugly_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

## 2\) The Bad

![](The-Good-the-Bad-and-the-Ugly_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

## 3\) The Ugly

![](The-Good-the-Bad-and-the-Ugly_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

 

## **Method**

### **1) Data Collection:**

The data were collected from the New York Times API. They include the
number of articles for each search term in the 12 years between 2011 and
2022.

**Total articles (thousands)**

| Anti-Semitism | Islamophobia | National Identity | Partisan Politics | Partisanship | Patriotism | Political Differences | Political Divide | Political Polarization | Racism | Sexism | Transphobia |
| ------------: | -----------: | ----------------: | ----------------: | -----------: | ---------: | --------------------: | ---------------: | ---------------------: | -----: | -----: | ----------: |
|          2.72 |         0.59 |              1.28 |               0.8 |         2.34 |       2.65 |                  0.44 |              0.5 |                   0.56 |  14.08 |   3.15 |        0.15 |

 

### **2) Z-scores:**

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

 

### **3) Loess Transformation:**

The data for each term is plotted with the use of a loess regression
line (geom\_smooth in the code below). This transforms the data into a
smooth curve for a better visualization of underlying trends.

—EXAMPLE CODE SNIPET—

``` r
# creates a plot with smoothed loess regression lines. 
make_plot <- function(category, title) {
  plot <- sorted_df %>%
    filter(term %in% str_to_title(category)) %>%
    ggplot(aes(x=year, 
               y=z_score, 
               col=term)) +
    geom_smooth(se=F, 
                span = 0.5, 
                size = 0.5) +
    geom_vline(xintercept = 2016,
               size=0.25,
               col="#696969") +
    geom_text(aes(x=2016, 
                  label="2016 win -", 
                  y=max(z_score)+0.1,
                  hjust=1.05),
              size=2.75,
              col="#696969") +
    geom_vline(xintercept = 2020,
               size=0.25,
               col="#696969") +
    geom_text(aes(x=2020, 
                  label="2020 loss -",
                  y=max(z_score)+0.1,
                  hjust=1.05),
              size=2.75,
              col="#696969") +
    ggtitle(title) +
    ylab("Articles (z-scores)") +
    xlab("") + 
    my_theme
  return(plot)
}
```

 

## **Sources**

  - New York Times (2021) <https://developer.nytimes.com/apis>

  - Statology (2021) <https://www.statology.org/interpret-z-scores/>
