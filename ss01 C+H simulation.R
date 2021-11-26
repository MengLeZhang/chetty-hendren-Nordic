## Simulation for testing the power of the c+h estimator
##  The steps in this estimator are:
##  1. Grab child that moved nhood and record their age at move (ages)
##  2. For each age, regress their adult outcome on average outcome of their nhood (at childhood)
##  3. Get the coef of nhood in step 2
##  4. Find out if the coef in step 3 changes with age (e.g. decreases with age) -- possibly using anova or lm  
##  4a. Step 4 is basically a statistical test on the regression outputs of 3 onto age

##  This simulation simulates the null hypothesis that across age group the regression coef in 3 doesn't change
##  Under this null nhood has no effects ever
##  Four things determine statistical power: 1) number of age groups, 2) people per age group, 3) variance of nhood and 4) outcome y
##  We assume age groups = 10 and variance of y (Whcih we fix to 1)

library(tidyverse)
library(broom)

# default nhood variance = 20% of unconditional variance (and has no effect)
##  what is the real variance in nhood wages compared to the variance in wages (for an age group)



# Background --------------------------------------------------------------
##  Default we use 1000 case over 9 - 18
## However Scotland has roughly 600,000 9 - 18 year olds (https://en.wikipedia.org/wiki/Demography_of_Scotland, 2011 census)
## In 
##  In 1991, assume 10% of people moved house that year (12% in 2011 census, https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/internationalmigration/articles/internalandinternationalmigrationfortheunitedkingdomintheyearpriortothe2011census/2014-11-25)
##  since sls = 5% sample
##  We get 600 * 0.1 * 0.05 = 3k sample at best
##  however how do we record outcomes

# 1.1 Simulation with continuous var --------------------------------------

simCH <-
  function(nSample = 1e3, varNhood = 0.1) {
    
    
    ages <- sample.int(10, nSample, replace = T) + 8
    ## 10 age groups, at default nSample this means 100 people in each age group
    
    
    yNhood <- rnorm(nSample, sd = sqrt(varNhood))
    y <- rnorm(nSample)
    
    ## betas for each regression
    simulation_df <-
      data.frame(ages, yNhood, y)
    

    ##  Get reg results by subset
    ## see this post
    
    results <-
      simulation_df %>%
      group_by(ages) %>%
      do(avgY = tidy(lm(y ~ yNhood, data = .))) %>%
      unnest(avgY)
    
    results <-
      results %>%
      filter(term == 'yNhood')
    
    stat <- (lm(estimate ~ ages, results) %>% coef)[2]
    return(stat)
  }



# 1.2 simulation with proportion (@50%) -----------------------------------

##  defaulte = 10% sd in nhood proportions
simCH_prop <-
  function(nSample = 1e3, varNhood = 0.1) {
    
    
    ages <- sample.int(10, nSample, replace = T) + 8
    ## 10 age groups, at default nSample this means 100 people in each age group
    
    yNhood <- rnorm(nSample, sd = sqrt(varNhood))
    y <- sample.int(2,size = nSample, replace = T) - 1
    
    ## betas for each regression
    simulation_df <-
      data.frame(ages, yNhood, y)
    
    
    ##  Get reg results by subset
    ## see this post
    
    results <-
      simulation_df %>%
      group_by(ages) %>%
      do(avgY = tidy(lm(y ~ yNhood, data = .))) %>%
      unnest(avgY)
    
    results <-
      results %>%
      filter(term == 'yNhood')
    
    stat <- (lm(estimate ~ ages, results) %>% coef)[2]
    return(stat)
  }


# 1.3 Simulation using percentiles (unconditional) ------------------------
## E.g. percentiles based on national not sample or age group
## 1 = top 1%, 0.01 = bottom 1%, 



simCH_perc <-
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
    
    
    ##  Get reg results by subset
    ## see this post
    
    results <-
      simulation_df %>%
      group_by(ages) %>%
      do(avgY = tidy(lm(y ~ yNhood, data = .))) %>%
      unnest(avgY)
    
    results <-
      results %>%
      filter(term == 'yNhood')
    

    stat <- (lm(estimate ~ ages, results) %>% coef)[2]
    return(stat)
  }



# 2. replicate it ---------------------------------------------------------
##  Interpretation is change in outcome due to a 1SD change in yhood

##  For continuous Y
simulatedStat <- replicate(1e3, simCH(nSample = 3e3)) %>% round(3)
simulatedStat %>% abs() %>% summary # 
simulatedStat %>% abs() %>% quantile( c(0.95) )

##  For proportion Y
simulatedStat_prop <- replicate(1e3, simCH_prop(nSample = 3e3)) %>% round(3)
simulatedStat_prop %>% abs() %>% summary #
simulatedStat_prop %>% abs() %>% quantile( c(0.95) ) 


## For percentiles
simulatedStat_perc <- replicate(1e3, simCH_perc(nSample = 3e3)) %>% round(3)
simulatedStat_perc %>% abs() %>% summary # 
simulatedStat_perc %>% abs() %>% quantile( c(0.95) ) 

##  chetty slope is like 0.044 for percentiles



# 3. Bootstrap SE for a single simulation ---------------------------------

simCH_data <-
  function(nSample = 1e3, varNhood = 0.1) {
    
    
    ages <- sample.int(10, nSample, replace = T) + 8
    ## 10 age groups, at default nSample this means 100 people in each age group
    
    
    yNhood <- rnorm(nSample, sd = sqrt(varNhood))
    y <- rnorm(nSample)
    
    ## betas for each regression
    simulation_df <-
      data.frame(ages, yNhood, y)
    
    return(simulation_df)
  }
    
simData <- simCH_data(3e3)

simData %>% summary
simData %>%
  group_by(ages) %>%
  summarise_all(
    mean
  )




bootStat <-
  function(data, index){
    ##  Get reg results by subset
    ## see this post
    
    data <- data[index, ]
    
    results <-
      data %>%
      group_by(ages) %>%
      do(avgY = tidy(lm(y ~ yNhood, data = .))) %>%
      unnest(avgY)
    
    results <-
      results %>%
      filter(term == 'yNhood')
    
    stat <- (lm(estimate ~ ages, results) %>% coef)[2]
    return(stat)
  }

simData[1:10,] %>% bootStat()

##  The bootstrap
?boot::boot
bootResults <-
  boot::boot(simData, bootStat, R = 1e3)

bootResults$t %>% abs() %>% round(3) %>% summary
bootResults$t %>% abs() %>% round(3) %>% quantile(0.95)
