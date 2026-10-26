# PS3 Advanced comparison

Write your Question 1a prediction before you read the allocation results.

Hold USD 10,000 from December 31, 2025 through July 6, 2026 (126 trading days).
Risk is measured before fees in inverse years. Wealth is in USD. The 5% continuous benchmark is USD 10253.15.

## Estimation windows

| Window | Prices | Changes | Equal-weight estimated growth | Equal-weight estimated risk |
| --- | --- | --- | --- | --- |
| 2014-2025 | 3017 | 3016 | 0.1968 | 3.1322 |
| 2025 | 250 | 249 | 0.3096 | 3.0293 |

Estimated growth is the weighted average of the stocks' mean growth rates, in inverse years. It does not affect the GMV weights.

## Allocations: 2014-2025

| Portfolio | Estimated growth | Estimated risk | Short exposure |
| --- | --- | --- | --- |
| long-only | 0.1105 | 2.1690 | 0.0000% |
| shorts-allowed | 0.1098 | 2.1683 | 0.8426% |

| Stock | Long only (%) | Shorts allowed (%) |
| --- | --- | --- |
| AAPL | 8.2331% | 8.4548% |
| MSFT | 18.8221% | 19.1552% |
| NVDA | 0.0000% | 0.1643% |
| AMD | 0.0000% | -0.8426% |
| GS | 5.5064% | 5.6408% |
| BAC | 2.6022% | 2.6323% |
| F | 2.6426% | 2.7342% |
| JNJ | 62.1936% | 62.0610% |

## Allocations: 2025

| Portfolio | Estimated growth | Estimated risk | Short exposure |
| --- | --- | --- | --- |
| long-only | 0.2769 | 1.7623 | 0.0000% |
| shorts-allowed | 0.2486 | 1.7328 | 11.3647% |

| Stock | Long only (%) | Shorts allowed (%) |
| --- | --- | --- |
| AAPL | 0.0000% | 0.6664% |
| MSFT | 32.0012% | 34.2419% |
| NVDA | 2.3405% | 5.1937% |
| AMD | 0.0000% | -3.2042% |
| GS | 0.0000% | -8.1605% |
| BAC | 8.5609% | 13.6599% |
| F | 7.1452% | 8.5394% |
| JNJ | 49.9522% | 49.0634% |

## Observed results at 3% borrowing

| Window | Portfolio | Realized risk | Net wealth | Success |
| --- | --- | --- | --- | --- |
| reference | equal weight | 3.3082 | 12679.38 | yes |
| 2014-2025 | long-only | 2.0283 | 11432.98 | yes |
| 2014-2025 | shorts-allowed | 2.0721 | 11294.68 | yes |
| 2025 | long-only | 2.0526 | 10710.83 | yes |
| 2025 | shorts-allowed | 2.3945 | 10026.92 | no |

## Borrowing-fee comparison

| Window | Portfolio | Wealth at 0% | Wealth at 3% | Fee | Long gains before fees | Short gains before fees | Success at 0% | Success at 3% |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 2014-2025 | shorts-allowed | 11296.53 | 11294.68 | 1.84 | 1430.08 | -133.55 | yes | yes |
| 2025 | shorts-allowed | 10046.93 | 10026.92 | 20.01 | 713.90 | -666.97 | no | no |

Long and short gains before fees add up to the change in gross wealth from USD 10,000.

## Short positions in 2026

| Window | Stock | Amount shorted | Price change | Gain before fees |
| --- | --- | --- | --- | --- |
| 2014-2025 | AMD | 84.26 | +158.5096% | -133.55 |
| 2025 | AMD | 320.42 | +158.5096% | -507.89 |
| 2025 | GS | 816.05 | +19.4939% | -159.08 |

Amount shorted is the initial value of the shares owed. Price change runs from December 31, 2025 to July 6, 2026. A short gains when its price falls and loses when its price rises.

## Individual-stock risk

| Window | Stock | Estimated risk |
| --- | --- | --- |
| 2014-2025 | AAPL | 3.7645 |
| 2014-2025 | MSFT | 3.4108 |
| 2014-2025 | NVDA | 6.2130 |
| 2014-2025 | AMD | 7.5911 |
| 2014-2025 | GS | 3.9412 |
| 2014-2025 | BAC | 4.2386 |
| 2014-2025 | F | 5.0475 |
| 2014-2025 | JNJ | 2.4736 |
| 2025 | AAPL | 4.1912 |
| 2025 | MSFT | 3.3115 |
| 2025 | NVDA | 6.7002 |
| 2025 | AMD | 8.2755 |
| 2025 | GS | 4.3932 |
| 2025 | BAC | 3.9413 |
| 2025 | F | 4.4113 |
| 2025 | JNJ | 2.8078 |

## Short-position diagnostics

| Window | Stock | Weight | Stock risk | Correlation with combined longs |
| --- | --- | --- | --- | --- |
| 2014-2025 | AMD | -0.8426% | 7.5911 | 0.3124 |
| 2025 | AMD | -3.2042% | 8.2755 | 0.4024 |
| 2025 | GS | -8.1605% | 4.3932 | 0.5872 |

Correlation with combined longs compares the shorted stock's growth rates with the growth rate of the portfolio's long positions. Both use the estimation window. The long positions keep their initial weights, rescaled to sum to one.

## Modeled success probabilities

| Model window | Portfolio | Success at 0% | Success at 3% | Fee change (pp) |
| --- | --- | --- | --- | --- |
| 2014-2025 | long-only | 64.2600% | 64.2600% | 0.00 |
| 2014-2025 | shorts-allowed | 64.0150% | 63.9500% | -0.07 |
| 2014-2025 | equal weight | 73.1100% | 73.1100% | 0.00 |
| 2025 | long-only | 93.9200% | 93.9200% | 0.00 |
| 2025 | shorts-allowed | 91.2400% | 90.8150% | -0.42 |
| 2025 | equal weight | 85.7800% | 85.7800% | 0.00 |

## Simulation precision

| Model window | Portfolio | Paths | SE at 0% (pp) | SE at 3% (pp) |
| --- | --- | --- | --- | --- |
| 2014-2025 | long-only | 20000 | 0.3389 | 0.3389 |
| 2014-2025 | shorts-allowed | 20000 | 0.3394 | 0.3395 |
| 2014-2025 | equal weight | 20000 | 0.3135 | 0.3135 |
| 2025 | long-only | 20000 | 0.1690 | 0.1690 |
| 2025 | shorts-allowed | 20000 | 0.1999 | 0.2042 |
| 2025 | equal weight | 20000 | 0.2470 | 0.2470 |

Standard errors describe simulation precision under the fitted model, not forecast accuracy. Fee changes use unrounded probabilities. Both models reuse standard normal draws with seed 566003. Nonpositive wealth paths stay in the denominator.

Use selected results as evidence in the three response blocks. The teaching team reviews interpretation and documentation.
