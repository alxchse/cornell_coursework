# PS2 Advanced questions

Set [TRACK.txt](../TRACK.txt) to `advanced`. Complete the six functions in
[src/Advanced.jl](../src/Advanced.jl), returning the values specified in their
docstrings. Before reading the benchmark-comparison results, write the
prediction requested in Question 2d. Save your code, then run this command
in a terminal in the PS2 folder:

```text
julia --project=. --startup-file=no check_submission.jl
```

**The checker automatically calls your functions and prints the financial
report after the test results.** You do not need a separate report command.
Look for **PS2 financial results** in the terminal and use those values to
answer the questions below. The report includes the observed outcomes returned
by your `observed_outcome` function. If a calculation shows `UNAVAILABLE`,
finish or fix the relevant function, save your code, and rerun the command.

Explain your reasoning in your own words. In the Markdown source editor,
replace each TODO with all parts of that answer. Keep your answer between
its matching `<!-- answer-N:start -->` and `<!-- answer-N:end -->` markers;
do not change their question numbers. The markers are hidden in the rendered
preview. Complete only this track's response file. Save your answers and
rerun the checker before submitting.

Report prices in USD/share and probabilities and scaled NPVs as percentages.
Report $u$ and $d$ as unitless price factors, $\mu_g$ and $\mu$ as percentages
per trading year, and $\sigma$ as a percentage per square root of a trading
year. Four decimal places are enough.

## 1. What did the models predict, and what happened?

Use the financial report's model estimates, forecast probabilities, and
observed outcomes. The checker calls your functions with the 2025 AAPL prices
to estimate the models and the 2026 prices to calculate the observed outcomes.
Organize your answer into the following three parts.

**a. Report the model estimates.** Make a table with columns for the
parameter name, estimated value, and units. Include all six parameters:

- $u$: the daily up price factor in the lattice.
- $d$: the daily down price factor in the lattice.
- $p$: the probability of an up move in one trading day in the lattice.
- $\mu_g$: the mean growth rate in the GBM model.
- $\sigma$: the volatility parameter in the GBM model.
- $\mu$: the price drift in the GBM model.

**b. Compare the forecasts with the observed trades.** First state the
purchase price and report the sale price needed to match the benchmark for
the 63-day holding period only. Then make a second table with one row for
each holding period: 21, 63, and 126 trading days. Use these columns:

- Holding period in trading days.
- Lattice probability of beating the benchmark (%).
- GBM probability of beating the benchmark (%).
- Observed sale date in 2026.
- Observed sale price (USD/share).
- Observed scaled NPV (%).
- Did the observed trade beat the benchmark? (Yes or no.)

Each row compares two model probabilities with the same observed trade.

**c. Explain the benchmark rule and the outcomes.** In one short paragraph,
explain which sale prices count as beating the benchmark and how your code
handles a sale price that exactly matches it.

Then write one sentence for each holding period stating whether the observed
trade had the more likely outcome under each model. To identify that outcome,
compare each model's forecast probability with 50%: a value above 50% favors
beating the benchmark, a value below 50% favors not beating it, and a value
of exactly 50% favors neither outcome.

<!-- answer-1:start -->
1A

| Parameter | Estimated value | Units |
|:--|--:|:--|
| $u$ | 1.0104 | unitless daily price factor |
| $d$ | 0.9885 | unitless daily price factor |
| $p$ | 55.0201 | % probability per trading day |
| $\mu_g$ | 10.9686 | % per trading year |
| $\sigma$ | 26.4020 | % per square root of a trading year |
| $\mu$ | 14.4540 | % per trading year |

1B 

The purchase price was 272.2992. After 63 trading days, the sale price needed to match the  benchmark was 275.7243

| Holding period in trading days | Lattice probability of beating the benchmark (%) | GBM probability of beating the benchmark (%) | Observed sale date in 2026 | Observed sale price (USD/share) | Observed scaled NPV (%) | Did the observed trade beat the benchmark? |
|:--|--:|--:|:--|--:|--:|:--|
| 21 | 51.2433 | 52.6016 | 2026-02-02 | 266.5831 | -2.5063 | No |
| 63 | 61.7141 | 54.4998 | 2026-04-02 | 254.6924 | -7.6279 | No |
| 126 | 62.9059 | 56.3502 | 2026-07-06 | 312.0838 | 11.7809 | Yes |

