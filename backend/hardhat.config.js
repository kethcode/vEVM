require("dotenv").config();
require("@nomicfoundation/hardhat-toolbox");
require("hardhat-gas-reporter");
require("hardhat-contract-sizer");
require("@nomiclabs/hardhat-etherscan");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.17",
        settings: {
          optimizer: {
            enabled: true,
            runs: 1,
          },
        },
      },
    ],
  },
  networks: {
    "optimism-goerli": {
      url: process.env.ALCHEMY_OP_GOERLI_KEY_WSS,
      accounts: [process.env.ALCHEMY_OP_GOERLI_PRIVATE_KEY],
    },
    // for testnet
    "base-goerli": {
      url: "https://goerli.base.org",
      accounts: [process.env.ALCHEMY_OP_GOERLI_PRIVATE_KEY],
    },
  },
  etherscan: {
    apiKey: {
      // optimisticGoerli: process.env.ETHERSCAN_OP_API_KEY,
      "base-goerli": process.env.BASE_BLOCKSCOUT_KEY
    },
    customChains: [
      {
        network: "base-goerli",
        chainId: 84531,
        urls: {
          // Pick a block explorer and uncomment those lines

          // Blockscout
          // apiURL: "https://base-goerli.blockscout.com/api",
          // browserURL: "https://base-goerli.blockscout.com"

          // Basescan by Etherscan
          apiURL: "https://api-goerli.basescan.org/api",
          browserURL: "https://goerli.basescan.org"
        },
      },
    ],
  },

  contractSizer: {
    alphaSort: true,
    disambiguatePaths: false,
    runOnCompile: true,
    strict: false,
    only: [],
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS ? true : false,
    currency: "USD",
    coinmarketcap: process.env.COINMARKETCAP_API_KEY,
    gasPriceApi: process.env.GAS_PRICE_API,
    showTimeSpent: true,
  },
};
