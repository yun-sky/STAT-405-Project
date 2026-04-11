
# Dependencies
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(lubridate))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(corrplot))


house_price <- read.csv("https://raw.githubusercontent.com/yun-sky/STAT-405-Project/refs/heads/master/Datasets/MSPUS.csv", header=TRUE)
economic_factors <- read.csv("https://raw.githubusercontent.com/yun-sky/STAT-405-Project/refs/heads/master/Datasets/US_House_Price.csv", header=TRUE)
california_price <- read.csv("https://raw.githubusercontent.com/yun-sky/STAT-405-Project/refs/heads/master/Datasets/housing.csv", header=TRUE)

# compute quarterly mean values of predictor variables
economics_factors_quarterly <- economic_factors %>%
  mutate(
    DATE = as.Date(DATE),
    quarter = floor_date(DATE, unit = "quarter")
  ) %>%
  group_by(quarter) %>%
  summarise(
    GDP = mean(GDP, na.rm = TRUE),
    mortgage_rate = mean(mortgage_rate, na.rm = TRUE),
    unemployment_rate = mean(unemployment_rate, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  rename(DATE = quarter)

house_price <- house_price %>%
  mutate(DATE = as.Date(observation_date))

# Dataset
dataset <- inner_join(house_price, economics_factors_quarterly, by = "DATE") %>%
  select(-observation_date) %>%
  mutate(
    DATE = as.Date(DATE),
    time_index = seq_len(n())
  )

colSums(is.na(dataset))
colSums(dataset == 0)

