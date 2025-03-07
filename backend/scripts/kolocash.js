// Doc : https://docs.openzeppelin.com/learn/upgrading-smart-contracts#initialization
const { ethers, upgrades } = require("hardhat");
const { vars } = require("hardhat/config");

// Récupère les adresses depuis les variables d'environnement, ou utilise des valeurs par défaut.
const treasuryWallet = vars.get("TREASURY_ADDRESS") || "0x";
const liquidityWallet = vars.get("LIQUIDITY_ADDRESS") || "0x";
const impactWallet = vars.get("IMPACT_ADDRESS") || "0x";
const daoKoloContract = vars.get("DAO_ADDRESS") || "0x";

async function main() {
  const Kolocash = await ethers.getContractFactory("Kolocash");
  const kolocash = await upgrades.deployProxy(
    Kolocash,
    [treasuryWallet, liquidityWallet, impactWallet, daoKoloContract],
    {
      initializer: "initialize",
    }
  );
  await kolocash.waitForDeployment();
  console.log("kolocash deployed to:", await kolocash.getAddress());
}

main();

// npx hardhat run scripts/kolocash.js
