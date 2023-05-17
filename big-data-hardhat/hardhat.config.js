require("@nomiclabs/hardhat-etherscan");
require("@nomicfoundation/hardhat-chai-matchers")

module.exports = {
  solidity: "0.8.17",
    settings: {
      viaIR: true,
      optimizer: {
        enabled: true,
        runs: 10000,
        details: {
          yul: false
        }
      }
    },
    networks: {
      localhost: {
        url: "http://localhost:8545"
      },
    },
    mocha: {
      timeout: 20000
    }
  };
