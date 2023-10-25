# Load packages
library(tidyverse)
library(tidymodels) 

# Set seed
set.seed(123)

# Load split and recipe data
load("model_info/music_rec.rda")
load("model_info/music_folds.rda")

# Create a nearest neighbors model
nn_model <- nearest_neighbor(mode = "regression",
                             neighbors = tune()) %>%
  set_engine("kknn")

# Set up parameters for nearest neighbors model
nn_params <- parameters(nn_model)

# Set up a regular grid with 5 levels for nearest neighbors model
nn_grid <- grid_regular(nn_params, levels = 5)

# Define a nearest neighbors workflow
nn_workflow <- workflow() %>%
  add_model(nn_model) %>%
  add_recipe(music_rec)

# Tune the parameters of the nearest neighbors model
nn_tuned <- nn_workflow %>%
  tune_grid(music_folds, grid = nn_grid)

# Write out results and workflow
save(nn_workflow, nn_tuned, file = "model_info/nn_tuned.rda")