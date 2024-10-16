# Kolocash

## Compilation des contrat

```shell
npx hardhat compile
```

## Démarrage de la blockchain locale

```shell
npx hardhat node
```

Le démarrage se fait sur `http://localhost:8545`

## Déploiement d'un contrat sur la blockchain de Hardhat

Exemple avec le contrat Kolocash :

```shell
npx hardhat ignition deploy ignition/modules/Kolocash.js --network localhost
```
