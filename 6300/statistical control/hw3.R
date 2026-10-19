library(dplyr)
library(readr)
library(tibble)
library(ggplot2)
library(viridis)
library(ggpubr)
library(moments)
library(tidyverse)
# Download data to your workshops folder
# then read it in!
data = read_csv("https://raw.githubusercontent.com/timothyfraser/sysen/refs/heads/main/workshops/products.csv") 

data_long = data |>  
pivot_longer( 
  cols = c(grams1, grams2, grams3, grams4, grams5), 
  names_to = "sample", 
  values_to = "grams" 
) 

stat_s = data_long |> # takes data_long 
group_by(subgroup) |> # groups based on the subgroup number  
summarise( 
  xbar = mean(grams), # calculates mean for each subgroup 
  s = sd(grams) # calculates standard deviation for each subgroup 
)
sigma_short = sqrt(mean(stat_s$s^2))  
cat("1a) Sigma short =", sigma_short, "\n") 

#from question 1b
centerline = mean(stat_s$xbar) 
n = 5 
se_submeans = sigma_short / sqrt(n)
upper = centerline + 3 * se_submeans 
lower = centerline - 3 * se_submeans 
cat("1b) Centerline =", centerline, "\n") 
cat("1b) Upper Control Limit =", upper, "\n") 
cat("1b) Lower Control Limit", "\n") 

#from question 1c
ggplot(stat_s, aes(x = subgroup, y = xbar)) + 
geom_line() + 
geom_point() + 
geom_hline(yintercept = centerline) + 
geom_hline(yintercept = upper, linetype = "dashed") + 
geom_hline(yintercept = lower, linetype = "dashed") + 
geom_hline(yintercept = centerline + c(-2, -1, 1, 2) * se_submeans, linetype = "dotted") +

annotate( 
  "text", 
  x = max(stat_s$subgroup), 
  y = upper, 
  label = paste("UCL =", round(upper, 3)), 
  hjust = 1, 
  vjust = -0.5 
) + 
annotate( 
"text", 
  x = max(stat_s$subgroup), 
  y = centerline, 
  label = paste("Centerline =", round(centerline, 3)), 
  hjust = 1, 
  vjust = -0.5 
) + 
annotate( 
  "text",
  x = max(stat_s$subgroup), 
  y = lower, 
  label = paste("LCL =", round(lower, 3)), 
  hjust = 1, 
  vjust = 1.5 
) + 
labs( 
  title = "Average Chart", 
  x = "Subgroup", 
  y = "Average Weight (grams)" 
) 

# for question 4d
z = (stat_s$xbar - centerline) / se_submeans
n = length(z)

# subgroups where a run of at least k TRUEs ends (returns start:end ranges)
runs = function(cond, k) {
  r = rle(cond); ends = cumsum(r$lengths)
  i = which(r$values & r$lengths >= k)
  lapply(i, function(j) (ends[j] - r$lengths[j] + 1):ends[j])
}
win = function(f, k) which(sapply(k:n, function(i) f(z[(i-k+1):i]))) + k - 1

d = diff(stat_s$xbar)

test1 = which(abs(z) > 3)
test2 = win(function(w) sum(w >  2) >= 2 | sum(w < -2) >= 2, 3)
test3 = win(function(w) sum(w >  1) >= 4 | sum(w < -1) >= 4, 5)
test4 = c(runs(z > 0, 8), runs(z < 0, 8))
test5 = c(runs(d > 0, 5), runs(d < 0, 5))   # 5 diffs = 6 points; add +1 to the end index for the last point
test6 = runs(abs(z) < 1, 15)
test7 = runs(abs(z) > 1, 8)
test8 = runs(diff(sign(d)) != 0, 13)        # 13 sign changes = 14 points

list(test1, test2, test3, test4, test5, test6, test7, test8)

# calculate cpk
cpk = function(mu, sigma_s, lower = NULL, upper = NULL){ 
  if(!is.null(lower)){
    a = abs(mu - lower) / (3 * sigma_s) 
  }

  if(!is.null(upper)){ 
    b = abs(upper - mu) /  (3 * sigma_s) 
  } 

  if(!is.null(lower) & !is.null(upper)){ 
    min(a,b) %>% return() 
  }else if(is.null(lower)){ return(b) 
  }else if(is.null(upper)){ return(a) } 
}

#calculate ppk
ppk = function(mu, sigma_t, lower = NULL, upper = NULL){ 
  if(!is.null(lower)){ 
    a = abs(mu - lower) / (3 * sigma_t) 
  } 

  if(!is.null(upper)){ 
    b = abs(upper - mu) /  (3 * sigma_t) 
  } 

  if(!is.null(lower) & !is.null(upper)){ 
    min(a,b) %>% return() 
  }else if(is.null(lower)){ return(b) 
  }else if(is.null(upper)){ return(a) } 
} 

stat = data_long %>% 
  group_by(subgroup) %>% 
  summarize( 
    xbar = mean(grams),   
    sd = sd(grams),   
    n_w = n()              
  ) %>% 

  summarize( 
    xbbar = mean(xbar),                
    sigma_s = sqrt(mean(sd^2)),  
    sigma_t = sd(data_long$grams), 
    n = sum(n_w), 
    n_w = unique(n_w)[3], 
    k = n() 
)    

mycpk = cpk(sigma_s = stat$sigma_s, mu = stat$xbbar, lower = 2) 
mycpk 
myppk = ppk(sigma_t = stat$sigma_t, mu = stat$xbbar, lower = 2) 
myppk 

# Two sided 95% Confidence Interval for Cpk (using within-subgroup variation) 
ci = stat |> 
  summarize(
    estimate = cpk(
      mu = xbbar, 
      sigma_s = sigma_s, 
      lower = 2), 
      v_short = k * (n_w - 1), # degrees of freedom 
      se = estimate * sqrt(1 / (2 * v_short) + 1 / (9 * n * estimate^2)), 
      z = qnorm(0.975), # 1.96 for 95% CI 
      lower_ci = estimate - z * se, upper_ci = estimate + z * se
  )

ci

#make it into a graph
ci |> 
  ggplot(
     mapping = aes(x = "CP Index", y = estimate, ymin = lower, ymax = upper)) + 
      geom_hline(yintercept = c(0, 1.0, 2.0), 
        color = c("grey", "red", "grey")) + 
      geom_point() + 
      geom_linerange() + 
      coord_flip() + 
      theme_classic(base_size = 14) + 
      labs(title = "CPK with 2-Sided 95% CI",
         x = NULL, 
         y = "Cpk Index Value")

# one sided 95% lower bound for cpk
lb = stat |>
  summarize(
    estimate = cpk(mu = xbbar, sigma_s = sigma_s, lower = 2), 
    v_short = k * (n_w - 1), 
    se = estimate * sqrt(1 / (2 * v_short) + 1 / (9 * n * estimate^2)), 
    z = qnorm(0.95), 
    lower_bound_95 = estimate - z * se)

lb
