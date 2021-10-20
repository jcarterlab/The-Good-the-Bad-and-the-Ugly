library(dplyr)
library(tidyverse)
library(ggplot2)
library(stringr)
library(ggthemes)
library(here)

# gets the z score for a specific term. 
get_z_score <- function(data) {
  
  mean <- mean(
    data
    )
  sigma <- sd(
    data
  )
  z_scores <- list()
  for(i in 1:length(data)) {
    z_scores[i] <- (data[i] - mean) / sigma
  }
  return(unlist(
    z_scores
    ))
}

# gets the z score for a list of terms. 
get_z_scores <- function(data) {
  
  groups <- data %>%
    group_split(term)
  
  z_scores <- list()
  for(i in 1:length(groups)) {
    z_scores[i] <- list(
      get_z_score(groups[[i]]$hits)
      )
  }
  return(unlist(
    z_scores
    ))
}

# good terms. 
the_good <- c("patriotism",
              "national identity",
              "nationalism")

# bad terms. 
the_bad <- c("conspiracy",
             "false information",
             "misinformation",
             "disinformation")

# ugly terms. 
the_ugly <- c("white supremacy",
              "homophobia",
              "discrimination",
              "misogyny",
              "transphobia",
              "hate speech")

# read in data. 
data <- read_csv("data.csv")

# sort data alphabetically by term. 
index <- order(data$term)
sorted_data_frame <- data[index,]

# change term to upper case. 
sorted_data_frame$term <- str_to_title(sorted_data_frame$term)

# my personal plot theme for data visualizations. 
my_theme <- theme_economist_white(gray_bg = FALSE) +
  theme(plot.title = element_text(hjust = 0.5, 
                                  vjust = 12, 
                                  size = 9, 
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
        legend.text = element_text(size = 12, 
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

# the good. 
sorted_data_frame %>% 
  mutate(
    z_score = get_z_scores(sorted_data_frame)
    ) %>%
  filter(
    term %in% str_to_title(the_good)
    ) %>%
  ggplot(
    aes(x=year, y=z_score, col=term)
    ) +
  geom_smooth(
    se=F, span = 0.5, size = 0.5
    ) +
  ggtitle(
    "Identity"
    ) +
  ylab(
    "Z Score"
    ) +
  xlab(
    "Year"
    ) + 
  my_theme

# the bad. 
sorted_data_frame %>% 
  mutate(
    z_score = get_z_scores(sorted_data_frame)
  ) %>%
  filter(
    term %in% str_to_title(the_bad)
  ) %>%
  ggplot(
    aes(x=year, y=z_score, col=term)
  ) +
  geom_smooth(
    se=F, span = 0.5, size = 0.5
  ) +
  ggtitle(
    "Distrust"
  ) +
  ylab(
    "Z Score"
  ) +
  xlab(
    "Year"
  ) + 
  my_theme

# the ugly. 
sorted_data_frame %>% 
  mutate(
    z_score = get_z_scores(sorted_data_frame)
  ) %>%
  filter(
    term %in% str_to_title(the_ugly)
  ) %>%
  ggplot(
    aes(x=year, y=z_score, col=term)
  ) +
  geom_smooth(
    se=F, span = 0.5, size = 0.5
  ) +
  ggtitle(
    "Divisiveness"
  ) +
  ylab(
    "Z Score"
  ) +
  xlab(
    "Year"
    ) + 
    my_theme
 