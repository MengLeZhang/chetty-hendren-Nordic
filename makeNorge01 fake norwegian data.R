## This is the raw data file -- if we are using it that is!

# id <str>: id string for person
# yr <num>: year of observation
# born <num>: year person born 
# inc <num>: income? . Example 108
# bsu <str>: id for bsu recorded at (jan 1) each year
# move <int, 0 -1>: ??? [suggestion: I’ll 
       
library(tidyverse)
library(haven)


## What's the dataset name

dataName = 'thisFake.dta'

## time-invariant stuff           

nID <- 1e3

thisPerson <-
  data.frame(
    id = 1:nID,
    fam_id = sample.int(nID, nID, replace = T),
    born = 1979 + sample.int(19, nID, replace = T)
  )

## The time varying data -- create as a function
# 1996 -2021

timeData <- 
  function(id, nYr = 20){
    # nYr # this defines length
    yr = 1980 + 1:nYr ## this defines the length
    tempOut <- 
      data.frame(
        id = id,
        yr = yr,
        inc = 100 + sample.int(40, nYr, replace =T),
        ## family
        fam_inc = 200 + sample.int(80, nYr, replace =T)
      ) %>%
        mutate(
          ## fake moving data 
          firstBSU = 1000 + sample.int(400, nYr, replace = T),
          firstCZ = 1000 + sample.int(100, nYr, replace = T),
          
          
          bsu = ifelse(
            runif(nYr, min = 0, max = 1) > 0.1, #i.e. probability of not moving
            firstBSU,
            1000 + sample.int(400)
          ),
          
          CZ = ifelse(
            bsu == firstBSU,
            firstCZ,
            1000 + sample.int(100, nYr, replace = T)
          )
        )
    
    return(tempOut)
  }

timeData(1)
## run it 

fakeOut <- 
  map_df(1:nID, timeData) 

fakeOut <-
  thisPerson %>%
  left_join(fakeOut)

## save the output 
haven::write_dta(fakeOut, 
                 'fake nordic data' %>% 
                   file.path(dataName)
                 )


