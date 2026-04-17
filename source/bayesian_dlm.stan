data {
  int<lower=0> N;
  matrix<lower=0>[1, N] y;
}

parameters {
  real<lower=0> sigma_slope;
  real<lower=0> sigma_level;
  real<lower=0> sigma_y;
}

transformed parameters {
  matrix[2,1] K = rep_matrix(0, 2, 1);    // Design (Columns of F must match rows of y)
  matrix[2,2] G = rep_matrix(0, 2, 2);    // Transition
  matrix[1,1] V = rep_matrix(0, 1, 1);    // Observation Covariance (Variance)  
  matrix[2,2] W = rep_matrix(0, 2, 2);    // System Covariance
  vector[2] m0;
  matrix[2,2] c0 = rep_matrix(0, 2, 2);

  // Intialization
  K[1, 1] = 1;
  
  G = rep_matrix(1, 2, 2);
  G[2, 1] = 0;
  
  V[1,1] = square(sigma_y); 
  W[1,1] = square(sigma_level); 
  W[2,2] = square(sigma_slope); 

  m0[1] = mean(y);
  m0[2] = 0.008;
  c0[1, 1] = sigma_level;
  c0[2, 2] = sigma_slope;
}

model {
  // Prior
  sigma_slope ~ student_t(4,0,1);
  sigma_level ~ student_t(4,0,1);
  sigma_y ~ student_t(4,0,1);
  
  // Likelihood
  y ~ gaussian_dlm_obs(K, G, V, W, m0, c0); 
}

generated quantities { // Forward Sampling
  // initial states
  array[N] vector[1] y_pred;
  array[N] vector[2] theta;

  theta[1] = multi_normal_rng(m0, c0);
  y_pred[1] = multi_normal_rng(K'*theta[1], V);

  for (t in 2:N) {
    theta[t] = multi_normal_rng(G*theta[t-1], W);
    y_pred[t] = multi_normal_rng(K'*theta[t], V);
  }
}





