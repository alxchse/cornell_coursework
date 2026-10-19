# Load packages:
# library(packageName)
# Install packages:
# install.packages("packageName")
install.packages("MASS")
library(readr)
library(dplyr)
library(ggplot2)
library(MASS)

# Beth saw 5, Javier saw 1, June saw 10(!), Tim saw 3, Melanie saw 4, Mohammad saw 3, Jenny say 6, Yosuke saw 4, Jimena saw 5, and David saw 2.
# make a vector containing # of corgis seen by each person
corgi = c(5,1,10,3,4,3,6,4,5,2)
corgi # view it

# retrieve stats to start weibull distribution
mean = mean(corgi) # mean
sd = sd(corgi) # standard deviation
n = length(corgi) # number of values in vector - used in rates
var = var(corgi) # variance - used in other values
# now working on gamma functions
gammashape = mean^2 - var # gamma shape
gammarate = mean / var # gamma rate
# now working on exponential functions
exprate = 1 / mean # exponential rate

# weibull via fitdistr() fucntion
corgistats <- corgi %>% fitdistr(densfun = "weibull")
weibullshape <- corgistats$estimate[1] # from the distribution stats generated, the first value is the shape hence [1]
weibullscale <- corgistats$estimate[2] # from the distribution stats generated, the second value is the scale hence [2]

# simulate each distribution and bind the rows
corgisim <- bind_rows(
  data.frame(x = corgi, type = "Observed"), # our actual dataset
  data.frame(x = rnorm(1000, mean, sd), type = "Normal"), # normal distribution simulated x1000
  data.frame(x = rpois(1000, mean), type = "Poisson"), # poisson distribution simulated x1000
  data.frame(x = rgamma(1000, gammashape, gammarate), type = "Gamma"), # gamma distribution simulated x1000
  data.frame(x = rexp(1000, exprate), type = "Exponential"), # exponential distribution simulated x1000
  data.frame(x = rweibull(1000, weibullshape, weibullscale), type = "Weibull")) # weibull distribution simulated x1000

# lastly, geom_density() plot 
ggplot(data = corgisim, mapping = aes(x = x, fill = type)) +
  geom_density(alpha = 0.5) +
  xlim(0,15) +
  labs(x = "Corgi Sightings!", y = "Density (Frequency)")