// npx hardhat ignition deploy ignition/modules/KoloDAO.js --network localhost

const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");
const { upgrades } = require("hardhat");

module.exports = buildModule("KoloDAOModule", async (m) => {
  // Récupère le compte administrateur (qui sera l'initiateur du déploiement)
  const admin = m.getAccount(0);

  // Vous devez définir l'adresse de votre token ERC20Votes (Kolocash) déployé sur votre réseau dev
  // et l'adresse du TimelockControllerUpgradeable (déployé également au préalable).
  // Ces adresses peuvent être stockées dans un fichier de configuration ou définies ici.
  const tokenAddress = "0xYourTokenAddressHere"; // Remplacez par l'adresse réelle du token Kolocash
  const timelockAddress = "0xYourTimelockAddressHere"; // Remplacez par l'adresse réelle du Timelock

  // Récupère le contrat KoloDAO (votre contrat upgradeable) compilé
  const KoloDAO = m.contract("KoloDAO", []);

  // Déploie le proxy upgradeable avec la méthode deployProxy
  // Les paramètres passés à initialize doivent correspondre à ceux définis dans la fonction initialize du contrat :
  // (IVotes _token, TimelockControllerUpgradeable _timelock, uint48 votingDelayBlocks, uint32 votingPeriodBlocks, uint256 proposalThresholdTokens)
  // Ici, on choisit par exemple : 1 bloc de delay, 45818 blocs pour une période de vote (~1 semaine) et 0 seuil de proposition.
  const proxy = await upgrades.deployProxy(
    KoloDAO,
    [tokenAddress, timelockAddress, 1, 45818, 0],
    { initializer: "initialize", from: admin }
  );
  await proxy.deployed();

  // On retourne le contrat déployé pour pouvoir l'utiliser dans d'autres modules ou tests.
  return { KoloDAO: proxy };
});
