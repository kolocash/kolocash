const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

const GOVERNANCE_TOKEN_ADDRESS = "0xE28b99E2a7D4456a67d42bd9b8D27e47D8d0e2b2";

module.exports = buildModule("KoloDAOModule", (m) => {
  const governanceTokenAddress = m.getParameter(
    "governanceTokenAddress",
    GOVERNANCE_TOKEN_ADDRESS
  );

  const kolodao = m.contract("KoloDAO", [governanceTokenAddress]);

  return { kolodao };
});

// npx hardhat ignition deploy ignition/modules/KoloDAOModule.js --network amoy

// npx hardhat ignition deploy ignition/modules/KoloDAOModule.js --network polygon

// npx hardhat verify --network amoy 0xd50FF476888CA70be0359fFfaF47583545170E06 0xE28b99E2a7D4456a67d42bd9b8D27e47D8d0e2b2
