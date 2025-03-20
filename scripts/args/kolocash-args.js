console.log("args/kolocash-args.js");
const { vars } = require("hardhat/config");

// Liquidity and Impact Wallet
const liquidityWallet = vars.get("LIQUIDITY_ADDRESS") || "0x";
const impactWallet = vars.get("IMPACT_ADDRESS") || "0x";

console.log(
  `liquidityWallet: ${liquidityWallet}, impactWallet: ${impactWallet}`
);

module.exports = [liquidityWallet, impactWallet];
