pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../test/utils/TestERC20.sol";

//forge script script/TestERC20Deployer.s.sol:TestERC20Deployer --rpc-url https://goerli.blockpi.network/v1/rpc/public --broadcast --verify -vvvv

//forge verify-contract 0x582072589dA9Dc9de7cb14aB98bd550A531909c4 test/utils/TestERC20.sol:TestERC20 --watch --chain-id 5 --constructor-args 0x0000000000000000000000000000000000000000000000000000000000000012

contract TestERC20Deployer is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        TestERC20 TEST = new TestERC20("TEST", "Test token", 18);
        TEST.mint(deployer, 100 ether);

        vm.stopBroadcast();
    }
}
