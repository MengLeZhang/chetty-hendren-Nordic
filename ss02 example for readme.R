simCH_perc_example <-
  function(
    nSample = 1e3, 
    varNhood = 1     ## ynHood = percentile rank now; 1-100 in the pop
  ) {
    
    ages <- sample.int(10, nSample, replace = T) + 8
    ## 10 age groups, at default nSample this means 100 people in each age group
    
    
    yNhood <- rnorm(nSample, sd = sqrt(varNhood)) * 10 + 50 # so basically centred at 50th percntile with sd = 10 at std. normal dist.
    y <- sample.int(100, size = nSample, replace = T)
    
    ## betas for each regression
    simulation_df <-
      data.frame(ages, yNhood, y)
    
    
    return(simulation_df)
  }

simCH_perc_example()

