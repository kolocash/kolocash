require("@nomicfoundation/hardhat-toolbox");
require("@openzeppelin/hardhat-upgrades");

// npx hardhat vars list
// npx hardhat vars set TEST_API_KEY
const INFURA_API_KEY = vars.get("INFURA_API_KEY");

/** @type import('hardhat/config').HardhatUserConfig */
// https://docs.metamask.io/services/get-started/endpoints/
module.exports = {
  solidity: "0.8.28",
  networks: {
    amoy: {
      url: `https://polygon-amoy.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [vars.get("TEST_PK")],
    },
    polygon: {
      url: `https://polygon-mainnet.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [vars.get("MAIN_PK")],
    },
  },
};
