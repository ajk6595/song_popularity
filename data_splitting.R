# Load packages
library(tidyverse)
library(tidymodels)

# Set seed
set.seed(123)

# Load the data
music <- read_rds("data/processed/music.rds")

# Split the data
music_split <- initial_split(music, prop = 0.7, strata = popularity)
music_split

# Create training and test sets
music_train <- training(music_split)
music_test <- testing(music_split)

# Verify dimensions of each set
dim(music_train)
dim(music_test)

# Create folds in the training data
music_folds <- vfold_cv(music_train, v = 5, repeats = 3)

# Save splits, folds, and training and test sets
save(music_split, file = "model_info/music_split.rda")
save(music_folds, file = "model_info/music_folds.rda")
save(music_train, file = "model_info/music_train.rda")
save(music_test, file = "model_info/music_test.rda")
