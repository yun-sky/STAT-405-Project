clean_mcmc_summary <- function(variables, mod_fit_summary) {
  col_select = col_select = c("variable", "mean", "median", "sd", "q5", "q95");
  
  mcmc_clean_summary <- mod_fit_summary %>%
    filter(if_any(variable, ~ . %in% variables)) %>%
    select(all_of(col_select))
  
  return(mcmc_clean_summary)
}