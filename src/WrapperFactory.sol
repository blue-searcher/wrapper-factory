// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import "./wrappers/WrapperToken.sol";

contract WrapperFactory {
    uint256 public nextId;
    mapping(uint256 => address) public wrapperById;

    event NewWrapper(
        address indexed wrapper, 
        address indexed token, 
        address creator,
        uint256 id
    );

    function deploy(
        address _token,
        uint256 _initialRatio,
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) external returns (WrapperToken wrapper) {
        if (_initialRatio == 0) revert RatioMustBePositive();

        wrapper = new WrapperToken(
            _token,
            _initialRatio,
            _name,
            _symbol,
            _decimals
        );

        wrapperById[nextId] = address(wrapper);

        emit NewWrapper(
            address(wrapper),
            _token,
            msg.sender,
            nextId
        );

        nextId += 1;
    }

    error RatioMustBePositive();
}