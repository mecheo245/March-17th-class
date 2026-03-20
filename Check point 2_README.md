---
output:
  pdf_document: default
  html_document: default
---
############################################
# VTPEH 6270 - Check Point 2
# Author: Joel Adam Thuo
# Date: 2026-03-20
############################################


#Introduction:

#I chose this data set because I am interested in understanding how smoking rates more so among young adults and college students in my generation. I was hoping to find data representing my interests but I couldn't find one so I settled on what I could find and what was closest.**

#Project Question: **How has smoking behavior changed across U.S. states over time, and what is the relationship between the percentage of adults who never smoked and those who are former smokers?**

#Data set overview : **The dataset comes from the U.S. Centers for Disease Control and Prevention (CDC) Behavioral Risk Factor Surveillance System (BRFSS). It includes estimates of the prevalence of smoking among adult Americans at the state level. All U.S. states' non-institutionalized adults who are at least 18 years old make up the research population. Telephone surveys were used to gather data every year from 1995 to 2010. In order to compare smoking habits across states and over time, the dataset provides percentages of adults who are categorized as never smokers, former smokers, and current smokers.**

#Loading libraries

#install janitor
library(janitor)
#install ggplot2
library(ggplot2)
#install ggally
library(GGally)
#load dplyr
library(dplyr)

#install.packages(k)



#Loading Data


#set up directory
#setwd("/Users/joeladamthuo/Desktop/R/March-17th-class")

#load file
tobacco_prevelance <- read.csv("data/BRFSS_data.csv")

#preview data
head(tobacco_prevelance)



#Clean names
tobacco_prevelance <- tobacco_prevelance %>%
  clean_names()

#preview cleaned data
head(tobacco_prevelance)

names(tobacco_prevelance)

#selecting variables of interest by subseting
tobacco_sub <- tobacco_prevelance %>%
  select(
    year,
    never_smoked,
    state,
    former_smoker,
    smoke_everyday
  )

tobacco_sub <- tobacco_sub %>%
  select(year, never_smoked, state, former_smoker, smoke_everyday) %>%
  mutate(
    never_smoked = as.numeric(gsub("%", "", never_smoked)),
    former_smoker = as.numeric(gsub("%", "", former_smoker)),
    smoke_everyday = as.numeric(gsub("%", "", smoke_everyday))
    
  )


variable_table <- data.frame(
  variable = names(tobacco_sub),
  type = c(
    "Discrete numeric",
    "Continuous",
    "Categorical",
    "Continuous",
    "Continuous"
    
  ),
  Class = sapply(tobacco_sub, class)
)



#Print table with caption
knitr::kable(
  variable_table,
  caption = "Table 1. Description of variables included in the tobacco prevalence dataset subset"
)



#Create output folder
dir.create("outputs/figures", recursive = TRUE, showWarnings = FALSE)



#Data Visualization (Histogram)

#Making Former smoker a percentage
tobacco_sub <- tobacco_sub %>%
  mutate(
    former_smoker = as.numeric(gsub("%", "", former_smoker))
  )

#Mean and median
mean_former <- mean(tobacco_sub$former_smoker, na.rm = TRUE)
median_former <- median(tobacco_sub$former_smoker, na.rm = TRUE)

#Save histogram
png("outputs/figures/former_smoker_hist.png", width = 800, height = 600)

print(
  ggplot(tobacco_sub, aes(x = former_smoker)) +
    geom_histogram(
      binwidth = 2,
      fill = "lightblue",
      color = "black"
    ) +
    geom_vline(
      aes(xintercept = mean_former, color = "Mean"),
      linewidth = 1.2
    ) +
    geom_vline(
      aes(xintercept = median_former, color = "Median"),
      linewidth = 1.2,
      linetype = "dashed"
    ) +
    scale_x_continuous(labels = function(x) paste0(x, "%")) +
    labs(
      title = "Distribution of Adults Who Are Former Smokers",
      x = "Percentage of Adults Who Are Former Smokers (%)",
      y = "Count",
      color = "Statistic",
      caption = "Data source: BRFSS Tobacco Use Data (1995–2010)"
    ) +
    theme_minimal()
)

dev.off()

#Data Visualization (Scatter plot)

#Making never smoked into a percentage
tobacco_sub <- tobacco_sub %>%
  mutate(
    never_smoked = as.numeric (gsub("%", "", never_smoked)),
    former_smoker = as.numeric(gsub("%", "", former_smoker))
  )

#Save scatter plot
png("outputs/figures/never_vs_former_scatter.png", width = 800, height = 600)

print(
  ggplot(tobacco_sub, aes(x = never_smoked, y = former_smoker)) +
    geom_point(alpha = 0.6) +
    scale_x_continuous(labels = function(x) paste0(x, "%")) +
    scale_y_continuous(labels = function(x) paste0(x, "%")) +
    labs(
      title = "Relationship Between Never Smokers and Former Smokers",
      x = "Adults who never smoked (%)",
      y = "Adults who are Former smokers (%)",
      caption = "Data source: BRFSS Tobacco Use Data (1995–2010)"
    ) +
    theme_minimal()
)

dev.off()

#AI Use Disclosure Statement

#This document was generated using ChatGPT and Gemini. I used them as a teaching assistant. To understand what certain pieces of code do. How they affect the line if they are used differently and also to identify pieces of code I couldn't figure out