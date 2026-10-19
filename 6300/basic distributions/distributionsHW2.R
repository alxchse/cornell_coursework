library(readr)
library(dplyr)
library(ggplot2)

# question 1b
n = 400
lambda1 = 459
sigma = 20.4
solar = rpois(n, lambda1)
solar %>% hist()

CDF400 = 1 - ppois(q = 400, lambda1)
CDF400
CDF450 = 1 - ppois(q = 450, lambda1)
CDF450
CDF500 = 1 - ppois(q = 500, lambda1)
CDF500

# question 2
# reliability function: R(t)=1−F(t)
# failure rate = F(t)=1−e ^−λt
#2a find failure rate (lambda)
lambda2 = -log(0.40) / 1000
lambda2

#2b: whats the probability a panel that has lasted 1000 days, will last 5000 days
# Reliability Function for exponential distribution
r = function(t, lambda2){exp(-1*t*lambda2)}

prob5000 = r(t = 1000 + 4000, lambda2) /
          r(t = 1000, lambda2)
prob5000

#2c: whats the probability a panel that has lasted 1000 days will break in another 4000 days
probFail5000 = 1 - prob5000
probFail5000

#question4
#4a
# we collect each of the failure rates provided into variables, plus the sun variable
# we then convert them into their respective reliability probabilities using the function we derived earlier
# we separated roof A and B because their sunlight might be different, since theyre in different places
# we then sort the panels and the storage into  parallell system functions
# we then calculate the overall reliability as a series function, since all of the different stages of the process MUST come together at once to be functional
t = 1

lambda_panel = 0.0006 
lambda_storage = 0.02
lambda_other = 0.01
p_sun = 0.75

rp = exp(-lambda_panel * t)
rs = exp(-lambda_storage * t)
ro = exp(-lambda_other * t)

roofA = p_sun * (1 - (1 - rp)^4)
roofB = p_sun * rp
panels = 1 - (1 - roofA) * (1 - roofB)
storage = 1 - (1 - rs)^3

overallR = panels * ro * ro * storage

#4b
# the solar panel farm is a series system with nested parallel systems 
# sunlight reaches panel A or B or C or D or E. AND that parallel system activates the inverter. AND the inverter activates
# a parallel system of energy storage. 
#
# first we define our reliability function: r = function(t, lambda){exp(-lambda * t)}
# next we define a function for a series system, that takes any # of unnamed probabilities and multiplies them
# then we define a function for a parallel system, that takes any # of unnamed probabilities and multiplies their RECIPROCALS,
# making each into a failure probabiliy, THEN multiplies and takes the reciprocal of that to insinuate that at least one must work. 
# the c(...) is necessary for accepting unnamed arguments in a formula. 
#
# we define the failure rates and p of sun
# we define a system reliability function that takes t as its parameter:
# execute the reliability function on each of the system components with the given t and lambda vals
#
# since the roofA panel is separate from roofB, these parallel systems are independent of each other
# and dont necessarily get the same sunlight
# 
# define each part of the system now that we calculated their independent lambdas
# and put all of these in a comprehensive series system
r = function(t, lambda){exp(-lambda * t)}
series = function(...){prod(...) }
parallel = function(...){1 - prod(1 - c(...)) }

lambda_panel = 0.0006 
lambda_storage = 0.02
lambda_other = 0.01
p_sun = 0.75

system_r = function(t){
  rpanels = r(t, lambda_panel)
  rstorage = r(t, lambda_storage)
  rothers = r(t, lambda_other)

  roofA = series(p_sun, parallel(rep(rpanels, 4)))
  roofB = series(p_sun, rpanels)

  panels = parallel(roofA, roofB)
  inverter = rothers
  elec = rothers
  storage = parallel(rep(rstorage, 3))

  series(panels, inverter, elec, storage)
}

data = tibble(
  t = seq(0, 20, by = 1)) %>%
  mutate(reliability = sapply(t, system_r))
data

gg = ggplot(data, aes(x = t, y = reliability)) +
  geom_line(linewidth = 1, color = "red") +
  scale_y_continuous(limits = c(0, 1)) +
  labs(x = "Time (years)",
       y = "Total system reliability",
       title = "Solar panel system reliability, 0 - 20 years") +
  theme_minimal()

ggsave("reliability_plot.png", gg, width = 7, height = 4)

system_r(1)

# question 5
#5a
# this question asks us to think about the system as a series, where all events are independent of each other.
# we will use multiplication because we are "anding" together the probability of survival
# A survives AND B survives AND C survives
A = 0.01
B = 0.03
C = 0.05
pSurviveA = ((1-A)*(1-B)*(1-C))
print(pSurviveA)

# 5b
# this question asks us to think about the system as parallel, where all events are independent of each other.
# we will use take the complement of the and function, which gives us the or function:
# A fails OR B fails OR C fails --> at least one fails
# however, we must THEN take the complement of that, because we want that NONE fail
#  this converts it back to a survival probability
pSurviveB = 1-(1-((1-A)*(1-B)*(1-C)))
print(pSurviveB)