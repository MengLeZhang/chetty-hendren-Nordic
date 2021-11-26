# Simulation of Chetty and Hendren (2018) design

A companion to ss01 C+H simulation.

<!-- TOC titleSize:2 tabSpaces:2 depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 skip:0 title:1 charForUnorderedList:* -->
## Table of Contents
* [Simulation of Chetty and Hendren (2018) design](#simulation-of-chetty-and-hendren-2018-design)
* [Introduction](#introduction)
  * [Example analogy to an experiment](#example-analogy-to-an-experiment)
* [Simulation](#simulation)
  * [Check using bootstrap](#check-using-bootstrap)
  * [Comparison to Chetty and Hendren](#comparison-to-chetty-and-hendren)
  * [Lazy SE from C+H](#lazy-se-from-ch)
<!-- /TOC -->

# Introduction

Basically Chetty and Hendren (C+H) research design amount to:
1. For all children who move, find out what age they moved at $m$
2. Find out the characteristics of the neighbourhood they moved to $\bar y$
3. For each age group $m$, regress adult outcome $y$ onto childhood neighbourhood characteristic $\bar y$
4. The coefficient for $\bar y$ each age subset regression in 3 is $\beta_m$
5. Now regress $\beta_m$ onto age group $m$
6. The slope for $\beta_m$ in 5, $\delta_\beta$ is our statistic of interest

The interpretation of $\delta_\beta$ is that moving to a good neighbourhood one year later decreases the effectiveness of neighbourhood characteristics on adult outcome by $\delta_\beta$.
C+H argue this is due to the exposure effects of neighbourhood; amongst movers younger children are likely to be exposed for longer.

For example if the outcome was college attendance and $\delta_\beta$ = -1%, then moving to a good neighbourhood 1 year   

**TODO NOTE** Is it destination Nhood Y or the difference between origin and designation Nhood Y?

##  Example analogy to an experiment

Imagine a trial evaluation where all members receive the treatment eventually. The trial starts in January and ends in December of the same year. There is a random treatment and control group.

However, we randomly select trial members into 12 groups. For group A, the treatment is dispensed in janurary; B in Feburary etc.
Therefore, some members have different exposure to (or dosages of) the treatment at random: some are exposed for an entire year, others for one month.

| start group     | treatment start     | treatment outcome | control outcome| Effect (treatment - control)|
| :------------- | :------------- | :--- | :--- | :--- |
| A       | Jan       | 1 | 0| 1|
| B   | Feb   | 0.9  | 0  | 0.9  |
| C   | Mar  | 0.8  | 0  | 0.8   |
| etc   | ..  | ..  | .. | ..   |


For each group, we can calculate the treatment effect. The difference in treatment effect between groups A and B reflects the difference in exposure time to the treatment.

In practise, we cannot perfectly manipulate exposure due to non-compliance; treatment and control members can drop out. So the difference in treatment effect between A and B reflects the **intention to vary exposure** in the treatment. For group A, the intended exposure length is 12 months.

This is the experimental analogy to the C+H design. In C+H, if outcomes are measured when a child is 24:
- the trial length = 24
- treatment is $\bar y$ which is continuous instead of binary
- start group/ treatment start = age of move $m$
- for group $m$, intended exposure length = 24 - $m$
- for group $m$, the treatment effect is **not** $\beta_m$ ...
- ... nonetheless the intention to vary exposure effect is still $\delta_\beta$

However, in C+H design, the treatment effect for age group $m$ is **not** $\beta_m$. Instead $\beta_m$ is equal to the true effect plus a fixed value that represents confounding.

This is why $\beta_m - \beta_{m-1}$ yield the unbiased exposure effect. This is the key crucial parametric assumption. If we were to change the example trial analogy, this would be equivalent to saying that the trial is flawed and being allocated to the treatment group induces an effect independent of receiving the treatment. For example, if the treatment group realise they are receiving the treatment and this induces a positive effect. If this allocation effect was fixed across groups, then we can still calculate the intention to vary exposure effect.

Given this assumption, we can still measure the treatment effect for age group $m$ if we had more information.

Now imagine in the example trial, there was an extra group Z that will received the treatment AFTER the trial has ended. However, we measure their outcomes at the same time as everyone else. In short, for this group, we record their outcomes **BEFORE** the treatment starts (e.g. outcomes recorded in December but treatment started in January next year).

The treatment effect group Z is therefore equal to the fixed bias term. Therefore we can use this information to derive the true unbiased treatment effects for group A, B etc.

In C+H's case, they assume that the exposure effect of neighbourhoods ends after a certain age. Therefore, $\beta_m$ for age groups older than a cut-off reveals the fixed bias term. Note that in the example experiment, we know in advance which groups are not affected by exposure to the treatment (e.g. Z). In C+H's case they have to infer that information from looking for a discontinuity in the relationship between $m$ and $\beta_m$ (e.g. discontinuity in $\delta_\beta$).

# Simulation

I've simulated the null hypothesis in the c+h design to gauge the level of power need to detect a statistically significant result.

As a reminder, under the null hypothesis, $\delta_\beta$ = 0. In the simulation, I have:
- 10 age groups (9 to 18, representing $m$)
- 3000 cases spread evenly across age groups ($n$ =3000)
- $\bar y$ for each case is drawn from a normal dist. with mean = 0 and var = 0.1
- $y$ is drawn from a standard normal dist. (mean = 0, var = 1)

In this case $\beta_m = 0$ and $\delta_\beta = 0$.

Assuming that in the population data $\bar y$ has a standard deviation of 1. The interpretation of $\beta_m$ is the (modelled) effect of a SD change in $\bar y$ on $y$ (which we can also convert to SD). For example, if $\beta_m = 1$ then a 1 SD change in $\bar y$ change $y$ by 1 SD.

In the actual simulation sample, I made the variance of $\bar y$ equal to 0.1 to reflect the fact that actual movers don't choose their destinations at random and may be highly selective. In short, the variance in neighbourhood characteristic amongst movers is only 10% of the population variance. For example, if $\bar y$ is deprivation score, the variance in neighbourhood deprivation amongst movers is very small in relative terms.

**TODO** I currently haven't got a credible estimate of what the true variance is

The simulation sample size $n$ reflects the Scottish population aged 9-18 in 2011 which is roughly 600,000. Around 10% (actually 12%) of the Scottish census moved address in the year before the census. Then the SLS has a random 5% of the Scottish population. Therefore $600 * 0.1 * 0.05 = 3k$.

Under these condition, over 1000 simulation, the distribution of $|\delta_\beta|$ (technically $|0 - \delta_\beta|$) has quartiles and mean equal to:
```
Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
0.00000 0.00600 0.01400 0.01633 0.02300 0.08000
```
Only 5% of simulations had a $|\delta_\beta|$ equal to 0.036.
```
95%
0.040
```
This effect size is equal to saying that moving to a good neighbourhood (e.g. positive $\bar y$) 1 year later drops adult outcomes by 0.04 SDs.

Whether or not this is a big enough exposure effect depends on what a reasonable effect would be for prolonged exposure to good neighbourhoods.

For a start, this implies that delay a move to a neighbourhood 1SD better in $\bar y$ by 10 years induces a drop in $y$ of 40%!. This simply beyond any effect sizes found in the neighbourhood effects literature.

However C+H use other means to measure their outcome and neighbourhood variable...


##  Check using bootstrap
For a single sample, we can calculate the SE of our estimate for $|\delta_\beta|$
using bootstrapping. This ought to be roughly equal to our simulated distribution of
$|\delta_\beta|$ under the null hypothesis. If it's not, it indicates something if off regarding the simulation (or boostrap routine).

The bootstrap dist is:
```
V1         
Min.   :0.00000  
1st Qu.:0.00700  
Median :0.01400  
Mean   :0.01651  
3rd Qu.:0.02300  
Max.   :0.07300
```

With 5% of values being equal to 0.041 or higher. This is equivalent to our simulation values.
```
95%
0.041
```

## Comparison to Chetty and Hendren

C+H use percentile ranks as an outcome for $y$ and average of neighbourhood outcomes also expressed in percentiles for $\bar y$. They claim an exposure effect of 0.04%:

> We find that on average, spending an additional year in a CZ where the mean income rank of children of permanent residents is 1 percentile higher (at a given level of parental income) increases a child’s income
rank in adulthood by approximately 0.04 percentiles. That is, the incomes of children who move converge to the incomes of permanent residents in the destination at a rate of 4% per year of childhood exposure.  

So changing the simulation to percentiles:
- $y$ is drawn from a uniform dist 1-100
- $\bar y$ is normally dist. with mean 50 and sd 10

The distribution for $|\delta_\beta|$ is:
```
Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
0.0000  0.0060  0.0130  0.0142  0.0210  0.0560
```

With only 5% of case having an effect size of 0.033 or more
```
95%
0.033
```

This is indeed in line with C+H's effect sizes.

[**TODO** changing to percentiles increase optimism but why? is it because percentiles are fixed? Because we used pop percentile?]

## Lazy SE from C+H

Else we can just scale C+H SE by our sample size 3,000 verus their sample size 7 million:

For SE (based on fig IV):
```
> sqrt(7e6/ 3e3) * 0.002
[1] 0.09660918
```

So this is way too big a SE

In fact to get their effect size of 0.04 you need a SE of approx 0.02 or smaller thereabout. A sample size require X movers where X = :

```
> 7e6/100
[1] 70000
```

This is clearly not possible even with the entire Scottish census.

This may be possible with Sweden:
> 0-14 years: 17.54% (male 904,957 /female 855,946)
15-24 years: 11.06% (male 573,595 /female 537,358)

Depends on how much moving happens. Potentially Norway too -- again dependent on moving.
