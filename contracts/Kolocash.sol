// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @custom:security-contact tech@kolo.cash
contract Kolocash is ERC20, ERC20Burnable, Ownable {
    uint256 public initialSupply = 450000000; //
    // constructor(uint256 initialSupply)
    constructor() ERC20("Kolocash", "KOLO") Ownable(msg.sender) {
        _mint(msg.sender, initialSupply); // Mint initial supply to the owner's address
        transferOwnership(msg.sender); // Transfer ownership to the specified initial owner
    }

    // Function to mint new tokens, accessible only by the owner
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
