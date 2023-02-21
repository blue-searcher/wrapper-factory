// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/WrapperFactory.sol";
import "src/wrappers/SharesBased.sol";
import "./utils/TestERC20.sol";

contract SharesBasedTest is Test {
    WrapperFactory public factory;

    SharesBased public wrapper;

    TestERC20 public TOKEN;
    address public constant RANDOM_ADDRESS = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

    event Wrap(
        address indexed from, 
        address indexed to, 
        uint256 tokenAmount,
        uint256 wrapperAmount,
        uint256 ratio
    );
    event Unwrap(
        address indexed from, 
        address indexed to, 
        uint256 tokenAmount,
        uint256 wrapperAmount,
        uint256 ratio
    );

    function setUp() public {
        factory = new WrapperFactory();

        TOKEN = new TestERC20(18);
        TOKEN.mint(address(this), 10 ether);

        string memory name = "wrapped TOKEN";
        string memory symbol = "wTOKEN";

        wrapper = factory.deploySharesBased(
            address(TOKEN),
            name,
            symbol,
            18
        );
    }

    function testTokenBalance() public {
        assertEq(TOKEN.balanceOf(address(this)), 10 ether);
    }

    function testWrapperType() public {
        string memory wrapperTypeDescription = "Shares Based Wrapper";
        assertEq(wrapper.WRAPPER_TYPE(), wrapperTypeDescription);
    }

    function testInitialRatio() public {
        assertEq(wrapper.getWrapRatio(1), 1);
        assertEq(wrapper.getUnwrapRatio(1), 0);
    }

    function testGetWrappedAddress() public {
        assertEq(address(wrapper.WRAPPED()), address(TOKEN));
    }   

    function _wrap(
        uint256 _tokenAmount,
        address _receiver
    ) internal returns (uint256 tokenAmount, uint256 wrapperAmount) {
        TOKEN.approve(address(wrapper), type(uint256).max);
        tokenAmount = _tokenAmount;
        wrapperAmount = wrapper.wrap(_tokenAmount, _receiver);
    }

    function _unwrap(
        uint256 _wrapperAmount,
        address _receiver
    ) internal returns (uint256 wrapperAmount, uint256 tokenAmount) {
        wrapperAmount = _wrapperAmount;
        tokenAmount = wrapper.unwrap(_wrapperAmount, _receiver);
    }

    function testFirstWrapBalances() public {
        uint256 preTokenBalance = TOKEN.balanceOf(address(this));
        uint256 preWrapperBalance = wrapper.balanceOf(address(this));

        TOKEN.approve(address(wrapper), type(uint256).max);
        (uint256 depositAmount, uint256 wrapperAmount) = _wrap(1 ether, address(this));

        uint256 postTokenBalance = TOKEN.balanceOf(address(this));
        uint256 postWrapperBalance = wrapper.balanceOf(address(this));

        assertEq(preTokenBalance - postTokenBalance, depositAmount);

        //first wrap() set total shares to same amount of deposited tokens:
        assertEq(postWrapperBalance - preWrapperBalance, depositAmount);
        assertEq(preTokenBalance - postTokenBalance, postWrapperBalance - preWrapperBalance);
        assertEq(wrapperAmount, depositAmount);
    }

    function testWrapDifferentReceiverBalances() public {
        uint256 preTokenBalance = TOKEN.balanceOf(address(this));
        uint256 preWrapperBalance = wrapper.balanceOf(address(this));
        uint256 preReceiverWrapperBalance = wrapper.balanceOf(RANDOM_ADDRESS);

        (uint256 tokenAmount, uint256 wrapperAmount) = _wrap(1 ether, RANDOM_ADDRESS);

        uint256 postTokenBalance = TOKEN.balanceOf(address(this));
        uint256 postWrapperBalance = wrapper.balanceOf(address(this));
        uint256 postReceiverWrapperBalance = wrapper.balanceOf(RANDOM_ADDRESS);

        assertEq(preTokenBalance - postTokenBalance, tokenAmount);
        assertEq(postWrapperBalance - preWrapperBalance, 0); 
        assertEq(postReceiverWrapperBalance - preReceiverWrapperBalance, wrapperAmount);
    }

    function testFirstWrapEventEmit() public {
        TOKEN.approve(address(wrapper), type(uint256).max);
        uint256 tokenAmount = 1 ether;

        vm.expectEmit(true, true, true, true);
        emit Wrap(address(this), address(this), tokenAmount, tokenAmount, wrapper.UNIT());
        wrapper.wrap(tokenAmount, address(this));
    }

    function testWrapNoApproval() public {
        uint256 tokenAmount = 1 ether;
        vm.expectRevert();
        wrapper.wrap(tokenAmount, address(this));
    }

    function testWrapNotEnoughtApproval() public {
        TOKEN.approve(address(wrapper), 0.99 ether);
        uint256 tokenAmount = 1 ether;
        vm.expectRevert();
        wrapper.wrap(tokenAmount, address(this));
    }

    function testWrapRevertPositiveAmountOnly() public {
        TOKEN.approve(address(wrapper), type(uint256).max);
        uint256 tokenAmount = 0;
        vm.expectRevert();
        wrapper.wrap(tokenAmount, address(this));
    }

    function testFirstUnwrapBalances() public {
        (uint256 wrapTokenAmount, uint256 wrapWrapperAmount) = _wrap(1 ether, address(this));

        uint256 preTokenBalance = TOKEN.balanceOf(address(this));
        uint256 preWrapperBalance = wrapper.balanceOf(address(this));

        (uint256 unwrapWrapperAmount, uint256 unwrapTokenAmount) = _unwrap(wrapWrapperAmount, address(this));

        uint256 postTokenBalance = TOKEN.balanceOf(address(this));
        uint256 postWrapperBalance = wrapper.balanceOf(address(this));

        assertEq(postTokenBalance - preTokenBalance, wrapTokenAmount); 
        assertEq(preWrapperBalance - postWrapperBalance, wrapWrapperAmount);
        assertEq(wrapWrapperAmount, unwrapWrapperAmount);
        assertEq(wrapTokenAmount, unwrapTokenAmount);
    }

    function testUnwrapRatioAfterFirstUnwrap() public {
        (uint256 tokenAmount, uint256 wrapperAmount) = _wrap(1 ether, address(this));

        assertEq(wrapper.getUnwrapRatio(tokenAmount), wrapper.UNIT());
        _unwrap(wrapperAmount, address(this));
        assertEq(wrapper.getUnwrapRatio(tokenAmount), 0);
    }

    function testUnwrapEventEmit() public {
        (uint256 tokenAmount, uint256 wrapperAmount) = _wrap(1 ether, address(this));

        vm.expectEmit(true, true, true, true);
        emit Unwrap(address(this), address(this), tokenAmount, tokenAmount, wrapper.UNIT());
        wrapper.unwrap(wrapperAmount, address(this));
    }

    //TODO Test balances with multiple wrap/unwrap from different addresses
    //TODO Update TOKEN balances to test rebalance tokens like stETH

}
