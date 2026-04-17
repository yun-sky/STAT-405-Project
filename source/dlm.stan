data {
  int<lower=0> N;
  matrix[1, N] y;
}

parameters {
  real<lower=0> sigma_slope;
  real<lower=0> sigma_level;
  real<lower=0> sigma_y;
  
}

model {
  // Prior
  sigma_slope ~ normal(0, 10);
  sigma_level ~ normal(0, 10);
  sigma_y ~ normal(0, 10);
  
  // Likelihood
  matrix[1,1] obs_cov = rep_matrix(0, 1, 1);          // V
  matrix[2,2] param_cov = rep_matrix(0, 2, 2);    // W
  matrix[N,2] design = rep_matrix(0, 1, 2);       // F
  matrix[2,2] transition = rep_matrix(0, 2, 2);     // G
  vector[2] initial_mean;
  matrix[2,2] initial_cov = rep_matrix(0, 2, 2);
  
  // Intialize Observation Covariance Matrix
  obs_cov[1,1] = sigma_y;

  
  // Initialize Parameter Covariance Matrix
  param_cov[1,1] = sigma_level;
  param_cov[2,2] = sigma_slope;
  
  // Initialize Transition Matrix
  transition = rep_matrix(1, 2, 2);
  transition[2, 1] = 0;
  
  // Initialize Design Matrix
  for (i in 1:N) {
    design[i, 1] = 1;
  }
  
  // Intialize starting states
  initial_mean[1] = 0;
  initial_mean[2] = 0;
  initial_cov[1, 1] = 10;
  initial_cov[2, 2] = 10;
  
  y ~ gaussian_dlm_obs(design, transition, obs_cov, param_cov, initial_mean, initial_cov); 
}





