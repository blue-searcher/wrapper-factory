// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { ERC20 } from "solmate/tokens/ERC20.sol";

abstract contract BaseWrapper is ERC20 {
    ERC20 public WRAPPED;

    event Wrap(
        address indexed from, 
        address indexed to, 
        uint256 tokenAmount,
        uint256 wrapperAmount
    );
    event Unwrap(
        address indexed from, 
        address indexed to, 
        uint256 tokenAmount,
        uint256 wrapperAmount
    );

    constructor(
    	address _token,
    	string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) ERC20(_name, _symbol, _decimals) {
    	WRAPPED = ERC20(_token);
    }
        
    function getWrapAmountOut(uint256 _tokenAmount) public view virtual returns (uint256);
    function getUnwrapAmountOut(uint256 _wrapperAmount) public view virtual returns (uint256);

    function wrap(
    	uint256 _tokenAmount, 
    	address _receiver
    ) external returns (uint256 wrapperAmount) {
        if (_tokenAmount == 0) revert PositiveAmountOnly();

    	wrapperAmount = getWrapAmountOut(_tokenAmount);
        
        _mint(_receiver, wrapperAmount);
        WRAPPED.transferFrom(msg.sender, address(this), _tokenAmount);

        emit Wrap(
            msg.sender, 
            _receiver,
            _tokenAmount,
            wrapperAmount
        );
    }

    function unwrap(
    	uint256 _wrapperAmount, 
    	address _receiver
    ) external returns (uint256 tokenAmount) {
        if (_wrapperAmount == 0) revert PositiveAmountOnly();

        tokenAmount = getUnwrapAmountOut(_wrapperAmount);

        _burn(msg.sender, _wrapperAmount);
    	WRAPPED.transfer(_receiver, tokenAmount);

        emit Unwrap(
            msg.sender, 
            _receiver,
            tokenAmount,
            _wrapperAmount
        );
    }

    error PositiveAmountOnly();
}