1C 

A sale beats the benchmark when its price is strictly greater than the purchase price grown at the 5% continuously compounded rate for the same time period. A sale exactly at the benchmark price has a NPV equal to zero, so the code's strict "> 0" in observed_outcome classifies it as not beating the benchmark. 

At 21 days and 63 days, both models assigned more than 50% probability to beating the benchmark, so the observed failure was not the more likely outcome under either model. However at 126 days, both models favored beating the benchmark, and the observed trade did infact beat it.
<!-- answer-1:end -->

## 2. Why do the models give different probabilities?

Use your results from Question 1 for parts a–c. Write one short paragraph
for each. Part d uses the report's separate benchmark comparison.

**a. Explain the difference between the models.** Why can the lattice and
the GBM model give different probabilities of beating the benchmark even
though both use the same 2025 prices? Refer to the lattice's two possible
daily growth rates, implied by the price factors $u$ and $d$, and the normal
distribution of growth rates in the GBM model.

**b. Explain what the observed outcomes tell you.** If the models give similar
probabilities, does that show that their probabilities are accurate? If a
trade fails to beat the benchmark despite a forecast probability above 50%,
does that show that the forecast probability was wrong? Explain whether
these three observed trades are enough to establish which model gives more
accurate probabilities. Account for the fact that all three holding periods
start with the same purchase and share the same price history.

**c. Explain what both models leave out.** In L3a, unusually large positive
or negative growth rates occurred more often than a normal model predicts,
and large changes tended to follow other large changes. Explain how the
models' growth-rate distributions, fixed parameters, and independent daily
changes limit their ability to reproduce these two patterns.

**d. Lower the benchmark from 5% to 1%.** Keep the purchase price, 2025
parameter estimates, and 126-day holding period fixed. Change only the
continuously compounded benchmark rate, from 0.05 to 0.01 per trading year.

1. **Predict.** Before reading the comparison results, write one or two
   sentences predicting how the sale price needed to match the benchmark
   and each model's probability of beating it will change. Explain your
   reasoning. Keep this prediction even if you later revise your explanation.
2. **Read the calculation.** Run the same checker command and find
   **Question 2: benchmark comparison (5% to 1%)**. The supplied report calls
   your existing functions with both rates. You do not need to edit a rate,
   write another function, or run a different command. Copy its two rows
   into a table with the benchmark rate (% per trading year), sale price to
   match it (USD/share), lattice probability (%), successful lattice node
   count, and GBM probability (%). For each model, subtract the 5% row's
   probability from the 1% row's probability and report the change in
   **percentage points**. For example, a change from 50% to 55% is
   +5 percentage points.
3. **Explain.** Compare the results with your prediction in one short
   paragraph. Use the reported node counts to decide whether the lower
   benchmark added any lattice sale prices to the successful set. Explain
   how the lattice's discrete sale prices and the GBM model's continuous
   sale-price distribution account for the two probability changes.
   Why are the fitted parameters unchanged? Do not divide the successful
   node count by the total: the nodes need not be equally likely.

Your prediction need not be correct for full credit. We assess your initial
reasoning and your explanation of the calculated results. If you already
saw the comparison, say so and describe what you would have expected.

<!-- answer-2:start -->
2A

The models observe the same 2025 price history, but they predict future price changes differently. Lattice uses two daily growth rates corresponding to fixed up and down price factors u=1.0104 and d=0.9885, along with an estimated up-move probability of 55%. The GBM model treats log growth as normally distributed, allowing a range of daily growth rates. So it is due to the different distributions and their aggregation over time period.

2B

Similar probabilities dont establish that either model is accurate. Accuracy is about how well the probabilities match outcomes over many iterations, like with backtesting. A failed trade is just an outcome the model assigned the most likely chance of occurring. The three observations arent enough to determine which model is better, especially because all time periods begin at the same time and share the same training, so they are related rather than independent experiments.

