// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/WrapperFactory.sol";
import "src/wrappers/FixedRatioWrapper.sol";

contract WrapperFactoryTest is Test {
    WrapperFactory public factory;

    ERC20 public wETH;
    ERC20 public USDC;

    function setUp() public {
        factory = new WrapperFactory();

        wETH = ERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
        USDC = ERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    }

    function testFixedRatio() public {
        string memory name = "wrapped USDC";
        string memory symbol = "wUSDC";
        uint8 decimals = 18;
        uint256 ratio = 1;

        FixedRatioWrapper wrapper = factory.deployFixedRatioWrapper(
            address(USDC),
            1,
            name,
            symbol,
            decimals
        );

        assertEq(wrapper.WRAPPER_TYPE(), "Fixed Ratio Wrapper");
        assertEq(wrapper.decimals(), decimals);
        assertEq(wrapper.name(), name);
        assertEq(wrapper.symbol(), symbol);
        assertEq(wrapper.getRatio(), ratio);
        //TODO Expect event emit
    }

    //Other tests:
    // - different decimals
    // - different ratios
    // - different token param
}
