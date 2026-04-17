data {
  int<lower=0> N;
  vector[N] y;
}

parameters {
  vector[N] slope_t;
  vector[N] level_t;

  real<lower=0> sigma_slope;
  real<lower=0> sigma_level;
  real<lower=0> sigma_y;
}

model {
  // Prior Distribution
  sigma_slope ~ student_t(4,0,1);
  sigma_level ~ student_t(4,0,1);
  sigma_y ~ student_t(4,0,1);
  
  // Initialized Distribution
  slope_t[1] ~ normal(0, sigma_slope);
  level_t[1] ~ normal(0, sigma_level);
  y[1] ~ normal(slope_t[1] + level_t[1], sigma_y);
  
  // State-Space Model
  for (t in 2:N) {
    slope_t[t] ~ normal(slope_t[t-1], sigma_slope);
    level_t[t] ~ normal(slope_t[t-1] + level_t[t-1], sigma_level);
  }
  
  for (t in 2:N) {
    y[t] ~ normal(level_t[t], sigma_y);
  }
  
}

// generated quantities { // Forward Sampling
//   // initial states
//   array[N] vector[1] y_pred;
//   array[N] vector[2] theta;
// 
//   theta[1] = multi_normal_rng(m0, c0);
//   y_pred[1] = multi_normal_rng(K'*theta[1], V);
// 
//   for (t in 2:N) {
//     theta[t] = multi_normal_rng(G*theta[t-1], W);
//     y_pred[t] = multi_normal_rng(K'*theta[t], V);
//   }
// }