2C

The lattice takes only its two fitted daily growth rates, while GBM assumes normally distributed growth. Neither distribution takes into account the frequent extreme moves described in L3a. Both models also use fixed parameters apart from volatility, so they dont change when market volatility changes. That separation prevents either model from representing volatility clustering.

2D

I expect the lower benchmark rate to reduce the sale price needed to break even, and therefore increase both models probabilities of beating it.

| Benchmark rate (% per trading year) | Sale price to match benchmark (USD/share) | Lattice probability (%) | Successful lattice nodes | GBM probability (%) |
|--:|--:|--:|:--:|--:|
| 5.00 | 279.1925 | 62.9059 | 59 of 127 | 56.3502 |
| 1.00 | 273.6641 | 69.4252 | 60 of 127 | 60.5259 |

The probability change from 5% to 1% was 6.5193% for the lattice and 4.1757% for GBM. The lattice success set gained one sale-price node when the threshold fell. That newly included node's probability accounts for the increase. GBM is a sale-price distribution, so lowering the threshold adds probability in the interval between the two benchmark prices, producing its increase. The fitted parameters did not change because the history and functions stayed the same.
<!-- answer-2:end -->

## 3. Can expected NPV be positive with less than a 50% chance of success?

Use the section of the checker's report labeled **Advanced Question 3:
separate example with assumed parameters**. This example uses the following
inputs in place of the parameters estimated from the AAPL prices:

| Input | Value |
|:--|:--|
| Price drift, $\mu$ | 0.08 per trading year |
| Volatility parameter, $\sigma$ | 0.30 per square root of a trading year |
| Benchmark rate, $g_y$ | 0.05 per trading year |
| Holding period | 63 trading days |

The rate and volatility inputs above are decimal values. Use them as written
in your calculations, then report your results in the percentage units
specified at the top of this file.

**a. Report the three results.** First calculate the mean growth rate by hand
using $\mu_g=\mu-\sigma^2/2$ and show your substitution. Take the 63-day
probability of beating the benchmark and the 63-day expected scaled NPV from
the checker's separate example. That example calls your completed
[gbm_probability](../src/Advanced.jl) function and the supplied helper for the
expected scaled NPV. Then make a table with one row for each of these three
results and columns for the quantity, value, and units.

**b. Explain why the results can occur together.** In one short paragraph,
explain why the expected scaled NPV can be positive even though the
probability of beating the benchmark is below 50%. Explain the roles of
$\mu$ and $\mu_g$ in the two calculations and how large gains in some
outcomes can affect the average.

**c. Explain what you would use to make a decision.** Would you use the
expected scaled NPV alone to decide whether to buy? Give your reason and
name one other piece of information you would want before deciding. You
do not need to calculate that extra quantity or write additional code.

<!-- answer-3:start -->
3A

Using $\mu_g=\mu-\sigma^2/2$:

$$
\mu_g = 0.08 - \frac{0.30^2}{2} = 0.08 - 0.045 = 0.035 = 3.5000\%\text{ per trading year}.
$$

| Quantity | Value | Units |
|:--|--:|:--|
| Mean growth rate, $\mu_g$ | 3.5000 | % per trading year |
| Probability of beating the benchmark at 63 days | 49.0027 | % |
| Expected scaled NPV at 63 days | 0.7528 | % |

3B

These results can occur together because probability and expected NPV regad different aspects of the outcome distribution. The probability calculation compares the benchmark with the avg log growth rate, mu_g=3.5, which is below the 5% benchmark and therefore gives less than a 50% chance of beating it. Expected NPV depends on the price drift, mu=8. Although gains above the benchmark occur less than half the time, large gains can be big enough to make the avg scaled NPV positive.

3C

I would not use expected scaled NPV alone to decide whether to buy, since a positive avg does not show how large OR likely losses could be. Id also want a measure of risk, such as the probability or size of a loss over the holding time, and then compare that risk with my thresholds for losses.
<!-- answer-3:end -->
