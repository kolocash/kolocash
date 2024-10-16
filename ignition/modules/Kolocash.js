// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("KolocashModule", (m) => {
  const Kolocash = m.contract("Kolocash", []);

  return { Kolocash };
});

// npx hardhat ignition deploy ignition/modules/Kolocash.js --network localhost
