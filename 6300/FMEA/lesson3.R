# ── auto-included prerequisites (from earlier chunks) ──
library(dplyr)

library(tibble)

library(DiagrammeR)

f = tibble(
  # Make a vector of routes to failure
  failure_mode = c(
    "freezer --> fail_break",
    "loading --> fail_time",
    "loading --> fail_eat",
    "transport --> fail_time",
    "transport --> fail_eat",
    "taste --> fail_sell",
    "contaminate --> fail_safe",
    "package --> fail_safe" 
  )
)

# Failures:
  # Freezer could break
  # Worker could leave ice cream out while loading
  # Worker could eat the ice cream while loading
  # Worker could leave the ice cream out in transit
  # Worker could eat the ice cream in transit
  # Ice cream batch could taste bad
  # Cross contamination could have occured 
  # Worker could put ice cream in wrong package

f1 = f %>%
  mutate(severity = c(8, 5, 1, 5, 1, 3, 10, 10))
# Check out the contents!
f1

f2 = f1 %>%
  mutate(occurrence = c(2, 5, 8, 5, 8, 2, 8, 1))

f3 = f2 %>%
  mutate(detection = c(1, 8, 3, 8, 3, 1, 10, 2))

f4 = f3 %>%
  mutate(criticality = severity * occurrence * detection)

f4 %>%
  arrange(desc(criticality))

