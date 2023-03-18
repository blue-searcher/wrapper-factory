// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./utils/TestERC20.sol";

import "src/WrapperFactory.sol";
import "src/wrappers/FixedRatio.sol";
import "src/wrappers/SharesBased.sol";

contract WrapperFactoryTest is Test {
    WrapperFactory public factory;

    TestERC20 public TOKEN;

    event NewWrapper(
        address indexed wrapper, 
        address indexed token, 
        uint256 indexed wrapperType,
        address creator,
        uint256 id
    );

    function setUp() public {
        factory = new WrapperFactory();

        TOKEN = new TestERC20("TEST", "Test token", 18);
    }

    function testFixedRatio(
        string memory name,
        string memory symbol,
        uint8 decimals,
        uint256 ratio
    ) internal {
        vm.expectEmit(false, true, false, true);
        emit NewWrapper(address(0), address(TOKEN), 0, address(this), 0);
        FixedRatio wrapper = factory.deployFixedRatio(
            address(TOKEN),
            ratio,
            name,
            symbol,
            decimals
        );

        assertEq(wrapper.WRAPPER_DESCRIPTION(), "Fixed Ratio Wrapper");
        assertEq(wrapper.WRAPPER_TYPE(), 0);
        assertEq(address(wrapper.WRAPPED()), address(TOKEN));
        assertEq(wrapper.decimals(), decimals);
        assertEq(wrapper.name(), name);
        assertEq(wrapper.symbol(), symbol);
        assertEq(wrapper.ratio(), ratio);
        assertEq(wrapper.getWrapAmountOut(1 ether), 1 ether * ratio / wrapper.UNIT());
        assertEq(wrapper.getUnwrapAmountOut(1 ether), 1 ether / ratio * wrapper.UNIT());
    }

    function testSharesBased(
        string memory name,
        string memory symbol,
        uint8 decimals
    ) internal {
        vm.expectEmit(false, true, false, true);
        emit NewWrapper(address(0), address(TOKEN), 1, address(this), 0);
        SharesBased wrapper = factory.deploySharesBased(
            address(TOKEN),
            name,
            symbol,
            decimals
        );

        assertEq(wrapper.WRAPPER_DESCRIPTION(), "Shares Based Wrapper");
        assertEq(wrapper.WRAPPER_TYPE(), 1);
        assertEq(address(wrapper.WRAPPED()), address(TOKEN));
        assertEq(wrapper.decimals(), decimals);
        assertEq(wrapper.name(), name);
        assertEq(wrapper.symbol(), symbol);
        assertEq(wrapper.getWrapAmountOut(1 ether), 1 ether);
        assertEq(wrapper.getUnwrapAmountOut(1 ether), 0);
    }


    function testFixedRatio18Decimals() public {
        string memory name = "wrapped TOKEN";
        string memory symbol = "wTOKEN";
        uint8 decimals = 18;
        uint256 ratio = 1 * 1 ether;

        testFixedRatio(name, symbol, decimals, ratio);
    }

    function testSharesBased18Decimals() public {
        string memory name = "wrapped TOKEN";
        string memory symbol = "wTOKEN";
        uint8 decimals = 18;

        testSharesBased(name, symbol, decimals);
    }


    function testFixedRatio9Decimals() public {
        string memory name = "wrapped TOKEN";
        string memory symbol = "wTOKEN";
        uint8 decimals = 9;
        uint256 ratio = 1 * 1 ether;

        testFixedRatio(name, symbol, decimals, ratio);
    }

    function testSharesBased9Decimals() public {
        string memory name = "wrapped TOKEN";
        string memory symbol = "wTOKEN";
        uint8 decimals = 9;

        testSharesBased(name, symbol, decimals);
    }


    function testFixedRatio0Decimals() public {
        string memory name = "wrapped TOKEN";
        string memory symbol = "wTOKEN";
        uint8 decimals = 0;
        uint256 ratio = 1 * 1 ether;

        testFixedRatio(name, symbol, decimals, ratio);
    }

    function testSharesBased0Decimals() public {
        string memory name = "wrapped TOKEN";
        string memory symbol = "wTOKEN";
        uint8 decimals = 0;

        testSharesBased(name, symbol, decimals);
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

    function testFixedRatioNextId() public {
        string memory name = "wrapped TOKEN";
        string memory symbol = "wTOKEN";
        uint8 decimals = 18;
        uint256 ratio = 1 * 1 ether;

        assertEq(factory.nextId(), 0);
        
        FixedRatio wrapper = factory.deployFixedRatio(
            address(TOKEN),
            ratio,
            name,
            symbol,
            decimals
        );

        assertEq(factory.nextId(), 1);
        assertEq(factory.wrapperById(0), address(wrapper));
    }

    function testSharesBasedNextId() public {
        string memory name = "wrapped TOKEN";
        string memory symbol = "wTOKEN";
        uint8 decimals = 18;

        assertEq(factory.nextId(), 0);
        
        SharesBased wrapper = factory.deploySharesBased(
            address(TOKEN),
            name,
            symbol,
            decimals
        );

        assertEq(factory.nextId(), 1);
        assertEq(factory.wrapperById(0), address(wrapper));
    }
}
