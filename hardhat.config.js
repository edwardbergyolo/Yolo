// ==============================================================================
// SECTION 21: CANONICAL HARDHAT DEPLOYMENT CONFIGURATION (hardhat.config.js)
// ==============================================================================
require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

// Ensure private validation keys safely fall back during localized staging
const DEPLOYER_PRIVATE_KEY = process.env.DEPLOYER_PRIVATE_KEY || "0x0000000000000000000000000000000000000000000000000000000000000000";

module.exports = {
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200, // Maximizes execution gas efficiency on Layer-2 runtimes
      },
    },
  },
  networks: {
    // Local development network staging boundary
    localhost: {
      url: "http://127.0.0.1:8545",
    },
    // Production Base Mainnet Network Channel Map
    base: {
      url: process.env.BASE_RPC_URL || "https://base.org",
      accounts: [DEPLOYER_PRIVATE_KEY],
      gasPrice: "auto", // Dynamically track live base fees to mitigate gas spikes
    },
  },
  etherscan: {
    apiKey: {
      // Configuration binding to allow contract code verification via BaseScan
      base: process.env.BASESCAN_API_KEY || "PLACEHOLDER_KEY",
    },
    customChains: [
      {
        network: "base",
        chainId: 8453, // Explicit Base Mainnet Chain ID registration
        urls: {
          apiURL: "https://basescan.org",
          browserURL: "https://basescan.org",
        },
      },
    ],
  },
};
