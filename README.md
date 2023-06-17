# Lateral Protocol

## Overview

Lateral Protocol aims to redefine stablecoin management by leveraging dynamic risk measures. Our approach involves the creation of a Collateralized Debt Position (CDP) backed stablecoin, utilizing Chainlink services for dynamic risk management across a dynamically sized basket of collateral.

## Key Features

- **Loan Against Collateral**: The protocol enables users to take loans against their deposited collateral.
- **Automated Reallocation Strategies**: Users can select from various strategies to optimize their collateralization.
- **Liquidation Mechanism**: A robust mechanism is included to ensure that the stablecoin is always sufficiently backed.

## Development

The contracts for the protocol were developed using Foundry, Chainlink, and Open Zeppelin contracts by our team consisting of Evan and Maroutis. We also created a Typescript API that performs Monte Carlo simulations to determine the optimal weight allocation of a well-chosen basket of assets. This API is called by the contract through a Chainlink function.

## Challenges and Achievements

We overcame several challenges during the development process, including integration of Chainlink functions with Foundry, conversions between Oracle numbers, and addressing contract size limitations. We are particularly proud of our ability to rapidly iterate, harmonize our skill-sets (engineering and quantitative finance), and combine different chains and protocols like Chainlink and Uniswap.

## Future Developments

- Formalization of protocol economics
- Development of a user-friendly interface for onboarding and vault management
- Simplification of contract design, particularly around liquidations
- Use of Chainlink functions for more sophisticated portfolio management models (in Python)

## Real Network Config

When it comes time to deploy, copy [.env-example](.env-example) to `.env` and set the variables.

## Deployed Contracts on Sepolia

[Coin](https://sepolia.etherscan.io/address/0xC63497c9fE8D26A741f01a24A87f009E07784e38)

[Portfolio](https://sepolia.etherscan.io/address/0xda10Af5f057D3894AE2c355BdFDDcB71E132E426)

[Notary](https://sepolia.etherscan.io/address/0xDD4407B51DA65832c15D78e2283D2Dd2Eb4F00D7)

## Testing

Enter the dev shell via

```
nix develop
```

And run the tests:

```
forge test
```
