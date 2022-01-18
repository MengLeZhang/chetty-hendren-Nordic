# Guide to terms and index numbers used in C+H paper 

The C+H paper has a lot of index numbers and variables. It is easy to lose track so here are my notes on term used in the paper:

- $y$ income rank at age 24. Based on 2014 paper, it would be conditional on birth cohort. 

- $m$ index number for age at first move during childhood 
- $o$ index number for parent origin CZ 
- 
- $q$ index number for parent income decile (with CZ?). Income 
- $s$ index number for birth cohort 
- $\alpha_qos$ fixed effect for origin CZ, parent decile, birth cohort. Example usage in equation 5.  
- $\alpha_qosm$ same as $\alpha_qos$ but with $m$ as another grouping criteria for the fixed effect.
- $p$ parental income rank. No conditioning except on year of observation.  
- $y\hat_pds$ = predicted income at age 24 of permanent residents in destination cz conditional on parental income rank p and birth cohort s
- $y\hat_pos$ = predicted income at age 24 of permanent residents in origin cz conditional on parental income rank p and birth cohort s
- $\delta_odps$ difference in predicted and origin income. $y\hat_pds - y\hat_pos $ 

Other scripts (e.g. mostly greek letters) correspond to parameters to be estimated in various models. They are explained as the paper goes on. 

Todo/ clarity:
- $\alpha_qos$ do we recalculate income decile $q$ because on cohort and cz. We think probably not -- not need to substratify. 

Each of the different figures and equations rely on different parameters. 

# Example of variable construction

- $y$ 

Rank of person _i_'s income compared to everyone else in the same birth cohort at age 24. 

- 

## Figure 3
Required input: 
- $m$, $y$, $\delta_odps$

Manipulations: 
- $y^r$ demeaned $y$ from the expected $y$ for the origin CZ, parental income decile, and birth cohort $s$. 
Example use:

$y^r_i = y_i - E(y|q,o,s)$ where $E(y|q,o,s)$ is the calculated mean from the sample. 

- $\delta^r_odps$ Demeaned $\delta_odps$. Later this is divided it into 20 groups (ventiles). Example use
$\delta^r_odps = delta_odps - E(\delta_odps | q,o,s)$


Reason: Corresponds to the parameters in equation 4. 

## Equation 5 
Required input:
- $y$, $\alpha_qosm$, $m$, $\delta_odps$, $s$


## Equation 6
Required input
- $y$, $m$, $\delta_odps$, $s$
- $s$
- $\alpha_s$ fe for birth cohort 
- $y\bar$ predicted income rank $y$ of permanent residents by origin CZ o and birth cohort. average of the cell. 
- $p$ (i.e. percentile rank of parent)

Reason: replace fixed effect $\alpha_qosm$ with two other terms 

## Equation 7
Required input:
Same as equation 6.

Reason: same as equation 6 with a kink term at age 23. 