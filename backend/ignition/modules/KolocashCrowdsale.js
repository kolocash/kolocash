// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("KolocashCrowdsaleModule", (m) => {
  const KolocashCrowdsale = m.contract("KolocashCrowdsale", []);

  return { KolocashCrowdsale };
});

// npx hardhat ignition deploy ignition/modules/KolocashCrowdsale.js --network localhost
