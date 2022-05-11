library(dplyr)
library(tidyverse)
library(ggplot2)
library(stringr)
library(ggthemes)
library(knitr)
library(here)

# gets the z score for each term. 
get_z_score <- function(data) {
  mean <- mean(data)
  sigma <- sd(data)
  z_scores <- list()
  for(i in 1:length(data)) {
    z_scores[i] <- (data[i] - mean) / sigma
  }
  return(unlist(z_scores))
}

# gets the z score for a list of terms. 
get_z_scores <- function(data) {
  groups <- data %>%
    group_split(term)
  z_scores <- list()
  for(i in 1:length(groups)) {
    z_scores[[i]] <- list(get_z_score(groups[[i]]$hits))
  }
  return(unlist(z_scores))
}

national_belonging <- c("patriotism",
                        "national identity")
partisanship <- c("partisanship",
                  "political polarization",
                  "political divide",
                  "political differences")
discrimination <- c("anti-semitism",
                    "sexism", 
                    "racism", 
                    "islamophobia",
                    "transphobia")

# read in data. 
data <- read_csv(here("data.csv"))

# sort data alphabetically by term. 
index <- order(data$term)
sorted_df <- data[index,]

# change term to upper case. 
sorted_df$term <- str_to_title(sorted_df$term)

# adds a z-score variable. 
sorted_df$z_score <- get_z_scores(sorted_df)

# my personal plot theme for data visualizations. 
my_theme <- theme_economist_white(gray_bg = FALSE) +
  theme(plot.title = element_text(hjust = 0.5,
                                  vjust = 15,
                                  size = 11,
                                  color = "#474747"),
        plot.margin = unit(c(1.5, 1, 1.5, 1), "cm"),
        axis.text = element_text(size = 9,
                                 color = "gray30"),
        axis.text.x=element_text(vjust = -2.5),
        axis.title.x = element_text(size = 9,
                                    color = "gray30",
                                    vjust = -10),
        axis.title.y = element_text(size = 9,
                                    color = "gray30",
                                    vjust = 10),
        legend.direction = "vertical", 
        legend.position = "right",
        legend.title = element_blank(),
        legend.text = element_text(size = 11,
                                   color = "gray20"),
        legend.margin=margin(1, -15, 1, 0),
        legend.spacing.x = unit(0.25, "cm"),
        legend.key.size = unit(1, "cm"), 
        legend.key.height = unit(0.75, "cm"),
        strip.text = element_text(hjust = 0.5,
                                  vjust = 1,
                                  size = 10,
                                  color = "#474747"),
        panel.spacing = unit(2, "lines"))

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

# national_belonging  
make_plot(national_belonging, "National Belonging")

# partisanship   
make_plot(partisanship, "Partisanship")

# discrimination 
make_plot(discrimination, "Discrimination")
