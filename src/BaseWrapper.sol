// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { ERC20 } from "solmate/tokens/ERC20.sol";

abstract contract BaseWrapper is ERC20 {
    uint256 public constant UNIT = 1 ether;

	ERC20 public WRAPPED;

	event Wrap(
        address indexed from, 
        address indexed to, 
        uint256 tokenAmount,
        uint256 wrapperAmount,
        uint256 ratio
    );
	event Unwrap(
        address indexed from, 
        address indexed to, 
        uint256 tokenAmount,
        uint256 wrapperAmount,
        uint256 ratio
    );

    constructor(
    	address _token,
    	string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) ERC20(_name, _symbol, _decimals) {
    	WRAPPED = ERC20(_token);
    }
        
    function getWrapRatio(uint256 _tokenAmount) public view virtual returns (uint256);
    function getUnwrapRatio(uint256 _wrapperAmount) public view virtual returns (uint256);

    function wrap(
    	uint256 _tokenAmount, 
    	address _receiver
    ) external returns (uint256 wrapperAmount) {
        if (_tokenAmount == 0) revert PositiveAmountOnly();

    	WRAPPED.transferFrom(msg.sender, address(this), _tokenAmount);

    	uint256 ratio = getWrapRatio(_tokenAmount);
    	wrapperAmount = _tokenAmount * ratio / UNIT;
        _mint(_receiver, wrapperAmount);

        emit Wrap(
            msg.sender, 
            _receiver,
            _tokenAmount,
            wrapperAmount,
            ratio
        );
    }

    function unwrap(
    	uint256 _wrapperAmount, 
    	address _receiver
    ) external returns (uint256 tokenAmount) {
        if (_wrapperAmount == 0) revert PositiveAmountOnly();

    	uint256 ratio = getUnwrapRatio(_wrapperAmount);
    	tokenAmount = _wrapperAmount / ratio * UNIT;
    	WRAPPED.transfer(_receiver, tokenAmount);
        _burn(msg.sender, _wrapperAmount);

        emit Unwrap(
            msg.sender, 
            _receiver,
            tokenAmount,
            _wrapperAmount,
            ratio
        );
    }

    error PositiveAmountOnly();
}