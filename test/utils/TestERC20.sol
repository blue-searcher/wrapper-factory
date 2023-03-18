// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import { ERC20 } from "solmate/tokens/ERC20.sol";

contract TestERC20 is ERC20 {
    constructor(
        string memory _symbol, 
        string memory _name,
        uint8 _decimals
    ) ERC20(_name, _symbol, _decimals) {
    }

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }

    function burn(address to, uint256 amount) external {
        _burn(to, amount);
    }
}