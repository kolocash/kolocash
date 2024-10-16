# Kolocash

## Compilation des contrat

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
