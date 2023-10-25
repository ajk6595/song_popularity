# Load packages
library(tidyverse)
library(tidymodels)

# Set seed
set.seed(123)

# Load split and recipe data
load("model_info/music_rec.rda")
load("model_info/music_folds.rda")

# Create a random forest model
rf_model <- rand_forest(mode = "regression",
                        mtry = tune(),
                        min_n = tune()) %>%
  set_engine("ranger", importance = "impurity")

# Set up parameters for random forest model
rf_params <- parameters(rf_model) %>%
  update(mtry = mtry(range = c(1, 6)))

# Set up a regular grid with 5 levels for random forest model
rf_grid <- grid_regular(rf_params, levels = 5)

# Define a random forest workflow
rf_workflow <- workflow() %>%
  add_model(rf_model) %>%
  add_recipe(music_rec)

# Tune the parameters of the random forest model
rf_tuned <- rf_workflow %>%
  tune_grid(music_folds, grid = rf_grid)

# Write out results and workflow
save(rf_workflow, rf_tuned, file = "model_info/rf_tuned.rda")