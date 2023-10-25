# Load packages
library(tidyverse)
library(tidymodels)

# Load the data
music <- read_csv("data/unprocessed/data.csv") %>%
  janitor::clean_names()

# Check for glaring data issues
skimr::skim(music)

# Plot a histogram of the outcome variable 'popularity'
music %>%
  ggplot(aes(x = popularity)) +
  geom_freqpoly(bins = 50)

# See the distribution of year of the songs that have very little popularity
music %>%
  filter(popularity < 5) %>%
  ggplot(aes(x = year)) +
  geom_histogram(bins = 50)

# Filter out songs with very little popularity since these mostly detract from the model
music <- music %>%
  filter(popularity >= 5)

# Turn dummy variables into factors
music <- music %>%
  mutate(
    explicit = factor(explicit),
    mode = factor(mode)
  )

# Convert measure of confidence variables into dummy variables
music <- music %>%
  mutate(
    acousticness = factor(as.numeric(acousticness >= 0.5)),
    instrumentalness = factor(as.numeric(instrumentalness >= 0.5)),
    liveness = factor(as.numeric(liveness >= 0.8)),
    speechiness = factor(as.numeric(speechiness >= 0.66))
  )

# Modify the scale of continuous, non-dummy variables that range from 0 to 1 to make values easier to interpret
music <- music %>%
  mutate(
    danceability = danceability * 100,
    energy = energy * 100,
    valence = valence * 100
  )

# Rearrange the order of columns
music <- music %>%
  select(
    id, popularity, acousticness, danceability, energy, instrumentalness, liveness, loudness, speechiness, tempo, valence, year, mode, explicit, name, artists, duration_ms, key 
  ) %>%
  arrange(id)

# Write out the data as an .rds file
write_rds(
  music,
  "data/processed/music.rds"
)
