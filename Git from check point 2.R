---
  title: "VTPEH 6270 - Git from check point 2"
author: "Joel Adam Thuo"
date: "`r Sys.Date()`"
output:
  pdf_document:
  toc: true
toc_depth: 1
number_sections: true
html_document:
  toc: true
toc_depth: '1'
df_print: paged
editor_options:
  chunk_output_type: console
urlcolor: blue
---
  
  ```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE, warning = FALSE, message = FALSE)
```

#Introduction:

**I chose this data set because I am interested in understanding how smoking rates more so among young adults and college students in my generation. I was hoping to find data representing my interests but I couldn't find one so I settled on what I could find and what was closest.**

Project Question: **How has smoking behavior changed across U.S. states over time, and what is the relationship between the percentage of adults who never smoked and those who are former smokers?**

Data set overview : **The dataset comes from the U.S. Centers for Disease Control and Prevention (CDC) Behavioral Risk Factor Surveillance System (BRFSS). It includes estimates of the prevalence of smoking among adult Americans at the state level. All U.S. states' non-institutionalized adults who are at least 18 years old make up the research population. Telephone surveys were used to gather data every year from 1995 to 2010. In order to compare smoking habits across states and over time, the dataset provides percentages of adults who are categorized as never smokers, former smokers, and current smokers.**
  
  #Loading libraries
  ```{r}
#install janitor
library(janitor)
#install ggplot2
library(ggplot2)
#install ggally
library(GGally)
#load dplyr
library(dplyr)

install.packages(k)

```

#Loading Data
```{r, results='hide'}

#set up directory
setwd("/Users/joeladamthuo/Library/CloudStorage/OneDrive-CornellUniversity/School/Spring 1/Data Analysis with R/Check point 2/CSVs")

#load file
tobacco_prevelance <- read.csv("BRFSS_Prevalence_and_Trends_Data__Tobacco_Use_-_Four_Level_Smoking_Data_for_1995-2010_20260127.csv")

#preview data
head(tobacco_prevelance)

```



```{r, results='hide'}
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

```


```{r}

#Print table with caption
knitr::kable(
  variable_table,
  caption = "Table 1. Description of variables included in the tobacco prevalence dataset subset"
)

```


Data Visualization (Histogram)
```{r, results='hide'}
#Making Former smoker a percentage
tobacco_sub <- tobacco_sub %>%
  mutate(
    former_smoker = as.numeric(gsub("%", "", former_smoker))
  )

#Mean and median
mean_former <- mean(tobacco_sub$former_smoker, na.rm = TRUE)
median_former <- median(tobacco_sub$former_smoker, na.rm = TRUE)

#Histogram of former smokers
ggplot(tobacco_sub, aes(x = former_smoker)) +
  
  geom_histogram(
    binwidth = 2, 
    fill = "lightblue", 
    color = "black") +
  
  geom_vline(
    aes(xintercept = mean_former, color = "Mean"), 
    linewidth = 1.2) +
  
  geom_vline(
    aes(xintercept = median_former, color = "Median"), 
    linewidth = 1.2, linetype = "dashed") +
  
  scale_x_continuous(labels = function(x) paste0(x, "%")) +
  
  labs(
    title = "Distribution of Adults Who Are Former Smokers",
    x = "Percentage of Adults Who Are Former Smokers (%)",
    y = "Count",
    color = "Statistic",
    caption = "Data source: BRFSS Tobacco Use Data (1995–2010)"
  ) +
  
  
  theme_minimal()


```

#Data Visualization (Scatter plot)

```{r, results='hide'}
#Making never smoked into a percentage
tobacco_sub <- tobacco_sub %>%
  mutate(
    never_smoked = as.numeric (gsub("%", "", never_smoked)),
    former_smoker = as.numeric(gsub("%", "", former_smoker))
  )

ggplot(tobacco_sub, aes(x = never_smoked, y= former_smoker))+
  
  geom_point(alpha = 0.6)+
  
  scale_x_continuous(labels = function(x) paste0(x, "%"))+
  scale_y_continuous(labels = function(x) paste0(x, "%"))+
  
  labs(
    title = "Relationship Between Never Smokers and Former Smokers",
    x = "Adults who never smoked (%)",
    y = "Adults who are Former smokers (%)",
    caption = "Data source: BRFSS Tobacco Use Data (1995–2010)"
  )+
  
  theme_minimal()

```


#AI Use Disclosure Statement

*As part of this assignment, please indicate whether you used any AI-based tools (e.g., ChatGPT, Claude, Copilot, Gemini, etc.). Indicate:*
  
  * *Did you use AI? Yes / No*
  
  **yes**
  
  * *If yes: Write a short disclosure statement (2–3 sentences) describing:*
  
  
  * *Which tool(s) you used.*
  
  
  * *How you used it (e.g., to help decide on an analysis approach, to generate a first draft of code, to improve or debug code you had written yourself, etc.).*
  
  
  *Example: “This document was generated using Claude to generate original code, which was then reviewed and adjusted” or "This document was generate using ChatGPT to assist with debugging of code generated by the author".*
  
  *Please keep your statement brief and honest. The goal is transparency, not detail: we do not need exact prompts or transcripts, just a clear sense of how AI supported this work.*
  
  **This document was generated using ChatGPT and Gemini. I used them as a teaching assistant. To understand what certain pieces of code do. How they affect the line if they are used differently and also to identify pieces of code I couldn't figure out**
