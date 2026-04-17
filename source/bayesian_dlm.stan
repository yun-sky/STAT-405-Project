data {
  int<lower=0> N;
  matrix[1, N] y;
}

parameters {
  real<lower=0> sigma_slope;
  real<lower=0> sigma_level;
  real<lower=0> sigma_y;
}

transformed parameters {
  matrix[2,1] design = rep_matrix(0, 2, 1);       // F (Columns of F must match rows of y)
  matrix[2,2] transition = rep_matrix(0, 2, 2);   // G
  matrix[1,1] obs_cov = rep_matrix(0, 1, 1);      // V   
  matrix[2,2] param_cov = rep_matrix(0, 2, 2);    // W
  vector[2] initial_mean;
  matrix[2,2] initial_cov = rep_matrix(0, 2, 2);

  
  // Intialization
  design[1, 1] = 1;
  
  transition = rep_matrix(1, 2, 2);
  transition[2, 1] = 0;
  
  obs_cov[1,1] = square(sigma_y);

  param_cov[1,1] = square(sigma_level);
  param_cov[2,2] = square(sigma_slope);

  initial_mean[1] = 0;
  initial_mean[2] = 0;
  initial_cov[1, 1] = 10;
  initial_cov[2, 2] = 10;
}

model {
  // Prior
  sigma_slope ~ exponential(1);
  sigma_level ~ exponential(1);
  sigma_y ~ exponential(1);
  //
  
  // Likelihood
  y ~ gaussian_dlm_obs(design, transition, obs_cov, param_cov, initial_mean, initial_cov); 
  
}

// generated quantities { // Forward Sampling
//   // initial states 
//   vector[N] y_pred;
//   vector[N] theta;
//   theta[1] = multi_normal_rng(initial_mean, initial_cov);
//   
//   for (t in 2:N) {
//     theta[t] = multi_normal_rng(G*theta[t-1], W);
//     y_pred[t] = multi_normal_rng(K'*theta[t], V);
//   }
// }





