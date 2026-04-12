//
data {
  int N;
  vector[N] real y;
  vector[N] real time;
  vector[N] real gdp; # GDP
  vector[N] real unempl_rate; #Enempoyment Rate
  vector[N] real mortgage_rate;#mortgage rate
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
  sigma ~ exp(1);
  
  for (i in 1:N) {
    real mu_i = beta0 + beta1*time[i] + beta2*gdp[i] + beta3*unempl_rate[i] + beta4*mortgage_rate[i]
    y[i] ~ normal(mu_i, sigma)
  }
}




