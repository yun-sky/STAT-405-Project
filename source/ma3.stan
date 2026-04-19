data {
  int<lower=1> N;            
  vector[N] y;    
}

parameters {
  real mu;                   
  vector<lower=-1, upper=1>[3] theta;                
  real<lower=0> sigma;
}

transformed parameters {
  vector[N] eps;
  
  // Initial Values
  eps[1] = y[1] - mu;
  eps[2] = y[2] - mu - theta[1] * eps[1]; 
  eps[3] = y[3] - mu - theta[1] * eps[2] - theta[2] * eps[1];
  
  // Estimated Errors
  for (t in 4:N) {
    eps[t] = (y[t] - mu - theta[1]*eps[t-1] 
                        - theta[2]*eps[t-2] 
                        - theta[3]*eps[t-3]);
  }
}

model {
  // Posterior Distribution
  mu ~ normal(0, 10);     
  theta ~ normal(0, 0.5);
  sigma ~ cauchy(0, 1);
  
  // Likelihood
  y[4:N] ~ normal(mu + theta[1]*eps[3:(N - 1)]
                     + theta[2]*eps[2:(N - 2)]
                     + theta[3]*eps[1:(N - 3)],
                  sigma);
}

generated quantities {
  // Posterior Predictive Samples
  array[N] real y_post_pred;
  
  // Initial
  y_post_pred[1] = normal_rng(mu, sigma);
  y_post_pred[2] = normal_rng(mu + theta[1]*eps[1], sigma);
  y_post_pred[3] = normal_rng(mu + theta[1]*eps[2] + theta[2]*eps[3], sigma);
  y_post_pred[4:N] = normal_rng(mu + theta[1]*eps[3:(N - 1)]
                                   + theta[2]*eps[2:(N - 2)]
                                   + theta[3]*eps[1:(N - 3)], 
                                   sigma);
}

