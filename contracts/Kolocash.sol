// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @title Kolocash ($KOLO) - Sovereign currency for Africa and its diaspora (Upgradeable)
 * @notice KOLO is a next-generation token that supports off-chain approvals (ERC2612),
 *         pausable transfers, controlled minting, and burning.
 *         This contract is upgradeable and compatible with most EVM-based chains.
 * @dev Based on OpenZeppelin ERC20 Upgradeable Modules.
 */

import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import {ERC20BurnableUpgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import {ERC20PausableUpgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PausableUpgradeable.sol";
import {ERC20PermitUpgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PermitUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

/// @custom:security-contact tech@kolo.cash
contract Kolocash is
    Initializable,
    ERC20Upgradeable,
    ERC20BurnableUpgradeable,
    ERC20PausableUpgradeable,
    OwnableUpgradeable,
    ERC20PermitUpgradeable
{
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /**
     * @notice Initializes the KOLO token.
     * @param recipient Address receiving the initial supply (usually the treasury or ICO wallet).
     * @param initialOwner Owner address that controls minting, pausing, etc.
     */
    function initialize(
        address recipient,
        address initialOwner
    ) public initializer {
        __ERC20_init("Kolocash", "KOLO");
        __ERC20Burnable_init();
        __ERC20Pausable_init();
        __Ownable_init(initialOwner);
        __ERC20Permit_init("Kolocash");

        // Mint the full supply (100B KOLO with 18 decimals) to the treasury wallet
        _mint(recipient, 100_000_000_000 * 10 ** decimals());
    }

    /**
     * @notice Pauses all token transfers.
     * @dev Can only be triggered by the contract owner.
     */
    function pause() public onlyOwner {
        _pause();
    }

    /**
     * @notice Resumes token transfers after being paused.
     * @dev Can only be triggered by the contract owner.
     */
    function unpause() public onlyOwner {
        _unpause();
    }

    /**
     * @notice Mints new KOLO tokens to a specified address.
     * @param to Address that will receive the new tokens.
     * @param amount Number of tokens to mint (in wei).
     */
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    /**
     * @notice Internal function override required by Solidity.
     * @dev Combines update logic from ERC20 and ERC20Pausable.
     */
    function _update(
        address from,
        address to,
        uint256 value
    ) internal override(ERC20Upgradeable, ERC20PausableUpgradeable) {
        super._update(from, to, value);
    }
}
