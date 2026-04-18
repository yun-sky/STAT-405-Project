data {
  int<lower=0> N;
  int<lower=0> p;
  vector[N] y;
  vector[N] gdp;
}

parameters {
  real<lower=0> sigma_b0;
  real<lower=0> sigma_b1;
  real<lower=0> sigma_y;
  
  vector[p] m0
  vector[p, p] c0;
}

transformed parameters {
  array[N] vector[2] thetas;
  
  
  for ()
}

model {
  // Prior
  sigma_slope ~ normal(0, 1);
  sigma_level ~ normal(0, 1);
  sigma_y ~ normal(0, 1);

  
  // Likelihood
  for (i in 2:N) {
    y ~ normal()
  }
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
