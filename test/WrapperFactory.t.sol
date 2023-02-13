// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/WrapperFactory.sol";
import "src/wrappers/FixedRatioWrapper.sol";

contract WrapperFactoryTest is Test {
    WrapperFactory public factory;

    function setUp() public {
        factory = new WrapperFactory();

        wETH = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
        USDC = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    }

    function testFixedRatio() public {
        FixedRatioWrapper wrapper = factory.deployFixedRatioWrapper(
            address(USDC),
            1,
            "wrapped USDC",
            "wUSDC",
            18
        );

        //TODO Expect event emit
        //TODO Assert wrapper.WRAPPER_TYPE to be Fixed Ratio Wrapper
        //TODO Assert wrapper token name, symbol and decimals 
    }

    //Other tests:
    // - different decimals
    // - different ratios
    // - different token param
}
