# Load packages
library(tidyverse)
library(tidymodels)

# Load tuned models
load("model_info/elastic_tuned.rda")
load("model_info/rf_tuned.rda")
load("model_info/bt_tuned.rda")
load("model_info/nn_tuned.rda")
load("model_info/music_train.rda")
load("model_info/music_test.rda")

# Plot the RMSE of the elastic model
autoplot(elastic_tuned, metric = "rmse")

# Plot the RMSE of the random forest model
autoplot(rf_tuned, metric = "rmse")

# Plot the RMSE of the boosted tree model
autoplot(bt_tuned, metric = "rmse")

# Plot the RMSE of the nearest neighbor model
autoplot(nn_tuned, metric = "rmse")

# Evaluate the performance of the tuned elastic model
show_best(elastic_tuned, metric = "rmse")

# Evaluate the performance of the tuned random forest model
show_best(rf_tuned, metric = "rmse")

# Evaluate the performance of the tuned boosted tree model
show_best(bt_tuned, metric = "rmse")

# Evaluate the performance of the tuned nearest neighbor model
show_best(nn_tuned, metric = "rmse")

# Define a workflow for the winning model
final_workflow <- rf_workflow %>%
  finalize_workflow(select_best(rf_tuned, metric = "rmse"))

# Fit the model to the entire training set
final_results <- fit(final_workflow, music_train)

# Visualize a variable importance plot
final_results %>%
  pull_workflow_fit() %>%
  vip::vip()

# Define a performance metric set
popularity_metric <- metric_set(rmse, rsq)

# Apply the model to the test set and obtain results
predict(final_results, new_data = music_test %>% select(-popularity)) %>%
  bind_cols(music_test %>% select(popularity)) %>%
  popularity_metric(truth = popularity, estimate = .pred)
  
