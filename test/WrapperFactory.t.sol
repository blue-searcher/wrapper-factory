// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./utils/TestERC20.sol";

import "src/WrapperFactory.sol";
import "src/wrappers/WrapperToken.sol";

contract WrapperFactoryTest is Test {
    WrapperFactory public factory;

    TestERC20 public TOKEN;

    event NewWrapper(
        address indexed wrapper, 
        address indexed token, 
        address creator,
        uint256 id
    );

    function setUp() public {
        factory = new WrapperFactory();

        TOKEN = new TestERC20("TEST", "Test token", 18);
    }

    function testDeploy(
        string memory name,
        string memory symbol,
        uint8 decimals,
        uint256 ratio
    ) internal {
        vm.expectEmit(false, true, false, true);
        emit NewWrapper(address(0), address(TOKEN), address(this), 0);
        WrapperToken wrapper = factory.deploy(
            address(TOKEN),
            ratio,
            name,
            symbol,
            decimals
        );

        assertEq(address(wrapper.WRAPPED()), address(TOKEN));
        assertEq(wrapper.decimals(), decimals);
        assertEq(wrapper.name(), name);
        assertEq(wrapper.symbol(), symbol);
        assertEq(wrapper.initialRatio(), ratio);
        assertEq(wrapper.getWrapAmountOut(1 ether), 1 ether * ratio / wrapper.UNIT());
        assertEq(wrapper.getUnwrapAmountOut(1 ether), 0); //Tested on WrapperToken.t.sol
    }

    function test18Decimals() public {
        string memory name = "wrapped TOKEN";
        string memory symbol = "wTOKEN";
        uint8 decimals = 18;
        uint256 ratio = 1 * 1 ether;

        testDeploy(name, symbol, decimals, ratio);
    }

    function test9Decimals() public {
        string memory name = "wrapped TOKEN";
        string memory symbol = "wTOKEN";
        uint8 decimals = 9;
        uint256 ratio = 1 * 1 ether;

        testDeploy(name, symbol, decimals, ratio);
    }

    function test0Decimals() public {
        string memory name = "wrapped TOKEN";
        string memory symbol = "wTOKEN";
        uint8 decimals = 0;
        uint256 ratio = 1 * 1 ether;

        testDeploy(name, symbol, decimals, ratio);
    }

    function testHighRatio() public {
        string memory name = "wrapped TOKEN";
        string memory symbol = "wTOKEN";
        uint8 decimals = 18;
        uint256 ratio = 10000000000000 * 1 ether;

        testDeploy(name, symbol, decimals, ratio);
    }

    function test0Ratio() public {
        string memory name = "wrapped TOKEN";
        string memory symbol = "wTOKEN";
        uint8 decimals = 18;
        uint256 ratio = 0;

        vm.expectRevert();
        factory.deploy(
            address(TOKEN),
            ratio,
            name,
            symbol,
            decimals
        );
    }

    function testNextId() public {
        string memory name = "wrapped TOKEN";
        string memory symbol = "wTOKEN";
        uint8 decimals = 18;
        uint256 ratio = 1 * 1 ether;

        assertEq(factory.nextId(), 0);
        
        WrapperToken wrapper = factory.deploy(
            address(TOKEN),
            ratio,
            name,
            symbol,
            decimals
        );

        assertEq(factory.nextId(), 1);
        assertEq(factory.wrapperById(0), address(wrapper));
    }
}
