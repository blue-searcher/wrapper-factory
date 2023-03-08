// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import "./wrappers/FixedRatio.sol";
import "./wrappers/SharesBased.sol";

contract WrapperFactory {
    uint256 public nextId;
    mapping(uint256 => address) public wrapperById;

    event NewWrapper(
        address indexed wrapper, 
        address indexed token, 
        uint256 indexed wrapperType,
        address creator,
        uint256 id
    );

    constructor() {
    }
    
    
    //for 1:1 wrap:unwrap ratio must be 10**18
    function deployFixedRatio(
        address _token,
        uint256 _ratio,
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) external returns (FixedRatio wrapper) {
        if (_ratio == 0) revert RatioMustBePositive();

        wrapper = new FixedRatio(
            _token,
            _ratio,
            _name,
            _symbol,
            _decimals
        );

        wrapperById[nextId] = address(wrapper);

        emit NewWrapper(
            address(wrapper),
            _token,
            wrapper.WRAPPER_TYPE(),
            msg.sender,
            nextId
        );

        nextId += 1;
    }

    function deploySharesBased(
        address _token,
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) external returns (SharesBased wrapper) {
        wrapper = new SharesBased(
            _token,
            _name,
            _symbol,
            _decimals
        );

        wrapperById[nextId] = address(wrapper);

        emit NewWrapper(
            address(wrapper),
            _token,
            wrapper.WRAPPER_TYPE(),
            msg.sender,
            nextId
        );

        nextId += 1;
    }

    error RatioMustBePositive();
}