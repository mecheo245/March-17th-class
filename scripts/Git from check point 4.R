---
  title: "VTPEH 6270 - Git from check point 4"
author: "Joel Adam Thuo"
date: "`r Sys.Date()`"
output:
  pdf_document:
  toc: true
toc_depth: 1
number_sections: true
latex_engine: xelatex
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


#Loading relevant libraries
```{r, results='hide'}

#install janitor
library(janitor)
#install ggplot2
library(ggplot2)
#install ggally
library(GGally)
#load dplyr
library(dplyr)
#install patchwork
#install.packages("patchwork")
library(patchwork)

```

```{r}
#set working directory
setwd("/Users/joeladamthuo/Desktop/R/March-17th-class")

check4 <- read.csv("sim_summary.csv")

head(check4)
names(check4)
```

#Research question

Is milk fat concentration different between populations with high cheese consumption compared to populations with low cheese consumption?
  
  
  #Data description
  ```{r}
data_description <- data.frame(
  Variable_Name = c("beta", "sample", "sim", "high_cheese_mean", 
                    "high_cheese_sd", "low_cheese_mean", "low_cheese_sd", "p"),
  
  Variable_Type = c("continuous", "discrete", "discrete", "continuous",
                    "continuous", "continuous", "continuous", "continuous"),
  
  R_Class = c("numeric", "numeric", "numeric", "numeric",
              "numeric", "numeric", "numeric", "numeric")
)

data_description
```

#Data visualization
```{r}
check4 <- check4 %>%
  mutate(mean_difference = high_cheese_mean - low_cheese_mean)

ggplot(check4, aes(x = beta, y = mean_difference)) +
  geom_point(alpha = 0.4) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    x = "Effect Size (Beta)",
    y = "Difference in Milk Fat (High Cheese - Low Cheese)",
    title = "Simulated Effect of Cheese Consumption on Milk Fat"
  ) +
  theme_bw()
```

#Description of Plausible Relationships

The simulated data suggest that milk fat concentration differs between high cheese and low cheese consumption groups. As the effect size parameter (β) increases, the mean milk fat in the high cheese group becomes larger relative to the low cheese group. This represents a positive relationship between cheese consumption and milk fat concentration.

#Parameters of interest
```{r}
parameters <- data.frame(
  Parameter = c("Effect size", "Sample size", "Noise"),
  Symbol = c("β", "n", "ε"),
  Description = c("Difference in milk fat between groups",
                  "Number of observations in the sample",
                  "Random variability in milk fat measurements")
)

parameters
```


#Final visualization
```{r}
ggplot(check4, aes(x = beta, y = p)) +
  geom_point(alpha = 0.3) +
  geom_smooth() +
  facet_wrap(~sample) +
  labs(
    x = "Effect Size (Beta)",
    y = "P-value",
    title = "Effect Size and Sample Size Influence Statistical Significance"
  ) +
  theme_bw()
```


#Interpretation

The simulations show that statistical power increases as effect size and sample size increase. When β is small, differences between high and low cheese groups are difficult to detect and p-values are often large. As β increases, the difference between groups becomes more apparent and p-values decrease. Larger sample sizes further improve the ability to detect these differences. This demonstrates how both biological effect size and sampling effort influence statistical test performance.

## AI Disclosure

**This document was generated using ChatGPT and Gemini. I used them as a teaching assistant. To understand what certain pieces of code do. How they affect the line if they are used differently and also to identify pieces of code I couldn't figure out**

