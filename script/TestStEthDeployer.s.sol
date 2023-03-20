pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../test/utils/TestERC20.sol";

//forge script script/TestStEthDeployer.s.sol:TestStEthDeployer --rpc-url https://goerli.blockpi.network/v1/rpc/public --broadcast --verify -vvvv

contract TestStEthDeployer is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        TestERC20 stETH = new TestERC20("stETH", "Staked ETH", 18);
        stETH.mint(deployer, 100 ether);

        vm.stopBroadcast();
    }
}
