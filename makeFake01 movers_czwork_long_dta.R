# Fake dataset 
# create from cty_public.do 
# used in the appendix
##  main replication actually found in cz_public.do
## see CH original code/

library(tidyverse)
library(haven)
filename = 'movers_czwork_long.dta'

nRows = 1e3

# init the file
this_file <-
  data.frame(
  rowID = 1:nRows
  )

## Create variables listed 
this_file <-
  this_file %>%
  mutate(
    kid_tin = 1:nRows, # child's identifier
	  age_outcome = sample.int(7, nRows, replace = T) + 23, # kid age at outcome measured; >= 24
	  cohort = sample.int(19, nRows, replace = T) + 1979, # child's cohort
    fam_id = sample.int(nRows, nRows, replace = T), # child's family identifier
	  kid_rank = runif(nRows, 1,100), # kid family income rank at age specified by age_outcome
	  par_rank_n = runif(nRows, 1,100), # parent family income rank
    par_bin = par_rank_n %>% ntile(10), # parent family income decile bin [note: create later]
	  par_cz_orig = sample.int(19, nRows, replace = T), # parent origin CZ
	  par_cz_dest = sample.int(19, nRows, replace = T), # parent destination CZ
	  e_o = runif(nRows, 1,100) %>% ntile(10), # expected rank in origin
	  e_d = runif(nRows, 1,100) %>% ntile(10), # expected rank in destination
	  d_e = e_d - e_o, # difference in expected rank (d_e=e_d-e_o)
    insample = sample.int(2, nRows, replace = T) - 1,# dummy, = 1 if move distance > 100 miles and origin/destination populations > 250k and = 0 otherwise
	  parrank_yrmovecz_post = par_rank_n + rnorm(nRows, sd = 4),# parent rank in the year before move
	  parrank_yrmovecz_pre = par_rank_n + rnorm(nRows, sd = 4), # parent rank in the year after move
	  d_par_rank = parrank_yrmovecz_post - parrank_yrmovecz_pre, # difference in parent rank across moves [???]
	  parmar_yrmovecz_pre = sample.int(2, nRows, replace = T) - 1,# parent marital status dummy in year prior to move
	  parmar_yrmovecz_post= sample.int(2, nRows, replace = T) - 1# parent marital status dummy in year after move
  ) 
## Question is par_cz_orig a string or not

this_file <-
  this_file %>% 
  select(kid_tin:parmar_yrmovecz_post)

##  Labels 
these_labels <-
  c(
    "child's identifier",
	  "kid age at outcome measured",
	  "child's cohort",
    "child's family identifier",
	  "kid family income rank at age specified by age_outcome",
	  "parent family income rank",
	  "parent family income decile bin",
	  "parent origin CZ",
	  "parent destination CZ",
	  "expected rank in origin",
	  "expected rank in destination",
	  "difference in expected rank (d_e=e_d-e_o)",
    "dummy, = 1 if move distance > 100 miles and origin/destination populations > 250k and = 0 otherwise",
	  "parent rank in the year before move",
	  "parent rank in the year after move",
	  "difference in parent rank across moves",
	  "parent marital status dummy in year prior to move",
	  "parent marital status dummy in year after move"
    )

## write it out
dir.create('fake CH data')
haven::write_dta(this_file, 
          'fake CH data' %>% file.path('movers_czwork_long.dta'),
          #label = these_labels #WIP
          )
