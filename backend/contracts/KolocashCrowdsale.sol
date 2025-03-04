// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

import "./Kolocash.sol";

contract KolocashCrowdsale is Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    Kolocash public token; // Le token KOLO que tu vends
    uint public rate = 1500; // Taux de conversion (ETH -> KOLO) :  1 ETH = 1500 KOLO
    uint public weiRaised; // Montant total collecté en ETH

    event TokensPurchased(address indexed purchaser, uint amount, uint cost);

    // constructor(uint256 _rate, address _wallet, IERC20 _token)
    constructor()
        Ownable(msg.sender) // Passer l'adresse du propriétaire initial au constructeur d'Ownable
    {
        require(
            msg.sender != address(0),
            "Crowdsale: wallet is the zero address"
        );
        // require(_rate > 0, "Crowdsale: rate is 0");
        // require(address(_token) != address(0), "Crowdsale: token is the zero address");

        // token = _token; // Le contrat du token KOLO
        token = new Kolocash();
        // rate = _rate; // Par exemple : 1 ETH = 1500 KOLO
    }

    receive() external payable {
        require(msg.value >= 0.1 ether, "You can't send less than 0.1 ether");
    }

    // Fonction principale pour acheter des tokens
    function buyTokens() public payable nonReentrant {
        uint weiAmount = msg.value; // Montant envoyé en ETH
        require(weiAmount > 0, "Crowdsale: no ETH sent");

        // Calcul du nombre de tokens à envoyer
        uint256 tokens = _getTokenAmount(weiAmount);

        // Vérifier que la vente peut se faire (balance suffisante du contrat)
        require(
            token.balanceOf(address(this)) >= tokens,
            "Crowdsale: not enough tokens"
        );

        weiRaised += weiAmount; // Mettre à jour le montant total collecté

        // Transfert des tokens à l'acheteur
        token.transfer(msg.sender, tokens);

        emit TokensPurchased(msg.sender, tokens, weiAmount);

        // Transfert des ETH à l'adresse propriétaire (qui gère la collecte)
        payable(owner()).transfer(weiAmount);
    }

    // Calcul du nombre de tokens en fonction de l'ETH envoyé
    function _getTokenAmount(
        uint256 weiAmount
    ) internal view returns (uint256) {
        return weiAmount * rate;
    }

    // Permet au propriétaire de retirer les tokens non vendus après la crowdsale
    function withdrawTokens() external onlyOwner {
        uint256 remainingTokens = token.balanceOf(address(this));
        require(remainingTokens > 0, "Crowdsale: no tokens to withdraw");

        token.transfer(owner(), remainingTokens); // Envoyer les tokens non vendus au propriétaire
    }
}
