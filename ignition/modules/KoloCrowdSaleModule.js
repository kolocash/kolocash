const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

const KOLOCASH_TOKEN_ADDRESS = "0x6dF8650a3ba32ad04F19C92f833536D0ad91df7A";

module.exports = buildModule("KoloCrowdSaleModule", (m) => {
  // Déploiement du contrat KoloCrowdSale
  const koloCrowdSale = m.contract("KoloCrowdSale", [KOLOCASH_TOKEN_ADDRESS]);

  return { koloCrowdSale };
});
