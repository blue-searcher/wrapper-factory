// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import "../BaseWrapper.sol";

/*
wstETH - like wrapper
*/

contract SharesBased is BaseWrapper {
    string public constant WRAPPER_DESCRIPTION = "Shares Based Wrapper";
    uint256 public constant WRAPPER_TYPE = 1;

    constructor(
        address _token,
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) BaseWrapper(_token, _name, _symbol, _decimals) {
    }

    function getWrapAmountOut(uint256 _tokenAmount) public view override returns (uint256) {
        uint256 totalTokens = WRAPPED.balanceOf(address(this));
        if (totalTokens == 0) {
            //Handle first wrap()
            return _tokenAmount;
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