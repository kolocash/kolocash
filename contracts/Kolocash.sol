// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @title Kolocash ($KOLO) - Sovereign currency for Africa and its diaspora (Upgradeable)
 * @notice KOLO is a next-generation token that supports off-chain approvals (ERC2612),
 *         pausable transfers, controlled minting, and burning.
 *         This contract is upgradeable and compatible with most EVM-based chains.
 *         It implements a transfer tax mechanism:
 *           - 1% added to liquidity,
 *           - 1% burned,
 *           - 1% allocated for social impact projects.
 *
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
    ERC20PermitUpgradeable,
    OwnableUpgradeable
{
    // Tax parameters
    bool public taxEnabled;
    uint256 public constant TAX_PERCENT = 1; // 1% for each category :Total tax = 3% per transfer

    // Wallets to collect the taxes
    address public liquidityWallet;
    address public socialImpactWallet;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /**
     * @notice Initializes the KOLO token.
     * @param _liquidityWallet Address receiving the liquidity tax.
     * @param _socialImpactWallet Address receiving the social impact tax.
     *
     * The full supply (100 billion KOLO tokens with 18 decimals) is minted to the contract.
     */
    function initialize(
        address _liquidityWallet,
        address _socialImpactWallet
    ) public initializer {
        __ERC20_init("Kolocash", "KOLO");
        __ERC20Burnable_init();
        __ERC20Pausable_init();
        __Ownable_init(msg.sender);
        __ERC20Permit_init("Kolocash");

        liquidityWallet = _liquidityWallet;
        socialImpactWallet = _socialImpactWallet;
        taxEnabled = true; // Enable tax by default

        // Mint full supply: 100 billion KOLO tokens
        _mint(address(this), 100_000_000_000 * 10 ** decimals());
    }

    /**
     * @notice Allows the owner to enable or disable the transfer tax.
     * @param _enabled True to enable tax, false to disable.
     */
    function setTaxEnabled(bool _enabled) external onlyOwner {
        taxEnabled = _enabled;
    }

    /**
     * @notice Sets the address to receive the liquidity tax.
     * @param _liquidityWallet Address to receive the liquidity tax.
     */
    function setLiquidityWallet(address _liquidityWallet) external onlyOwner {
        liquidityWallet = _liquidityWallet;
    }

    /**
     * @notice Sets the address to receive the social impact tax.
     * @param _socialImpactWallet Address to receive the social impact tax.
     */
    function setSocialImpactWallet(
        address _socialImpactWallet
    ) external onlyOwner {
        socialImpactWallet = _socialImpactWallet;
    }

    /**
     * @notice Transfers tokens from the contract's balance to a recipient.
     * @param _recipient Address that will receive the tokens.
     * @param _amount Number of tokens to transfer (in wei).
     */
    function transferTokens(
        address _recipient,
        uint256 _amount
    ) external onlyOwner {
        require(
            balanceOf(address(this)) >= _amount,
            "Insufficient contract balance"
        );
        _transfer(address(this), _recipient, _amount);
    }

    /**
     * @notice Pauses all token transfers.
     * @dev Can only be triggered by the owner.
     */
    function pause() public onlyOwner {
        _pause();
    }

    /**
     * @notice Resumes token transfers.
     * @dev Can only be triggered by the owner.
     */
    function unpause() public onlyOwner {
        _unpause();
    }

    /**
     * @notice Mints new KOLO tokens to a specified address.
     * @param to Address receiving the new tokens.
     * @param amount Number of tokens to mint (in wei).
     */
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    /**
     * @notice Overrides the transfer function to implement a transfer tax.
     * Tax breakdown:
     *   - 1% is sent to the liquidity wallet.
     *   - 1% is burned.
     *   - 1% is sent to the social impact wallet.
     * The recipient receives 97% of the transferred amount.
     */
    function transfer(
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        address sender = _msgSender();
        if (taxEnabled && sender != address(this)) {
            uint256 taxLiquidity = (amount * TAX_PERCENT) / 100;
            uint256 taxBurn = (amount * TAX_PERCENT) / 100;
            uint256 taxSocial = (amount * TAX_PERCENT) / 100;
            uint256 totalTax = taxLiquidity + taxBurn + taxSocial;
            uint256 netAmount = amount - totalTax;

            // Transfer net amount to recipient
            super._transfer(sender, recipient, netAmount);
            // Transfer liquidity tax to liquidity wallet
            super._transfer(sender, liquidityWallet, taxLiquidity);
            // Transfer social impact tax to social impact wallet
            super._transfer(sender, socialImpactWallet, taxSocial);
            // Burn the tax tokens
            _burn(sender, taxBurn);
            return true;
        } else {
            return super.transfer(recipient, amount);
        }
    }

    /**
     * @notice Overrides the transferFrom function to implement a transfer tax.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        if (taxEnabled && sender != address(this)) {
            uint256 taxLiquidity = (amount * TAX_PERCENT) / 100;
            uint256 taxBurn = (amount * TAX_PERCENT) / 100;
            uint256 taxSocial = (amount * TAX_PERCENT) / 100;
            uint256 totalTax = taxLiquidity + taxBurn + taxSocial;
            uint256 netAmount = amount - totalTax;

            // Deduct the full amount from the allowance
            _spendAllowance(sender, _msgSender(), amount);

            // Transfer net amount to recipient
            super._transfer(sender, recipient, netAmount);
            // Transfer liquidity tax to liquidity wallet
            super._transfer(sender, liquidityWallet, taxLiquidity);
            // Transfer social impact tax to social impact wallet
            super._transfer(sender, socialImpactWallet, taxSocial);
            // Burn the tax tokens
            _burn(sender, taxBurn);
            return true;
        } else {
            return super.transferFrom(sender, recipient, amount);
        }
    }

    /**
     * @notice Overrides the _update function to implement a transfer tax.
     */
    function _update(
        address from,
        address to,
        uint256 value
    ) internal override(ERC20Upgradeable, ERC20PausableUpgradeable) {
        super._update(from, to, value);
    }
}
