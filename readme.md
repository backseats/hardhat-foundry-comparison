# Hardhat to Foundry Test Migration

By [@backseats_eth](https://twitter.com/backseats_eth)

This repo is an example of a working smart contract (`BigData.sol`) and equivilant tests written in Hardhat and Foundry.

It was inspired by [this tweet](https://twitter.com/backseats_eth/status/1657893582517182465) asking if anyone would like to see how it looks to compare the two toolchains and their tests.

I found it initially confusing to write tests in Foundry because of the "magic" that Hardhat is doing, getting the data in the right format to send into the smart contract. Foundry - being closer to the rails because you write your tests in Solidity itself – didn't have that magic and abstraction so the transition wasn't as smooth as I would have liked.

I hope this repo can help you out. I may add to it over time but make no promises.

## TODO:

* Figure out the issue with the input Merkle proof data in the **Foundry** test that causes a "Not on the Allowlist" error when running the test.

## Contributions

Feel free to make a PR or file an Issue if you have questions.
