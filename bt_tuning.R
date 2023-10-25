# Load packages
library(tidyverse)
library(tidymodels)

# Set seed
set.seed(123)

# Load split and recipe data
load("model_info/music_rec.rda")
load("model_info/music_folds.rda")

# Create a boosted tree model
bt_model <- boost_tree(mode = "regression",
                       mtry = tune(),
                       min_n = tune(),
                       learn_rate = tune()) %>%
  set_engine("xgboost")

# Set up parameters for boosted tree model
bt_params <- parameters(bt_model) %>%
  update(mtry = mtry(range = c(1, 6)),
         learn_rate = learn_rate(range = c(-5, -0.2)))

# Set up a regular grid with 4 levels for boosted tree model
bt_grid <- grid_regular(bt_params, levels = 5)

# Define a boosted tree workflow
bt_workflow <- workflow() %>%
  add_model(bt_model) %>%
  add_recipe(music_rec)

# Tune the parameters of the boosted tree model
bt_tuned <- bt_workflow %>%
  tune_grid(music_folds, grid = bt_grid)

# Write out results and workflow
save(bt_workflow, bt_tuned, file = "model_info/bt_tuned.rda")