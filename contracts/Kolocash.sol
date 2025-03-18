// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

/**
 * @title Kolocash ($KOLO) - Sovereign currency for Africa and its diaspora (Upgradeable)
 * @notice This is an upgradeable ERC20 token with burn, pausable, permit, flash mint capabilities,
 *         access management, and a tax mechanism on transfers.
 * @dev Uses AccessManagedUpgradeable for access control.
 */

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import {ERC20BurnableUpgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import {ERC20PausableUpgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PausableUpgradeable.sol";
import {ERC20PermitUpgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PermitUpgradeable.sol";
import {ERC20FlashMintUpgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20FlashMintUpgradeable.sol";
import {AccessManagedUpgradeable} from "@openzeppelin/contracts-upgradeable/access/manager/AccessManagedUpgradeable.sol";

contract Kolocash is
    Initializable,
    ERC20Upgradeable,
    ERC20BurnableUpgradeable,
    ERC20PausableUpgradeable,
    AccessManagedUpgradeable,
    ERC20PermitUpgradeable,
    ERC20FlashMintUpgradeable
{
    // 100 billion KOLO tokens (with 18 decimals)
    uint256 public initialSupply;
    // Tax rate (e.g., 4% total tax on transfers)
    uint256 public taxRate;

    // Wallet addresses for fund management
    /// @notice Treasury wallet: stores a portion of funds for project development and infrastructure.
    address public treasuryWallet;
    /// @notice Liquidity wallet: receives part of the tax to reinforce liquidity on DEX platforms.
    address public liquidityWallet;
    /// @notice Impact wallet: receives part of the tax to fund social and economic projects in Africa.
    address public impactWallet;
    /// @notice DAO contract address that manages these wallets.
    address public daoKoloContract;

    // Events for transparency in tax operations
    event TaxDistributed(uint256 amount, address indexed to);
    event TokensBurned(uint256 amount);
    event WalletsUpdated(
        address indexed treasury,
        address indexed liquidity,
        address indexed impact
    );
    event DAOContractUpdated(address indexed newDAO);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /**
     * @notice Initialization function for the upgradeable token contract.
     * @param _treasury The initial treasury wallet address.
     * @param _liquidity The initial liquidity wallet address.
     * @param _impact The initial impact wallet address.
     * @param _daoKolo The initial DAO contract address.
     */
    function initialize(
        address _treasury,
        address _liquidity,
        address _impact,
        address _daoKolo
    ) public initializer {
        __ERC20_init("Kolocash", "KOLO");
        __ERC20Burnable_init();
        __ERC20Pausable_init();
        __AccessManaged_init(msg.sender);
        __ERC20Permit_init("Kolocash");
        __ERC20FlashMint_init();

        require(
            _treasury != address(0) &&
                _liquidity != address(0) &&
                _impact != address(0),
            "Invalid wallet address"
        );
        require(_daoKolo != address(0), "Invalid DAO address");

        treasuryWallet = _treasury;
        liquidityWallet = _liquidity;
        impactWallet = _impact;
        daoKoloContract = _daoKolo;

        taxRate = 4; // 4% tax rate
        initialSupply = 100_000_000_000 * 10 ** 18; // 100 billion KOLO tokens

        // Mint the initial supply to the contract itself
        _mint(address(this), initialSupply);
    }

    /**
     * @notice Allows the DAO to update wallet addresses.
     * @dev Restricted to addresses with the "restricted" role (defined in AccessManagedUpgradeable).
     */
    function updateWallets(
        address _treasury,
        address _liquidity,
        address _impact
    ) external restricted {
        require(
            _treasury != address(0) &&
                _liquidity != address(0) &&
                _impact != address(0),
            "Invalid address"
        );
        treasuryWallet = _treasury;
        liquidityWallet = _liquidity;
        impactWallet = _impact;
        emit WalletsUpdated(_treasury, _liquidity, _impact);
    }

    /**
     * @notice Allows the DAO to update its own contract address.
     */
    function updateDAOContract(address _newDAO) external restricted {
        require(_newDAO != address(0), "Invalid DAO address");
        daoKoloContract = _newDAO;
        emit DAOContractUpdated(_newDAO);
    }

    /**
     * @notice Pauses all token transfers.
     */
    function pause() public restricted {
        _pause();
    }

    /**
     * @notice Unpauses token transfers.
     */
    function unpause() public restricted {
        _unpause();
    }

    /**
     * @notice Mints new tokens.
     * @dev Restricted to addresses with the "restricted" role.
     */
    function mint(address to, uint256 amount) public restricted {
        _mint(to, amount);
    }

    /**
     * @notice Overrides the transfer function to apply a tax on each transfer.
     */
    function transfer(
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transferWithTax(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @notice Overrides the transferFrom function to apply a tax on each transfer.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _spendAllowance(sender, _msgSender(), amount);
        _transferWithTax(sender, recipient, amount);
        return true;
    }

    /**
     * @dev Internal function that applies the tax mechanism and executes transfers.
     * @param sender The address sending tokens.
     * @param recipient The address receiving tokens.
     * @param amount The total amount of tokens to transfer.
     */
    function _transferWithTax(
        address sender,
        address recipient,
        uint256 amount
    ) internal whenNotPaused {
        uint256 taxAmount = (amount * taxRate) / 100;
        uint256 burnAmount = taxAmount / 4;
        uint256 liquidityAmount = taxAmount / 4;
        uint256 impactAmount = taxAmount / 4;
        uint256 finalAmount = amount - taxAmount;

        // Burn tokens by transferring them to the zero address
        // super._transfer(sender, address(0), burnAmount);
        _burn(sender, burnAmount);

        // Transfer portion to the liquidity wallet
        super._transfer(sender, liquidityWallet, liquidityAmount);
        // Transfer portion to the impact wallet
        super._transfer(sender, impactWallet, impactAmount);
        // Transfer remaining tokens to the recipient
        super._transfer(sender, recipient, finalAmount);

        emit TokensBurned(burnAmount);
        emit TaxDistributed(liquidityAmount, liquidityWallet);
        emit TaxDistributed(impactAmount, impactWallet);
    }

    /**
     * @notice Overrides _update to resolve conflicts between ERC20Upgradeable and ERC20PausableUpgradeable.
     */
    function _update(
        address from,
        address to,
        uint256 value
    ) internal override(ERC20Upgradeable, ERC20PausableUpgradeable) {
        super._update(from, to, value);
    }
}
