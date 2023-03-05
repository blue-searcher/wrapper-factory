pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/WrapperFactory.sol";

//forge script script/WrapperFactoryDeployer.s.sol:WrapperFactoryDeployer --rpc-url https://goerli.blockpi.network/v1/rpc/public --broadcast -vvvv
contract WrapperFactoryDeployer is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        WrapperFactory factory = new WrapperFactory();

        vm.stopBroadcast();
    }
}
