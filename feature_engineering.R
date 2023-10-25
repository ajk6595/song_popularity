# Load packages
library(tidyverse)
library(tidymodels)

# Load split info
load("model_info/music_train.rda")
load("model_info/music_folds.rda")
 
# Create a recipe for the data
music_rec <- recipe(popularity ~ acousticness + danceability + energy + 
                      instrumentalness + liveness + loudness + speechiness + 
                      tempo + valence + year + mode + explicit, 
                    data = music_train) %>%
  step_dummy(acousticness, instrumentalness, liveness, speechiness, mode, 
             explicit) %>%
  step_normalize(all_predictors())

# Prep and bake the recipe
prep(music_rec) %>%
  bake(new_data = NULL)

# Write out recipes to model info
save(music_rec, file = "model_info/music_rec.rda")
