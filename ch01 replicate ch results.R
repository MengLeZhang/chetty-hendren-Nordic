## CH analysis in R
## Goal: start with equation 5 and work out backwards how to code it 
library(tidyverse)
library(broom)
library(haven)

## reading in the data

moversDF <- 
  read_dta('fake CH data/movers_czwork_long.dta')


moversDF %>% names
##  Let's use whatever data we need to try to replicate their analysis in Eq 5.

## extra variables :
moversDF <-
  moversDF %>%
  mutate(
    ageM = 10 + sample.int(9, nrow(moversDF), replace = T), # also called kid_age in their code
    cz_0 = sample.int(100, nrow(moversDF), replace = T)  # cz of origin
      )

## Basically chetty uses age at outcome dataset.

# Equation 5: ---------------------------------------------

## regression on diff in predicted income d_e
##  d_e = predicted income difference of permanent residents in destination vs origin -- by cohort?
##  and fixed effects 
## CZ of origin by parent income decile q by birth cohort s 

moversDF <-
  moversDF %>%
  mutate(
    czOQS = paste(cz_0, cohort, par_cz_orig),
    czOQSM = paste(cz_0, cohort, par_cz_orig, ageM)
  )

# pe= kid_age * d_e

eq5Formula <-
  kid_rank ~ 
  czOQSM +
  factor(ageM)*d_e + 
  factor(cohort)*d_e - 
  1 - factor(cohort) - factor(ageM) - d_e # reove all main effects

## The cohort*d_e accounts for measurement error

## remove stuff test
## how to remove all main effects (use -)
##  Example
# moversDF %>% 
#   lm(kid_rank ~ factor(ageM)*d_e - 1 - factor(ageM) - d_e, data =.)


eq5Fit <- moversDF %>% lm(eq5Formula, data =.)
eg5Res %>% summary

## tidy this output up

eq5Res <- eq5Fit %>% tidy

## filter results:
eq5Res <-
  eq5Res %>%
  filter(
    substr(term, 1, 2) != 'cz'
  )

## This is equation 5 BUT panel A doesn't seem to include cohort -- yet the STATA code does.
## The STATA code = okay so it must be the legend

## Equation 5 is meant to have 200,000 FE

## Eq6/ Figure 4: panel B  -- parametric estimator 

# As a more tractable
# alternative, we estimate a model in which we control parametri-
#   cally for the two key factors captured by the αqosm fixed effects: (i)
# the quality of the origin location, which we model by interacting
# the predicted outcomes for permanent residents in the origin at
# parent income percentile pi with birth cohort fixed effects, and (ii)
# disruption costs of moving that may vary with the age at move
# and parent income, which we model using age at move fixed ef-
#   fects linearly interacted with parent income percentile p

## predicted out for stayer with same parental income (so modelled y_i for indiidual if they stayed)
## and interactions with inter cohort FE 
## (ii) = ageM FE * parental income percentile

##  1) e_o*cohort # f_d_dummy* e_o 
##  2) par_rank_n_dummy_*ageM



