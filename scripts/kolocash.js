const { ethers, upgrades } = require("hardhat");

const { vars } = require("hardhat/config");

// Liquidity and Impact Wallet
const liquidityWallet = vars.get("LIQUIDITY_ADDRESS") || "0x";
const impactWallet = vars.get("IMPACT_ADDRESS") || "0x";

async function main() {
  // Déploiement du contrat Kolocash
  const Kolocash = await ethers.getContractFactory("Kolocash");
  console.log("Déploiement de Kolocash...");
  const kolocash = await upgrades.deployProxy(
    Kolocash,
    [liquidityWallet, impactWallet],
    {
      initializer: "initialize",
    }
  );
  await kolocash.waitForDeployment();
  const kolocashAddress = await kolocash.getAddress();
  console.log("Kolocash déployé à :", kolocashAddress);
}

main().catch((error) => {
  console.error("Erreur lors du déploiement :", error);
  process.exitCode = 1;
});

// npx hardhat clean && npx hardhat run scripts/kolocash.js --network localhost
