// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { ERC20 } from "solmate/tokens/ERC20.sol";

contract BaseWrapper is ERC20 {
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
        
    //TODO better to handle 1:1 as ratio = 10000 or something like that
    function getRatio() public view virtual returns (uint256) {
        return 1;
    }

    function wrap(
    	uint256 _tokenAmount, 
    	address _receiver
    ) external returns (uint256 wrapperAmount) {
        require(_tokenAmount > 0, "positive-amount-only");

    	WRAPPED.transferFrom(msg.sender, address(this), _tokenAmount);

    	uint256 ratio = getRatio();
    	wrapperAmount = _tokenAmount * ratio;
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
        require(_wrapperAmount > 0, "positive-amount-only");

    	uint256 ratio = getRatio();
    	tokenAmount = _wrapperAmount / ratio;

    	WRAPPED.transfer(_receiver, tokenAmount);
        _burn(msg.sender, _wrapperAmount);

        emit Wrap(
            msg.sender, 
            _receiver,
            tokenAmount,
            _wrapperAmount,
            ratio
        );
    }
}