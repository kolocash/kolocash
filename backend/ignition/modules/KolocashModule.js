const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("KolocashModule", (m) => {
  // Get the account that will own the proxy admin
  const proxyAdminOwner = m.getAccount(0);

  // Deploy the Kolocash implementation contract.
  // This is your upgradeable token contract that contains the logic.
  const kolocashImpl = m.contract("Kolocash", []);

  // Define the parameters for the initialize() function.
  // Replace these addresses with the proper ones for your environment.
  const treasuryWallet = process.env.TREASURY_ADDRESS;
  const liquidityWallet = process.env.LIQUIDITY_ADDRESS;
  const impactWallet = process.env.IMPACT_ADDRESS;
  const daoKoloContract = process.env.DAOKOLO_ADDRESS;

  // Encode the initializer call.
  // This will call initialize(treasuryWallet, liquidityWallet, impactWallet, daoKoloContract)
  // on the implementation contract once the proxy is deployed.
  const initData = m.encodeFunctionCall(kolocashImpl, "initialize", [
    treasuryWallet,
    liquidityWallet,
    impactWallet,
    daoKoloContract,
  ]);

  // Deploy the TransparentUpgradeableProxy contract.
  // Its constructor takes three arguments:
  //   1. The implementation contract address.
  //   2. The proxy admin owner address.
  //   3. The initialization data (encoded initializer call).
  const proxy = m.contract("TransparentUpgradeableProxy", [
    kolocashImpl,
    proxyAdminOwner,
    initData,
  ]);

  // Read the "AdminChanged" event from the proxy deployment to get the ProxyAdmin address.
  // This event is emitted by the proxy constructor.
  const proxyAdminAddress = m.readEventArgument(
    proxy,
    "AdminChanged",
    "newAdmin"
  );

  // Create a contract instance for ProxyAdmin using its ABI at the given address.
  const proxyAdmin = m.contractAt("ProxyAdmin", proxyAdminAddress);

  return { proxyAdmin, proxy };
});
