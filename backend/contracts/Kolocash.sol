// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

/// @title Kolocash ($KOLO) - Sovereign currency for Africa and its diaspora
/// @author Charles EDOU NZE

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @custom:security-contact tech@kolo.cash
contract Kolocash is ERC20, ERC20Burnable, Ownable {
    uint256 public initialSupply = 100_000_000_000 * 10 ** 18; // 100 billion KOLOs

    // Wallet addresses for fund management

    /// @notice Treasury wallet to store a portion of the funds from transactions and project activities
    /// @dev Used for project development and infrastructure investments
    address public treasuryWallet;

    /// @notice Wallet that receives part of the transaction tax to reinforce liquidity on DEX platforms (e.g., Uniswap, Quickswap)
    /// @dev Helps to maintain liquidity and reduce volatility in trading platforms
    address public liquidityWallet;

    /// @notice Wallet that receives 1% of all transactions to fund social and economic projects in Africa
    /// @dev Supports microfinance, infrastructure, education, and intra-African trade
    address public impactWallet;

    /// @notice Address of the KOLO DAO that will manage these wallets
    address public daoKoloContract;

    /// @notice Total tax rate applied to transactions (4%)
    uint256 public taxRate = 4;

    /// @notice Events for transaction transparency
    event TaxDistributed(uint256 amount, address indexed to);
    event TokensBurned(uint256 amount);
    event WalletsUpdated(
        address indexed treasury,
        address indexed liquidity,
        address indexed impact
    );
    event DAOContractUpdated(address indexed newDAO);

    /// @notice Ensures only the KOLO DAO can modify wallet addresses
    modifier onlyDAO() {
        require(
            msg.sender == daoKoloContract,
            "Only KOLO DAO can modify this address"
        );
        _;
    }

    /// @notice Constructor that initializes wallets and the DAO contract
    constructor(
        address _treasury,
        address _liquidity,
        address _impact,
        address _daoKolo
    ) ERC20("Kolocash", "KOLO") Ownable(msg.sender) {
        require(
            _treasury != address(0) &&
                _liquidity != address(0) &&
                _impact != address(0),
            "Invalid wallet address"
        );
        require(_daoKolo != address(0), "Invalid KOLO DAO address");

        treasuryWallet = _treasury;
        liquidityWallet = _liquidity;
        impactWallet = _impact;
        daoKoloContract = _daoKolo;

        _mint(msg.sender, initialSupply); // Mint initial supply to the owner's address
        transferOwnership(msg.sender); // Transfer ownership to the specified initial owner
    }

    /// @notice Allows KOLO DAO to update the wallet addresses
    function updateWallets(
        address _treasury,
        address _liquidity,
        address _impact
    ) external onlyDAO {
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

    /// @notice Allows KOLO DAO to update its own contract address
    function updateDAOContract(address _newDAO) external onlyDAO {
        require(_newDAO != address(0), "Invalid DAO address");
        daoKoloContract = _newDAO;
        emit DAOContractUpdated(_newDAO);
    }

    /// @notice Taxation mechanism applied to each transaction (1% redistribution, 1% liquidity, 1% burn, 1% impact funding)
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal override {
        uint256 taxAmount = (amount * taxRate) / 100;
        uint256 burnAmount = taxAmount / 4;
        uint256 liquidityAmount = taxAmount / 4;
        uint256 impactAmount = taxAmount / 4;
        uint256 finalAmount = amount - taxAmount;

        super._transfer(sender, address(0), burnAmount); // Token burning
        super._transfer(sender, liquidityWallet, liquidityAmount); // Liquidity allocation
        super._transfer(sender, impactWallet, impactAmount); // Funding African impact projects
        super._transfer(sender, recipient, finalAmount);

        emit TokensBurned(burnAmount);
        emit TaxDistributed(liquidityAmount, liquidityWallet);
        emit TaxDistributed(impactAmount, impactWallet);
    }

    /// @notice Function to mint new tokens (only the initial owner or eventually KOLO DAO)
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
