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
    
    
    //for 1:1 wrap:unwrap ratio must be 10**18
    function deployFixedRatioWrapper(
        address _token,
        uint256 _ratio,
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) external returns (FixedRatioWrapper wrapper) {
        if (_ratio == 0) revert RatioMustBePositive();

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

    error RatioMustBePositive();
}