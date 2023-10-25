# Load packages
library(tidyverse)
library(tidymodels) 

# Set seed
set.seed(123)

# Load split and recipe data
load("model_info/music_rec.rda")
load("model_info/music_folds.rda")

# Create an elastic model
elastic_model <- linear_reg(penalty = tune(),
                            mixture = tune()) %>%
  set_engine("glmnet")

# Set up parameters for elastic model
elastic_params <- parameters(elastic_model)

# Set up a regular grid with 5 levels for elastic model
elastic_grid <- grid_regular(elastic_params, levels = 5)

# Define an elastic workflow
elastic_workflow <- workflow() %>%
  add_model(elastic_model) %>%
  add_recipe(music_rec)

# Tune the parameters of the elastic model
elastic_tuned <- elastic_workflow %>%
  tune_grid(music_folds, grid = elastic_grid)

# Write out results and workflow
save(elastic_workflow, elastic_tuned, file = "model_info/elastic_tuned.rda")