// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import "../BaseWrapper.sol";

/*
wstETH - like wrapper
*/

contract SharesBased is BaseWrapper {
    string public constant WRAPPER_TYPE = "Shares Based Wrapper";

    constructor(
        address _token,
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) BaseWrapper(_token, _name, _symbol, _decimals) {
    }

    function getWrapRatio(uint256 _tokenAmount) public view override returns (uint256) {
        uint256 totalTokens = WRAPPED.balanceOf(address(this));
        if (totalTokens == 0) {
            //Handle first ever wrap()
            return _tokenAmount;
        }
        return _tokenAmount * totalSupply / totalTokens;
    }

    function getUnwrapRatio(uint256 _wrapperAmount) public view override returns (uint256) {
        if (totalSupply == 0) {
            return 0;
        }
        uint256 totalTokens = WRAPPED.balanceOf(address(this));
        return _wrapperAmount * totalTokens / totalSupply;
    }
}