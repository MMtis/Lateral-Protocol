# Simple Stable

Simple CDP-backed stablecoin

## Inspiration
We want to build our own CDP backed stable but utilize chainlink services to implement dynamic risk management on dynamical sized basket of collateral.

## What it does
The protocol allows users take loans against deposited collateral and can choose different automated reallocation strategies to optimize collateralization. It also relies on liquidations to ensure that the stablecoin is sufficiently backed.

## How we built it
We built the contracts using Foundry with Chainlink and Open Zeppelin contracts, and built a typescript API which performs Monte Carlo simulation to find the optimal weight allocation of well chosen basket of assets. The API is called by the contract through Chainlink function.

## Challenges we ran into
Getting chainlink functions to work with Foundry.
Converting numbers between Oracles.
Contract size limitation became a challenge that we solved by rethinking the architecture

## Accomplishments that we're proud of
Being able to quickly iterate, especially given our differing timezones
Harmonizing skill-sets with engineering and quantitative finance.
Combining different chains and protocol together : Chainlink / Uniswap

## What we learned
Chainlink functions are the entry point to an unlimited potential when it comes to modelling and simulations.
Portfolio rebalancing with uniswap.
Algothmic stablecoin management : minting/liquidations ...

## What's next for Lateral Protocol
Formalize protocol's economics
Develop Front-end for on-boarding and vault management
Simplify contract design, especially around liquidations
Utilizing Chainlink functions to call more sophisticated models for portfolio management (in python).

## Testing
Enter the dev shell via
```
nix develop
```
And run the tests:
```
forge test
```

## Real Network Config

When it comes time to deploy, copy [.env-example](.env-example) to `.env` and set the variables.

## Deployed Contracts on Sepolia

[Coin](https://sepolia.etherscan.io/address/0xC63497c9fE8D26A741f01a24A87f009E07784e38)

[Portfolio](https://sepolia.etherscan.io/address/0xda10Af5f057D3894AE2c355BdFDDcB71E132E426)

[Notary](https://sepolia.etherscan.io/address/0xDD4407B51DA65832c15D78e2283D2Dd2Eb4F00D7)
