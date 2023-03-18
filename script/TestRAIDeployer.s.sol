pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../test/utils/TestERC20.sol";

//forge script script/TestRAIDeployer.s.sol:TestRAIDeployer --rpc-url https://goerli.blockpi.network/v1/rpc/public --broadcast --verify -vvvv

contract TestRAIDeployer is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        TestERC20 RAI = new TestERC20("RAI", "Reflexer RAI", 18);
        RAI.mint(deployer, 100 ether);

        vm.stopBroadcast();
    }
}
