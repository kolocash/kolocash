const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");
const { upgrades } = require("hardhat");

module.exports = buildModule("Kolocash", async (m) => {
  // Récupère le compte administrateur (celui qui déploiera le contrat)
  const admin = m.getAccount(0);

  // Définissez ici les adresses initiales pour les wallets et le DAO.
  // Ces adresses peuvent être remplacées par des valeurs de configuration ou des variables d'environnement.
  const treasuryWallet = "0x1234567890123456789012345678901234567890"; // Remplacez par l'adresse réelle du wallet Treasury
  const liquidityWallet = "0x2345678901234567890123456789012345678901"; // Remplacez par l'adresse réelle du wallet Liquidity
  const impactWallet = "0x3456789012345678901234567890123456789012"; // Remplacez par l'adresse réelle du wallet Impact
  const daoKoloContract = "0x4567890123456789012345678901234567890123"; // Remplacez par l'adresse réelle du contrat DAO

  // Charge le contrat Kolocash compilé
  const Kolocash = m.contract("Kolocash", []);

  // Déploie le contrat Kolocash en mode upgradeable via deployProxy.
  // La fonction "initialize" sera appelée automatiquement avec les paramètres spécifiés.
  const proxy = await upgrades.deployProxy(
    Kolocash,
    [treasuryWallet, liquidityWallet, impactWallet, daoKoloContract],
    { initializer: "initialize", from: admin }
  );
  await proxy.deployed();

  return { Kolocash: proxy };
});
