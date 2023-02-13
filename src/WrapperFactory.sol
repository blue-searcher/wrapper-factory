// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import "./wrappers/FixedRatioWrapper.sol";

contract WrapperFactory {

    event NewWrapper(
        address indexed wrapper, 
        address indexed token, 
        address creator,
        uint256 ratio
    );

    constructor() {
    }
    
    //wstETH
    //https://etherscan.io/token/0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0#code
    
    function deployFixedRatioWrapper(
        address _token,
        uint256 _ratio,
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) external returns (FixedRatioWrapper wrapper) {
        wrapper = new FixedRatioWrapper(
            _token,
            _ratio,
            _name,
            _symbol,
            _decimals
        );

        emit NewWrapper(
            address(wrapper),
            _token,
            msg.sender,
            _ratio
        );
    }
}