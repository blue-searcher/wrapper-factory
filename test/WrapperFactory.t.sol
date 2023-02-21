// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/WrapperFactory.sol";
import "src/wrappers/FixedRatio.sol";
import "./utils/TestERC20.sol";

contract WrapperFactoryTest is Test {
    WrapperFactory public factory;

    TestERC20 public TOKEN;

    event NewWrapper(
        address indexed wrapper, 
        address indexed token, 
        address creator,
        uint256 ratio
    );

    function setUp() public {
        factory = new WrapperFactory();

        TOKEN = new TestERC20(18);
    }

    function testFixedRatio(
        string memory name,
        string memory symbol,
        uint8 decimals,
        uint256 ratio
    ) internal {
        vm.expectEmit(false, true, false, true);
        emit NewWrapper(address(0), address(TOKEN), address(this), ratio);
        FixedRatio wrapper = factory.deployFixedRatio(
            address(TOKEN),
            ratio,
            name,
            symbol,
            decimals
        );

        assertEq(wrapper.WRAPPER_TYPE(), "Fixed Ratio Wrapper");
        assertEq(address(wrapper.WRAPPED()), address(TOKEN));
        assertEq(wrapper.decimals(), decimals);
        assertEq(wrapper.name(), name);
        assertEq(wrapper.symbol(), symbol);
        assertEq(wrapper.getWrapRatio(1), ratio);
        assertEq(wrapper.getUnwrapRatio(1), ratio);
    }

    function testFixedRatio18Decimals() public {
        string memory name = "wrapped TOKEN";
        string memory symbol = "wTOKEN";
        uint8 decimals = 18;
        uint256 ratio = 1 * 1 ether;

        testFixedRatio(name, symbol, decimals, ratio);
    }

    function testFixedRatio9Decimals() public {
        string memory name = "wrapped TOKEN";
        string memory symbol = "wTOKEN";
        uint8 decimals = 9;
        uint256 ratio = 1 * 1 ether;

        testFixedRatio(name, symbol, decimals, ratio);
    }

    function testFixedRatio0Decimals() public {
        string memory name = "wrapped TOKEN";
        string memory symbol = "wTOKEN";
        uint8 decimals = 0;
        uint256 ratio = 1 * 1 ether;

        testFixedRatio(name, symbol, decimals, ratio);
    }

    function testFixedRatioHighRatio() public {
        string memory name = "wrapped TOKEN";
        string memory symbol = "wTOKEN";
        uint8 decimals = 18;
        uint256 ratio = 10000000000000 * 1 ether;

        testFixedRatio(name, symbol, decimals, ratio);
    }

    function testFixedRatio0Ratio() public {
        string memory name = "wrapped TOKEN";
        string memory symbol = "wTOKEN";
        uint8 decimals = 18;
        uint256 ratio = 0;

        vm.expectRevert();
        factory.deployFixedRatio(
            address(TOKEN),
            ratio,
            name,
            symbol,
            decimals
        );
    }
}
