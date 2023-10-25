# Load packages
library(tidyverse)

# Load the data
music <- read_rds("data/processed/music.rds")

# Skim the overall dataset
skimr::skim_without_charts(music)

# Plot the density of the outcome variable 'popularity'
music %>%
  ggplot(aes(x = popularity)) +
  geom_density()

# Plot the density of year split by the 50th percentile of 'popularity'
music %>%
  ggplot(aes(x = year, color = popularity > median(popularity))) +
  geom_density()

# Graph the mean popularity per year over time
music %>%
  group_by(year) %>%
  summarise(
    average_popularity = mean(popularity)
  ) %>%
  ggplot(aes(x = year, y = average_popularity)) +
  geom_line()

# Visualize a scatterplot of 'loudness' and 'energy' split between high and low popularities
music %>%
  ggplot(aes(x = loudness, y = energy)) +
  geom_point(aes(color = popularity > median(popularity)), alpha = 0.1) +
  geom_smooth()

# Visualize a scatterplot of 'danceability' and 'popularity'
music %>%
  ggplot(aes(x = danceability, y = popularity)) +
  geom_point(alpha = 0.05) +
  geom_smooth()

# Display a boxplot of popularity split between whether or not a song is acoustic
music %>%
  mutate(
    acousticness = fct_recode(acousticness,
                              "acoustic" = "1",
                              "not acoustic" = "0")
  ) %>%
  ggplot(aes(x = acousticness, y = popularity)) +
  geom_boxplot()

# Calculate the correlation coefficients and find highly correlated variables
corrr::correlate(music %>%
                   mutate(
                     acousticness = as.numeric(acousticness),
                     instrumentalness = as.numeric(instrumentalness),
                     liveness = as.numeric(liveness),
                     speechiness = as.numeric(speechiness)
                   ) %>%
                   select(popularity,
                          acousticness,
                          danceability,
                          energy,
                          instrumentalness,
                          liveness,
                          loudness,
                          speechiness,
                          tempo,
                          valence,
                          year))
