// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import "../BaseWrapper.sol";

/*
https://etherscan.io/address/0xd0660cd418a64a1d44e9214ad8e459324d8157f1#code

1 YFI = 1,000,000 WOOFY

YFI     is 18 decimals
WOOFY   is 12 decimals

wrapperAmount = tokenAmount * ratio / UNIT
1000000*10**12 = 10**18 * x / 10**18
1000000*10**12 = x


example:
https://etherscan.io/tx/0x8af641514fe515690caf5d1ac913b1bf968dfb8a840ac9361a84fb4c5dfa8ecc

wrap(29885875670327548 YFI)

wrapperAmount = 29885875670327548 * 1000000*10**12 / 10**18
wrapperAmount = 29885875670327548 WOOFY
wrapperAmount = 29885.875670327548 * 10**12 WOOFY
*/

contract FixedRatio is BaseWrapper {
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

    function getWrapRatio(uint256) public view override returns (uint256) {
        return ratio;
    }

    function getUnwrapRatio(uint256) public view override returns (uint256) {
        return ratio;
    }
}