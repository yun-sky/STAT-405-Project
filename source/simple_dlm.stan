// data {
//   int<lower=0> N;
//   vector[N] y;
// }
// 
// parameters {
//   real<lower=0> sigma_obs;
//   real<lower=0> sigma_level;
// }
// 
// transformed parameters {
//   
//   
// }
// 
// model {
//   sigma_obs ~ exponential(1);
//   sigma_level ~ exponential(1);
//   
//   y ~ gaussian_dlm
//   
// }