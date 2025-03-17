// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./Authorizable.sol";

/**
 * @title KoloCrowdSale
 * @dev Contrat de vente de tokens KOLO contre POL sur le réseau Polygon.
 */
contract KoloCrowdSale is Authorizable, ReentrancyGuard {
    IERC20 public kolocashToken; // Adresse du token KOLO
    uint256 public rate = 20 * 10 ** 18; // Taux de conversion (1 POL = 20 KOLO => 1 KOLO = 0.01 EUR)
    uint256 public polygonRaised; // Montant total collecté en POL

    /**
     * @dev Événement déclenché lors de l'achat de tokens.
     * @param purchaser Adresse de l'acheteur
     * @param amount Montant de tokens achetés
     * @param cost Montant payé en POL
     */
    event TokensPurchased(
        address indexed purchaser,
        uint256 amount,
        uint256 cost
    );

    /**
     * @dev Constructeur du contrat.
     * @param _kolocashToken Adresse du contrat du token KOLO
     */
    constructor(IERC20 _kolocashToken) {
        require(
            address(_kolocashToken) != address(0),
            "Adresse du token invalide"
        );

        kolocashToken = _kolocashToken;
    }

    /**
     * @dev Met à jour le taux de conversion.
     * @param _newRate Le nouveau taux de conversion (nombre de KOLO par POL)
     */
    function setRate(uint256 _newRate) external onlyAuthorized {
        require(_newRate > 0, "Le nouveau taux doit etre superieur a zero");
        rate = _newRate;
    }

    /**
     * @dev Fonction fallback pour recevoir des fonds et acheter des tokens.
     */
    receive() external payable {
        buyTokens();
    }

    /**
     * @dev Fonction principale pour acheter des tokens KOLO.
     */
    function buyTokens() public payable nonReentrant {
        uint256 polygonAmount = msg.value;
        require(polygonAmount > 0, "Vous devez envoyer des fonds");

        uint256 tokens = _getTokenAmount(polygonAmount);
        require(
            kolocashToken.balanceOf(address(this)) >= tokens,
            "Pas assez de tokens dans le contrat"
        );

        polygonRaised += polygonAmount;

        kolocashToken.transfer(msg.sender, tokens);
        emit TokensPurchased(msg.sender, tokens, polygonAmount);

        payable(owner()).transfer(polygonAmount);
    }

    /**
     * @dev Calcul du nombre de tokens en fonction du montant envoyé.
     * @param polygonAmount Montant envoyé en POL
     * @return Nombre de tokens à transférer
     */
    function _getTokenAmount(
        uint256 polygonAmount
    ) internal view returns (uint256) {
        return polygonAmount * rate;
    }

    /**
     * @dev Retrait des tokens non vendus par le propriétaire.
     */
    function withdrawTokens() external onlyAuthorized {
        uint256 remainingTokens = kolocashToken.balanceOf(address(this));
        require(remainingTokens > 0, "Aucun token a retirer");

        kolocashToken.transfer(owner(), remainingTokens);
    }
}
