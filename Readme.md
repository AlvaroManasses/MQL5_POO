
# Usage Guide for EA_Teste

## Introdução
**EA_Teste** is an Expert Advisor (EA) developed for the MetaTrader 5 platform. It uses a set of modular tools, including signals based on the RSI indicator, trailing stop with the Parabolic SAR and risk management with fixed lots. This guide will explain how to set up and operate the EA efficiently.

---

## Prerequisites
1. **MetaTrader 5 Platform** installed.
2. **Trading account enabled for the desired asset**.
3. Basic familiarity with trading robot settings.

---

## Installation
1. Copy the `EA_Teste.mq5` file to the directory:
   ```
   <MetaTrader5>/MQL5/Experts/
   ```
2. Open MetaEditor and compile the file to ensure there are no errors.
3. In MetaTrader 5, add the EA to a chart of the desired asset.

---

## Robot Settings

### General Parameters
| Parameter | Description | Default Value |
|-------------------------|-------------------------------------------------------------------------|---------------|
| `Expert_Title` | Robot name displayed in the terminal. | "EA_Teste" |
| `Expert_MagicNumber` | Magic number to identify orders opened by the robot. | 5478 |
| `Expert_EveryTick` | Defines whether the robot will be updated on every tick or on every new candle. | `false` |

### Signal Settings
| Parameter | Description | Default Value |
|------------------------|--------------------------------------------------------------------------|--------------|
| `Signal_ThresholdOpen` | Minimum threshold for opening orders (0-100). | 10 |
| `Signal_ThresholdClose` | Minimum threshold for closing orders (0-100). | 10 |
| `Signal_RSI_PeriodRSI` | Period of the RSI indicator. | 8 |
| `Signal_RSI_Applied` | Price type used in RSI calculation (close, open, etc.). | Close |

### Trailing Stop Settings
| Parameter | Description | Default Value |
|----------------------------|---------------------------------------------------|--------------|
| `Trailing_ParabolicSAR_Step` | Parabolic SAR acceleration increment. | 0.02 |
| `Trailing_ParabolicSAR_Maximum` | Maximum Parabolic SAR acceleration rate. | 0.2 |

### Risk Management Settings
| Parameter | Description | Default Value |
|-------------------------|-------------------------------------------------------------------------|---------------|
| `Money_FixLot_Percent` | Percentage of account balance to be risked per trade. | 10.0 |
| `Money_FixLot_Lots` | Fixed lot volume for trades. | 0.1 |

---

### Trailing Stop Settings
| Parameter | Description | Default Value |
|----------------------------|---------------------------------------------------|--------------|
| `Trailing_ParabolicSAR_Step` | Parabolic SAR acceleration increment. | 0.02 |
| `Trailing_ParabolicSAR_Maximum` | Parabolic SAR acceleration maximum rate. | 0.2 |

### Risk Management Settings
| Parameter | Description | Default Value |
|-------------------------|-------------------------------------------------------------------------|---------------|
| `Money_FixLot_Percent` | Percentage of account balance to be risked per trade. | 10.0 |
| `Money_FixLot_Lots` | Fixed lot volume for trades. | 0.1 |

---
## Operation

1. **Load the EA to a chart**: Choose the desired asset and timeframe.
2. **Set parameters**: Adjust the input values ​​according to your strategy.
3. **Activate the robot**: Make sure that auto trading is enabled in MetaTrader 5.

The robot will use the configured signals to open trades and apply trailing stop and risk management automatically.

---
## Notes and Recommendations
- **Test on a demo account**: Before using on a real account, test the EA in a simulated environment to ensure that it behaves as expected.
- **Adjust parameters regularly**: The market is dynamic, and parameters may need to be adjusted to improve efficiency.
- **Monitor results**: Regularly monitor results to identify optimization opportunities.

---
## Notes
- This robot has operating logic based on **Netting** type accounts. In **Hedge** type accounts, there may be unpredictable and different behaviors than expected.
- There are differences between the Forex market and the B3 market:
- In **Forex**, the ideal is for the lot to be redefined as a decimal variable with a default value of **0.01**.
- In the **B3** market (Brazilian stock exchange), the lot value must be an integer with multiples of **100**, this being the minimum value.
- This robot is for educational purposes, **it is not an indication or suggestion for investment**.
- We strongly suggest taking the course ["Create Robots with MQL5 and Object Oriented Programming - OOP"](https://crieseurobocommql5.wordpress.com) for a better understanding of this Expert Advisor.

---
## Support
If you encounter problems or have questions, please visit:
[https://crieseurobocommql5.wordpress.com](https://crieseurobocommql5.wordpress.com)

---

**Version:** 1.00  
**Author:** rafaelfvcs
