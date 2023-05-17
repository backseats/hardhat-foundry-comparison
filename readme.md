# Hardhat to Foundry Test Migration

By [@backseats_eth](https://twitter.com/backseats_eth)

While you're here, check out [ContractReader.io](https://contractreader.io) – the best way to read and understand smart contracts. ContractReader includes live onchain values, right in the code, security reviews by ChatGPT, and our forthcoming [audit tool](https://contractreader.io/audit-tool)!

---

This repo is an example of a working smart contract (`BigData.sol`) and equivilant tests written in Hardhat and Foundry.

It was inspired by [this tweet](https://twitter.com/backseats_eth/status/1657893582517182465) asking if anyone would like to see how it looks to compare the two toolchains and their tests.

I found it initially confusing to write tests in Foundry because of the "magic" that Hardhat is doing, getting the data in the right format to send into the smart contract. Foundry - being closer to the rails because you write your tests in Solidity itself – didn't have that magic and abstraction so the transition wasn't as smooth as I would have liked.

I hope this repo can help you out. I may add to it over time but make no promises.

## TLDR

There is a `tldr` directory that has three files, if you'd like to skip all of the other stuff and get right to the meat of it all.

* `BigData.sol` – The shared smart contract between the two test suites
* `BigDataTest.js` – The Hardhat tests
* `BigData.t.sol` – The Foundry tests

## Running The Tests

From the root directory, you can run the following command to run both the Hardhat and the Foundry tests.

 `cd hardhat && npx hardhat test && cd .. && cd foundry && forge test && cd ..`

## TODO:

- [ ] Figure out the issue with the input Merkle proof data in the **Foundry** test that causes a "Not on the Allowlist" error when running the test.

## Contributions

Feel free to make a PR or file an Issue if you have questions.
