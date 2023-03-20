// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/WrapperFactory.sol";
import "src/wrappers/WrapperToken.sol";
import "./utils/TestERC20.sol";

contract WrapperTokenTest is Test {
    WrapperFactory public factory;

    uint256 public ratioOne;
    uint256 public ratioTwo;

    WrapperToken public wrapperOne;
    WrapperToken public wrapperTwo;

    TestERC20 public TOKEN;
    address public constant RANDOM_ADDRESS = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

    event Wrap(
        address indexed from, 
        address indexed to, 
        uint256 tokenAmount,
        uint256 wrapperAmount
    );
    event Unwrap(
        address indexed from, 
        address indexed to, 
        uint256 tokenAmount,
        uint256 wrapperAmount
    );

    function setUp() public {
        factory = new WrapperFactory();

        TOKEN = new TestERC20("TEST", "Test token", 18);
        TOKEN.mint(address(this), 10 ether);

        string memory name = "wrapped TOKEN";
        string memory symbol = "wTOKEN";

        ratioOne = 1 ether;
        ratioTwo = 0.5 ether;

        wrapperOne = factory.deploy(
            address(TOKEN),
            ratioOne,
            name,
            symbol,
            18
        );
        wrapperTwo = factory.deploy(
            address(TOKEN),
            ratioTwo,
            name,
            symbol,
            18
        );
    }

    function testTokenBalance() public {
        assertEq(TOKEN.balanceOf(address(this)), 10 ether);
    }

    function testGetRatio() public {
        assertEq(wrapperOne.initialRatio(), ratioOne);
        assertEq(wrapperTwo.initialRatio(), ratioTwo);
    }

    function testGetWrappedAddress() public {
        assertEq(address(wrapperOne.WRAPPED()), address(TOKEN));
        assertEq(address(wrapperTwo.WRAPPED()), address(TOKEN));
    }   

    function _wrap(
        uint256 _tokenAmount,
        WrapperToken _wrapper, 
        address _receiver
    ) internal returns (uint256 tokenAmount, uint256 wrapperAmount) {
        TOKEN.approve(address(_wrapper), type(uint256).max);
        tokenAmount = _tokenAmount;
        wrapperAmount = _wrapper.wrap(_tokenAmount, _receiver);
    }

    function _unwrap(
        uint256 _wrapperAmount,
        WrapperToken _wrapper, 
        address _receiver
    ) internal returns (uint256 wrapperAmount, uint256 tokenAmount) {
        wrapperAmount = _wrapperAmount;
        tokenAmount = _wrapper.unwrap(_wrapperAmount, _receiver);
    }

    function _testWrapBalances(WrapperToken _wrapper) internal {
        uint256 preTokenBalance = TOKEN.balanceOf(address(this));
        uint256 preWrapperBalance = _wrapper.balanceOf(address(this));

        (uint256 tokenAmount, uint256 wrapperAmount) = _wrap(1 ether, _wrapper, address(this));

        uint256 postTokenBalance = TOKEN.balanceOf(address(this));
        uint256 postWrapperBalance = _wrapper.balanceOf(address(this));

        assertEq(preTokenBalance - postTokenBalance, tokenAmount);
        assertEq(postWrapperBalance - preWrapperBalance, wrapperAmount);
    }

    function testWrapOneBalances() public {
        _testWrapBalances(wrapperOne);
    }

    function testWrapTwoBalances() public {
        _testWrapBalances(wrapperTwo);
    }

    function _testWrapDifferentReceiverBalances(WrapperToken _wrapper) internal {
        uint256 preTokenBalance = TOKEN.balanceOf(address(this));
        uint256 preWrapperBalance = _wrapper.balanceOf(address(this));
        uint256 preReceiverWrapperBalance = _wrapper.balanceOf(RANDOM_ADDRESS);

        (uint256 tokenAmount, uint256 wrapperAmount) = _wrap(1 ether, _wrapper, RANDOM_ADDRESS);

        uint256 postTokenBalance = TOKEN.balanceOf(address(this));
        uint256 postWrapperBalance = _wrapper.balanceOf(address(this));
        uint256 postReceiverWrapperBalance = _wrapper.balanceOf(RANDOM_ADDRESS);

        assertEq(preTokenBalance - postTokenBalance, tokenAmount);
        assertEq(postWrapperBalance - preWrapperBalance, 0); 
        assertEq(postReceiverWrapperBalance - preReceiverWrapperBalance, wrapperAmount);
    }

    function testWrapOneDifferentReceiverBalances() public {
        _testWrapDifferentReceiverBalances(wrapperOne);
    }

    function testWrapTwoDifferentReceiverBalances() public {
        _testWrapDifferentReceiverBalances(wrapperTwo);
    }

    function testWrapEventEmit() public {
        TOKEN.approve(address(wrapperTwo), type(uint256).max);
        uint256 tokenAmount = 1 ether;

        uint256 expectedWrapperAmount = wrapperTwo.getWrapAmountOut(1 ether);

        vm.expectEmit(true, true, true, true);
        emit Wrap(address(this), address(this), tokenAmount, expectedWrapperAmount);
        wrapperTwo.wrap(tokenAmount, address(this));
    }

    function testWrapNoApproval() public {
        uint256 tokenAmount = 1 ether;
        vm.expectRevert();
        wrapperOne.wrap(tokenAmount, address(this));
    }

    function testWrapNotEnoughtApproval() public {
        TOKEN.approve(address(wrapperOne), 0.99 ether);
        uint256 tokenAmount = 1 ether;
        vm.expectRevert();
        wrapperOne.wrap(tokenAmount, address(this));
    }

    function testWrapRevertPositiveAmountOnly() public {
        TOKEN.approve(address(wrapperOne), type(uint256).max);
        uint256 tokenAmount = 0;
        vm.expectRevert();
        wrapperOne.wrap(tokenAmount, address(this));
    }

    function _testUnwrapBalances(WrapperToken _wrapper) internal {
        (uint256 wrapTokenAmount, uint256 wrapWrapperAmount) = _wrap(1 ether, _wrapper, address(this));

        uint256 preTokenBalance = TOKEN.balanceOf(address(this));
        uint256 preWrapperBalance = _wrapper.balanceOf(address(this));

        (uint256 unwrapWrapperAmount, uint256 unwrapTokenAmount) = _unwrap(wrapWrapperAmount, _wrapper, address(this));

        uint256 postTokenBalance = TOKEN.balanceOf(address(this));
        uint256 postWrapperBalance = _wrapper.balanceOf(address(this));

        assertEq(postTokenBalance - preTokenBalance, wrapTokenAmount); 
        assertEq(preWrapperBalance - postWrapperBalance, wrapWrapperAmount);
        assertEq(wrapWrapperAmount, unwrapWrapperAmount);
        assertEq(wrapTokenAmount, unwrapTokenAmount);
    }   

    function testUnwrapOneBalances() public {
        _testUnwrapBalances(wrapperOne);
    }

    function testUnwrapTwoBalances() public {
        _testUnwrapBalances(wrapperTwo);
    }

    function testUnwrapEventEmit() public {
        (uint256 tokenAmount, uint256 wrapperAmount) = _wrap(1 ether, wrapperTwo, address(this));

        vm.expectEmit(true, true, true, true);
        emit Unwrap(address(this), address(this), tokenAmount, wrapperAmount);
        wrapperTwo.unwrap(wrapperAmount, address(this));
    }

    function testUnwrapAfterTokenRebalance() public {
        _wrap(1 ether, wrapperTwo, RANDOM_ADDRESS);
        (uint256 wrapTokenAmount, uint256 wrapWrapperAmount) = _wrap(1 ether, wrapperTwo, address(this));

        uint256 preBurnWrappedBalance = TOKEN.balanceOf(address(wrapperTwo));
        assertEq(preBurnWrappedBalance, 2 ether);

        uint256 amountToBurn = preBurnWrappedBalance / 2;
        TOKEN.burn(address(wrapperTwo), amountToBurn);

        uint256 postBurnWrappedBalance = TOKEN.balanceOf(address(wrapperTwo));
        assertEq(postBurnWrappedBalance, preBurnWrappedBalance - amountToBurn);

        (, uint256 unwrapTokenAmount) = _unwrap(wrapWrapperAmount, wrapperTwo, address(this));
        assertEq(wrapTokenAmount / 2, unwrapTokenAmount);
    }
}   
