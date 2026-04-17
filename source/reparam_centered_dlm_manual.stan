data {
  int<lower=0> N;
  vector[N] y;
}

parameters {
  // vector[N] e_slope;
  vector[N] e_level;

  // real<lower=0> sigma_slope;
  real<lower=0> sigma_level;
  real<lower=0> sigma_y;
}

model {
  /*Prior Distirbution*/
  
  sigma_slope ~ cauchy(1, 5);
  sigma_level ~ cauchy(1, 5);
  sigma_y ~ cauchy(1, 5);
  

  // vector[N] slope;
  vector[N] level;
  

  // e_slope[1] ~ normal(0, sigma_slope);
  e_level[1] ~ normal(mean(y), sigma_level);

  // slope[1] = e_slope[1];
  level[1] = sigma_level*e_level[1];
  y[1] ~ normal(level[1], sigma_y);
  

  for (t in 2:N) {
    // e_slope[t] ~ normal(0, sigma_slope);
    e_level[t] ~ normal(0, 1);
    
    // slope[t] = slope[t-1] + e_slope[t];
    level[t] = level[t-1] + sigma_level*e_level[t];
    y[t] ~ normal(level[t], sigma_y);
  }
  
}





