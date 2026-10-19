# Load packages
install.packages("broom")
install.packages("dyplr")
library(readr)
library(dplyr)
library(broom)

mean = 5.5
# we want probability of visiting more than -- (hence the 1 -) -- 5 stalls
1 - ppois(q = 5, lambda = 5.5)

# 90% of all visitors have visted x amount of stalls or less
x = qpois(p = 0.90, lambda = 5.5)

# density chart maker
dpois(x, lambda = 5.5)

visits  = rpois(n = 500, lambda = 5.5)
visits %>% hist()
visits %>% density %>% plot()
dobs = visits %>% density() %>% broom::tidy() %>% approxfun()
# approxfun takes a mapping of x to y's and creates its own function, so now dobs is useful
dobs(c(1:10))

# make a tibble that includes table info and stuff not declared
tibble(x = 1:10,prob = dobs(x) %>% plot())