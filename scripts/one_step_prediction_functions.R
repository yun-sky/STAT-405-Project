# Function Parameter Explanation
# - y_pred_samples: dataframe with a single column `y_pred`
# - test_point: the true observed value

# Plots Posterior Predictive Samples of One-Step forecasts against true value
plot_one_step_forecast_density <- function(y_pred_samples, test_point) {
  y_pred_median = median(y_pred_samples$y_pred)
  y_pred_density_plot <- ggplot(y_pred_samples, aes(x=y_pred)) +
    geom_density(color="blue") +
    geom_vline(aes(xintercept=test_point, linetype="Test Point")) +
    geom_vline(aes(xintercept=y_pred_median, linetype="Post Pred Median")) +
    labs(title="1-step forecast posterior predictive distribution")
  return(y_pred_density_plot)
}

# Computes the mean absolute scaled error
compute_mase <- function(y_pred_samples, test_point) {
  y_pred = y_pred_samples$y_pred
  return(
    mean(abs(test_point - y_pred)) / sd(y_pred)
  )
}

# Displays the MASE, 90% credible interval, and PP Median for PP samples
summary_one_step <- function(y_pred_samples, test_point) {
  ci_pred = quantile(y_pred_samples$y_pred, c(0.05, 0.5, 0.95))
  mase = compute_mase(y_pred_samples, test_point)
  summary_pred = data.frame(
    obs_value = test_point,
    mase = mase, 
    median = ci_pred["50%"],
    q5 = ci_pred["5%"],
    q95 = ci_pred["95%"]
  )
  print(summary_pred)
}