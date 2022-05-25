import { HardhatUserConfig, task } from "hardhat/config";
import "@nomiclabs/hardhat-waffle";


const config: HardhatUserConfig = {
  networks: {
    hardhat: {
      forking: {
        url: "https://api.avax.network/ext/bc/C/rpc",
        blockNumber: 12690051,
      },
        accounts: {
          accountsBalance: "10000000000000000000000000000",
        },
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
