data {
  int<lower=1> N;            
  vector[N] y;    
}

parameters {
  real mu;                   
  vector[3] theta;                
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
  theta ~ normal(0, 2.5);
  sigma ~ cauchy(0, 5);
  
  // Likelihood 
  for (t in 4:N) {
      y ~ normal(
        mu + theta[1]*eps[t-1] + theta[2]*eps[t-2] + theta[3]*eps[t-3], 
        sigma);
  }
}

generated quantities {
  // Posterior Predictive Samples
  vector[N] y_post_pred;
  
  // Initial
  y_post_pred[1:3] = rep_vector(0, 3);
  
  for (t in 4:N) {
    y_post_pred[t] = normal_rng(mu + theta[1]*y[t-1]
                                   + theta[2]*y[t-2]
                                   + theta[3]*y[t-3], sigma);
  }
}

