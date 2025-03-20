const { ethers, upgrades } = require("hardhat");

async function main() {
  // Déploiement du contrat Kolocash
  const Kolocash = await ethers.getContractFactory("Kolocash");
  console.log("Déploiement de Kolocash...");
  const kolocash = await upgrades.deployProxy(Kolocash, [], {
    initializer: "initialize",
  });
  await kolocash.waitForDeployment();
  const kolocashAddress = await kolocash.getAddress();
  console.log("Kolocash déployé à :", kolocashAddress);

  // Déploiement du contrat KoloCrowdSale
  // const KoloCrowdSale = await ethers.getContractFactory("KoloCrowdSale");
  // console.log("Déploiement de KoloCrowdSale...");
  // const koloCrowdSale = await KoloCrowdSale.deploy(kolocashAddress);
  // await koloCrowdSale.waitForDeployment();
  // const koloCrowdSaleAddress = await koloCrowdSale.getAddress();
  // console.log("KoloCrowdSale déployé à :", koloCrowdSaleAddress);
}

main().catch((error) => {
  console.error("Erreur lors du déploiement :", error);
  process.exitCode = 1;
});

// npx hardhat clean && npx hardhat run scripts/kolocash.js --network localhost
