pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/WrapperFactory.sol";

//forge script script/WrapperFactoryDeployer.s.sol:WrapperFactoryDeployer --rpc-url https://goerli.blockpi.network/v1/rpc/public --broadcast --verify -vvvv

//forge verify-contract 0x19C719029B34Ee15d5a12C8c95d09Ba35De62547 src/WrapperFactory.sol:WrapperFactory --watch --chain-id 5

//cast abi-encode "constructor(address,uint256,string,string,uint8)" "0xa3fcd1F7D8Dbe8eD49671A6C7a47A06257066e9d" 2770000000000000000 "Wrapped Reflexer RAI" "wRAI" 18
//forge verify-contract 0x6EaF873B6A2a4Ad7cb5872e77ea2A939E9255CE0 src/wrappers/FixedRatio.sol:FixedRatio --watch --chain-id 5 --constructor-args $(cast abi-encode "constructor(address,uint256,string,string,uint8)" "0xa3fcd1F7D8Dbe8eD49671A6C7a47A06257066e9d" 2770000000000000000 "Wrapped Reflexer RAI" "wRAI" 18)
contract WrapperFactoryDeployer is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        WrapperFactory factory = new WrapperFactory();

        vm.stopBroadcast();
    }
}
