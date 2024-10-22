# Kolocash

## Compilation des contrats

```shell
$ npx hardhat compile
```

## Démarrage de la blockchain locale

```shell
$ npx hardhat node
```

Le démarrage se fait sur `http://localhost:8545`

## Déploiement d'un contrat sur la blockchain de Hardhat

Exemple avec le contrat Kolocash :

```shell
$ npx hardhat ignition deploy ignition/modules/Kolocash.js --network localhost
```

Si tout s'est bien passé, vous devriez avoir quelque chose qui ressemble à ça :

```shell
Hardhat Ignition 🚀

Resuming existing deployment from ./ignition/deployments/chain-31337

Deploying [ KolocashCrowdsaleModule ]

Warning - previously executed futures are not in the module:
 - KolocashModule#Kolocash

Batch #1
  Executed KolocashCrowdsaleModule#KolocashCrowdsale

[ KolocashCrowdsaleModule ] successfully deployed 🚀

Deployed Addresses

KolocashModule#Kolocash - 0x5FbDB2315678afecb367f032d93F642f64180aa3
KolocashCrowdsaleModule#KolocashCrowdsale - 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512
```

Déploiement avec l'ancienne version (script) :

```shell
npx hardhat run scripts/script.js --network localhost
```

Avec le fichier `script.js` qui contient le code nécessaire au déploiement.

Exemple le contrat `Lock.sol` :

```javascript
// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// Run COMMAND : npx hardhat run scripts/script.js --network localhost

// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.

const hre = require("hardhat");

async function main() {
  const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  const unlockTime = currentTimestampInSeconds + 60;

  const lockedAmount = hre.ethers.parseEther("0.001");

  const lock = await hre.ethers.deployContract("Lock", [unlockTime], {
    value: lockedAmount,
  });

  await lock.waitForDeployment();

  console.log(
    `Lock with ${ethers.formatEther(
      lockedAmount
    )}ETH and unlock timestamp ${unlockTime} deployed to ${lock.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
```
