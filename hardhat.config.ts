import { HardhatUserConfig, task } from "hardhat/config";
import "@nomiclabs/hardhat-waffle";


const config: HardhatUserConfig = {
  networks: {
    hardhat: {
      forking: {
        url: "https://speedy-nodes-nyc.moralis.io/9485086d85846cac9a1e6060/eth/mainnet/archive",
        blockNumber: 14841000
      },
        accounts: {
          accountsBalance: "10000000000000000000000000000",
        },
      blockGasLimit: 20000000000,
      gas: 112100000,
      gasPrice: 80000000000
    },
  },
  mocha: {
    timeout: 0
  },
  solidity: {
    compilers: [
      {
        version: "0.6.12",
        settings: {
          optimizer: {
            enabled: true,
            runs: 999999
          }
        }
      },
      {
        version: "0.8.4",
        settings: {
          optimizer: {
            enabled: true,
            runs: 999999
          }
        }
      }
    ]
  },
};

export default config;
