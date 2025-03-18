const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");
const { parseUnits } = require("ethers");

const KOLOCASH_TOKEN_ADDRESS = "0xE28b99E2a7D4456a67d42bd9b8D27e47D8d0e2b2";
const AMOUNT_TO_TRANSFER = parseUnits("100000000", 18); // 100M KOLO

module.exports = buildModule("KoloCrowdSaleModule", (m) => {
  // Chargement du contrat Kolocash
  // const kolocashToken = m.contractAt("Kolocash", KOLOCASH_TOKEN_ADDRESS);

  // Déploiement du contrat KoloCrowdSale
  const koloCrowdSale = m.contract("KoloCrowdSale", [KOLOCASH_TOKEN_ADDRESS]);

  // // Étape 1 : Approve
  // m.call(kolocashToken, "approve", [koloCrowdSale, AMOUNT_TO_TRANSFER]);

  // // Étape 2 : Transfert depuis l’owner vers le crowdsale
  // m.call(kolocashToken, "transferFrom", [
  //   m.getAccount(0), // le déployeur par défaut
  //   koloCrowdSale,
  //   AMOUNT_TO_TRANSFER,
  // ]);

  return { koloCrowdSale };
});
