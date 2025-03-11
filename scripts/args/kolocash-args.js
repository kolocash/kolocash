const treasuryWallet = vars.get("TREASURY_ADDRESS") || "0x";
const liquidityWallet = vars.get("LIQUIDITY_ADDRESS") || "0x";
const impactWallet = vars.get("IMPACT_ADDRESS") || "0x";
const daoKoloContract = vars.get("DAO_ADDRESS") || "0x";

module.exports = [
  treasuryWallet,
  liquidityWallet,
  impactWallet,
  daoKoloContract,
];
