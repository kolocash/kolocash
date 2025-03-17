const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

const KOLOCASH_TOKEN_ADDRESS = "0x1ACcBD355245AbA93CE46D33ab1D0152CE33Fd00";

module.exports = buildModule("KoloCrowdSaleModule", (m) => {
  const kolocashTokenAddress = m.getParameter(
    "kolocashTokenAddress",
    KOLOCASH_TOKEN_ADDRESS
  );

  const koloCrowdSale = m.contract("KoloCrowdSale", [kolocashTokenAddress]);

  return { koloCrowdSale };
});

// npx hardhat ignition deploy ignition/modules/KoloCrowdSaleModule.js --network localhost

// npx hardhat ignition deploy ignition/modules/KoloCrowdSaleModule.js --network amoy

// npx hardhat ignition deploy ignition/modules/KoloCrowdSaleModule.js --network polygon

// npx hardhat verify --network amoy 0xd50FF476888CA70be0359fFfaF47583545170E06 0x1ACcBD355245AbA93CE46D33ab1D0152CE33Fd00
