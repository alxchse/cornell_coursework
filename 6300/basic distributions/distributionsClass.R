# Load packages
# install.packages("readr")
library(readr)
library(dplyr)
library(ggplot2)

# Read in your dataset
la = read_csv("workshops/la_parishes.csv")

# View la parishes data
la %>% glimpse()
la %>% head()

hist = la$pc_nonwhite %>% hist()
hist

# basic statistics
length = la$pc_nonwhite %>% length()
mean = la$pc_nonwhite %>% mean()
median = la$pc_nonwhite %>% median()
min = la$pc_nonwhite %>% min()
max = la$pc_nonwhite %>% max()
range = la$pc_nonwhite %>% range()

# variance 
var = la$pc_nonwhite %>% var()
# standard deviations
sd = la$pc_nonwhite %>% sd()
# standard error
se = sqrt(var(la$pc_nonwhite) / length(la$pc_nonwhite))
# quantile of the lower 90%, (90% of values fall below this value)
la$pc_nonwhite %>% quantile(probs = 0.90) 
# covariance 
cov = sd(la$pc_nonwhite) / mean(la$pc_nonwhite)

# skewness describes whether the bulk of the distribution sits to the left or right of the center, 
# When people say that a certain person's perspective is skewed, they mean, it's very far from the mean
diff = la$pc_nonwhite - mean(la$pc_nonwhite)
diff
# Get the sample-size
# To be conservative, we'll subtract 1
n = length(la$pc_nonwhite) - 1
# Get the standard deviation
sigma = la$pc_nonwhite %>% sd()
# on avg, how big are these cubed differences?
avgdiff = sum(diff^3) / n
# We're going to need to put it in terms of a common unit, a "standard" unit — like the standard deviation! 
# Plus, we'll have to cube the standard deviation, so that it's in the same terms as our numerator diff³.
skew = sum(diff^3) / ( n * sigma^3)
skew 

# now we are going to calculate kurtosis: which describes how tightly bound the distribution is around the mean. Is it extremely pointy, 
# with a narrow distribution (high kurtosis), or does it span wide (low kurtosis)?
# we calculate how far each value is from the mean, but we take those differences to the 4th power ((x − x̄)⁴),
# which hyper-accentuates any extreme deviations and returns only positive values. 
# Then, we calculate the sample-size adjusted average of those differences. 
# Finally, to measure it in a consistent unit comparable across distributions, 
# we divide by the standard deviation taken to the 4th power; the powers in the numerator and denominator then more-or-less cancel each other out.
diff = la$pc_nonwhite - mean(la$pc_nonwhite)
diff^4
n = length(la$pc_nonwhite) - 1
sigma = la$pc_nonwhite %>% sd()
kurt = sum(diff^4) / ( n * sigma^4)
kurt

# calculate distributions

# rnorm() randomly generates for us any number of values randomly sampled from a normal distribution. 
# We just need to supply: (1) n values to draw, (2) the mean of that distribution, and (3) the sd of that distribution.
mean = mean(la$pc_nonwhite)
sd = sd(la$pc_nonwhite)
# simulate!
norm = rnorm(100, mean, sd)
# Visualize!
norm %>% hist()

# rpois() randomly samples integers (eg. 0, 1, 2, 3) from a poisson distribution, based on lambda, the average rate of occurrence. 
# We can approximate that by taking the mean of the vector
pois = rpois(100, lambda = mean)
pois %>% hist()

# rexp() randomly simulates positive real numbers over zero from an exponential distribution. 
# Here, the method of moments says: rate ≈ 1 / mean.
rate_exp = 1 / mean
exp = rexp(1000, rate_exp)
exp %>% hist()

# rgamma() randomly samples positive real numbers greater than zero from a gamma distribution. 
# It's like the continuous version of rpois(). 
# It requires 2 parameters, shape and rate. 
# Method of moments: shape ≈ mean² / variance; scale ≈ variance / mean.
shape = mean^2 / var
rate_gamma = mean / var
gamma = rgamma(100, shape, rate_gamma)
gamma %>% hist()

# calculations we dont need for this
# binomial distribution is a bit of a special case, in that it's mostly only helpful for binary variables (with values 0 and 1). 
# But let's try an example anyways. rbinom() randomly draws n simulated values from a set of provided values at a given probability (prob). 
# It's usually used for drawing binary variables (0 and 1); a coin flip would have prob = 0.5, or a 50-50 chance.
# In how many cases was the observed value greater than the mean?
    # prob = sum(la$pc_nonwhite > mean) / length
    # binom = rbinom(100, size = 1, prob)
    # binom %>% hist()

# rweibull() randomly samples positive real numbers over zero too, but from a Weibull distribution. 
# It requires a shape and scale parameter, but its method of moments equation is pretty complex. 
# Once we get into Weibull distribution territory, we'll need to use an advanced concept called maximum likelihood estimation, 
# with the fitdistr() from the MASS package. You can read more about it in the appendix.
# Estimate the shape and scale parameters for a weibull distribution
    # mystats = sw %>% fitdistr(densfun = "weibull")
    # Here, we're going to extract the estimate for shape
    # myshape_w = mystats$estimate[1]
    # and the estimate for scale
    # myscale_w = mystats$estimate[2]
    # myweibull = rweibull(n = 1000, shape = myshape_w, scale = myscale_w)
    # myweibull %>% hist()

# Finally, the uniform distribution is also a special case. The frequency of values in a uniform distribution is more-or-less uniform. 
# It also only spans the length of a specified interval a → b. A common range is a = 0 to b = 1. So, the frequency of 1.5 in that interval would be… zero.
    # myunif = runif(n = 1000, min = 0, max = 1)
    # myunif %>% hist(xlim = c(-0.5,1.5))

# comparing distributions
# we're going to want to outfit those vectors in nice data.frames and stack them into 1 data.frame to visualize. 
# We can do this using the bind_rows() function from the dplyr package.

# Using bind_rows(),
sim = bind_rows(
  data.frame(x = la$pc_nonwhite, type = "Observed"),
  data.frame(x = norm, type = "Normal"),
  data.frame(x = pois, type = "Poisson"),
  data.frame(x = gamma, type = "Gamma"),
  data.frame(x = exp, type = "Exponential"))
# Next, we can visualize those distributions using geom_density() in ggplot (or geom_histogram(), really, if that floats your boat).
g = ggplot(data = sim, mapping = aes(x = x, fill = type)) +
  geom_density(alpha = 0.5) +
  labs(x = "Hmm", y = "(Frequency)",
       subtitle = "Which distribution fits best?", fill = "Type")
g

#adjust scale
g +
  xlim(0,100)