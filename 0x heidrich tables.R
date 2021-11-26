# 0x: results from heidrich's appendix tables 

library(tidyverse)

# From table A6. 

slopeMain <-   c(0.75, 0.6, 0.57, 0.24)
slopeTable <-
  c(
    0.06, 0.07, -0.39, -0.4,
    -0.02, -0.01, -0.021, -0.22, 
  0.06, 0.06, -0.10, -0.08,
-0.04, -0.01, -0.20, -0.21,
0.17, 0.18, -0.17, -0.17,
-0.08, -0.05, -0.18, -0.16,
-0.13, -0.09, -0.17, -0.17,
-0.21, -0.12, -0.13, -0.14,
-0.08, -0.02, -0.02, -0.05,
-0.03, 0.07, 0.10, 0.08,
-0.37,  -0.34, 0.08, 0.07,
-0.06, 0.04, 0.06, 0.08,
-0.28, -0.20, 0.08, 0.12,
-0.63,   -0.56,   0.39, 0.40,
-0.33, -0.23, -0.04, 0.02,
-0.80,    -0.69,    -0.24, -0.15
)

slopeTable <- 
  slopeTable %>% matrix(ncol = 4, byrow =  T)

tableA6 <- 
  data.frame(
    age = 2:17,
    slopeTable
  )

tableA6 <-
  tableA6 %>%
  rename(
    sonSlope1 = X1,
    sonSlope2 = X2,
    daugSlope1 = X3,
    daugSlope2 = X4
  )

lm(sonSlope1 ~ age, tableA6) %>% summary ## yup this exists
lm(sonSlope1 ~ age, tableA6, subset = age %in% 10:17) %>% summary ## more sever

## opposite effect for daughters 
lm(daugSlope1 ~ age, tableA6) %>% summary ## yup this exists
lm(daugSlope2 ~ age, tableA6) %>% summary ## yup this exists

lm(daugSlope1 ~ age, tableA6, subset = age %in% 10:17) %>% summary ## better but no effect

