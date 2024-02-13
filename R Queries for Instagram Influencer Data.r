# Installing and loading required packages for data analysis and visualization.
install.packages(c("tidyverse", "skimr", "janitor", "dplyr"))
library(tidyverse)
library(skimr)
library(janitor)
library(dplyr)

# Creating data frame
insta_data <- read_csv("/cloud/project/top_insta_influencers_data.csv")

# Shows the first few rows of the data to get a glimpse of its structure.
head(insta_data)

# Provides detailed information about the data types and dimensions of each variable.
str(insta_data)

# Offers a summary view of the data, including data types, missing values, and unique values.
glimpse(insta_data)

# Lists the names of all columns in the data frame.
colnames(insta_data)

# Cleaning data
# Identify non-numeric values in followers column
non_numeric_followers <- insta_data[!grepl("^\\d+$", insta_data$followers), "followers"]

# Print the non-numeric values
print(non_numeric_followers)

# Convert avg_likes and followers to numeric, replacing non-numeric values with NA
insta_data$avg_likes <- as.numeric(insta_data$avg_likes)
insta_data$followers <- as.numeric(insta_data$followers)

# Renames a column for better readability (e.g., "influence_score" to "engagement_score").
insta_data <- mutate(insta_data, engagement_rate = avg_likes / followers, total_engagement = engagement_rate * followers)

# Calculates descriptive statistics (e.g., mean, median, quartiles) for numerical variables.
summary_data <- summarize(
  insta_data,
  followers_mean = mean(followers, na.rm = TRUE),
  engagement_rate_mean = mean(avg_likes, na.rm = TRUE) / mean(followers, na.rm = TRUE)
)

# Creates a new column based on existing data (e.g., calculating total engagement).
insta_data <- mutate(insta_data, total_engagement = engagement_rate * followers)

# Visualizing Data
# Convert followers and engagement_rate to numeric
insta_data$followers <- as.numeric(as.character(insta_data$followers))
insta_data$engagement_rate <- as.numeric(insta_data$engagement_rate)

# Check for missing values
missing_values <- sum(is.na(insta_data$followers) | is.na(insta_data$engagement_rate))
print(paste("Number of missing values:", missing_values))

# Remove rows with missing values
insta_data <- insta_data[complete.cases(insta_data$followers, insta_data$engagement_rate), ]

# Check the data types
str(insta_data)

# Creates a scatter plot to visualize the relationship between followers and engagement rate.
# Plot
ggplot(insta_data, aes(x = followers, y = engagement_rate)) +
  geom_point() +
  labs(title = "Engagement Rate vs. Followers")

# Saves a plot with annotations like titles and axis labels.
ggsave("engagement_vs_followers.png")

# Manipulating Data
# Sorts the data frame by a specific column (e.g., engagement rate).
insta_data <- arrange(insta_data, desc(engagement_rate))

# Finds the maximum, minimum, and mean values for a numerical column (e.g., followers).
max(insta_data$followers)
min(insta_data$followers)
mean(insta_data$followers)

# Groups data by country and calculates average engagement rate per country.
insta_data %>%
  group_by(country) %>%
  summarize(average_engagement = mean(engagement_rate))

# Filters data based on a specific condition (e.g., followers > 1 million).
insta_data %>%
  filter(followers > 1000000)