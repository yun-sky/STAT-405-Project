data {
  int N;
  vector[N] y;
  vector[N+1] time;
  vector[N+1] gdp; // GDP
  vector[N+1] unempl_rate; //Enempoyment Rate
  vector[N+1] mortgage_rate;//mortgage rate
  int t_pred;
} 

parameters {
  real beta0;
  real beta1;
  real beta2;
  real beta3;
  real beta4;
  real<lower=0> sigma;
}

model {
  beta0 ~ normal(0, 10);
  beta1 ~ normal(0, 10);
  beta2 ~ normal(0, 10);
  beta3 ~ normal(0, 10);
  sigma ~ exponential(1);
  
  for (i in 1:N) {
    real mu_i = beta0 + beta1*time[i] + beta2*gdp[i] + beta3*unempl_rate[i] + beta4*mortgage_rate[i];
    y[i] ~ normal(mu_i, sigma);
  }
}

generated quantities {
  real y_pred; 
  y_pred = normal_rng(
      beta0 + beta1*time[t_pred] + beta2*gdp[t_pred] + beta3*unempl_rate[t_pred] + beta4*mortgage_rate[t_pred],
      sigma);
}




