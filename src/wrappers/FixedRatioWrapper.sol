// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import "../BaseWrapper.sol";

contract FixedRatioWrapper is BaseWrapper {
    string public constant WRAPPER_TYPE = "Fixed Ratio Wrapper";

    uint256 public ratio;

    constructor(
        address _token,
        uint256 _ratio,
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) BaseWrapper(_token, _name, _symbol, _decimals) {
        ratio = _ratio;
    }

    function getRatio() public view override returns (uint256) {
        return ratio;
    }
}