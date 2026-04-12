data {
  int N;
  vector[N] y;
  vector[N] time;
  vector[N] gdp; // GDP
  vector[N] unempl_rate; //Enempoyment Rate
  vector[N] mortgage_rate;//mortgage rate
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
  vector[N] y_pred;

  for (i in 1:N) {
    y_pred[i] = normal_rng(
      beta0 + beta1*time[i] + beta2*gdp[i] + beta3*unempl_rate[i] + beta4*mortgage_rate[i],
      sigma);
  }
}




