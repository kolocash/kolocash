// Doc : https://docs.openzeppelin.com/learn/upgrading-smart-contracts#initialization
const { ethers, upgrades } = require("hardhat");

async function main() {
  const Kolocash = await ethers.getContractFactory("Kolocash");
  const kolocash = await upgrades.deployProxy(Kolocash, [], {
    initializer: "initialize",
  });
  await kolocash.waitForDeployment();
  console.log("kolocash deployed to:", await kolocash.getAddress());
}

main();

// npx hardhat run scripts/kolocash.js
