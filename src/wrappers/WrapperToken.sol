// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import "../BaseWrapper.sol";

contract WrapperToken is BaseWrapper {
    uint256 public initialRatio;

    constructor(
        address _token,
        uint256 _initialRatio,
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) BaseWrapper(_token, _name, _symbol, _decimals) {
        initialRatio = _initialRatio;
    }

    function getWrapAmountOut(uint256 _tokenAmount) public view override returns (uint256) {
        uint256 totalTokens = WRAPPED.balanceOf(address(this));
        if (totalTokens == 0) {
            //Handle first wrap
            return initialRatio * _tokenAmount / UNIT;
        }
        return _tokenAmount * totalSupply / totalTokens;
    }

    function getUnwrapAmountOut(uint256 _wrapperAmount) public view override returns (uint256) {
        if (totalSupply == 0) {
            return 0;
        }
        uint256 totalTokens = WRAPPED.balanceOf(address(this));
        return _wrapperAmount * totalTokens / totalSupply;
    }
}