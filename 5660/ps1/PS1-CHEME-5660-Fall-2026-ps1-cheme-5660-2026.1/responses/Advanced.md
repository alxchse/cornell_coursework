# PS1 Advanced-Track Discussion Questions

Question 1 covers the Standard valuation and repricing work included in `src/Advanced.jl`. Questions 2 and 3 cover the additional funding comparison. Write all three answers in this file.

Edit this file in VS Code. Replace each `TODO: Write your response here.` line with your answer, keeping the surrounding HTML answer markers. Explain your reasoning and include the requested values, using tables where useful. Save this file before rerunning the checker.

Run `check_submission.jl` as described in the README to generate results from your saved code. The financial results appear in the terminal after the test report. Report rates as percentages and valuation prices in USD per USD 100 par. Funding amounts are in USD. The checker also saves `results/advanced-strategies.csv` and `results/advanced-scenario-outcomes.csv` in the extracted PS1 folder. Matching `scenario_id` values identify the same future across strategies.

## 1. Valuation and interest-rate risk

Report the following values from the checker, which uses `data/standard-terms.csv`:

* the six-month bill price and its equivalent continuously compounded annual rate;
* the seven-year note price before and after the 50-basis-point yield increase;
* the modified duration and convexity of the note;
* the new note price estimated using duration and convexity, which is L2b's second-order Taylor approximation shown in the README;
* the price recalculated by the package minus the estimated price.

For the price difference, use the checker's **Package price minus estimated note price** result, which is calculated before rounding. You may round reported values to four decimal places. Explain why the note's price changes while its coupon stays fixed, and why the two pricing methods give slightly different results.

<!-- answer-1:start -->
PS1 Advanced Financial Results
==============================
Results use your completed tasks and the supplied reporting functions.
Bill nominal annual yield y                        5.000000 %
Bill equivalent continuous rate g_y                4.938523 %
Bill price-implied continuous rate g_B             4.938523 %
Six-month bill price                              97.560976 USD per 100 USD par
Seven-year note price                             97.925460 USD per 100 USD par
Macaulay duration D_mac                            6.116506 years
Modified duration D_mod                            5.978989 years
Convexity K                                       41.817668 years squared
Estimated price change ΔV_B/V_B (+50 bp)          -2.937222 %
Note price from package (+50 bp yield)            95.048526 USD per 100 USD par
Estimated note price (duration + convexity)       95.049171 USD per 100 USD par
*** Package price minus estimated note price          -0.000645 USD per 100 USD par ***
Absolute approximation error                       0.000645 USD per 100 USD par
Available initial budget                       74000.000000 USD
Required year-7 payment                       100000.000000 USD

A bond/note's coupon is a contractual, fixed cash flow is set at issuance and unchanged for the life of the security. What changes is the discount rate used to convert those future cash flows into a present value.
<!-- answer-1:end -->

## 2. Funding with the available budget

This comparison uses separate simulated market prices. The purchase price of `N7` need not equal the seven-year note price in Question 1.

The firm has USD 74,000 and owes USD 100,000 at year 7. Compare `N7`, `N2-N5`, `N5-N2`, and `B1-B1-B1-B1-B1-B1-B1`. For each, report the funded count out of 40, mean final wealth, mean shortfall, and largest shortfall. Identify which has the highest funded count and which has the lowest mean shortfall. Explain why those measures can favor different choices. Use `N2-N5` and `N5-N2` to explain how purchase timing and coupon reinvestment affect outcomes, even though both sequences last seven years.

<!-- answer-2:start -->
TODO: Write your response here.
<!-- answer-2:end -->

## 3. Choose a strategy within the budget

The firm cannot borrow or add money to its USD 74,000 budget. Which of the four strategies should it choose? Support your recommendation with both the funded count and shortfall amounts from Question 2. Explain the risk you would be accepting and the consequence of missing the required payment. Give one limitation of using the 40 simulated futures as evidence about real-world funding reliability.

<!-- answer-3:start -->
TODO: Write your response here.
<!-- answer-3:end -->
