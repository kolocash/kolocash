const { ethers } = require("hardhat");
const { vars } = require("hardhat/config");

// Retrieve the governance token address from environment variables.
const governanceTokenAddress = vars.get("GOVERNANCE_TOKEN_ADDRESS");

async function main() {
  // Get the contract factory for KoloDAO.
  const KoloDAO = await ethers.getContractFactory("KoloDAO");

  // Deploy the contract
  const koloDAO = await KoloDAO.deploy(governanceTokenAddress);

  await koloDAO.deployed();
  console.log("KoloDAO deployed to:", koloDAO.address);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
