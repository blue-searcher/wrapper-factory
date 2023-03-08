pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/WrapperFactory.sol";

//forge script script/WrapperFactoryDeployer.s.sol:WrapperFactoryDeployer --rpc-url https://goerli.blockpi.network/v1/rpc/public --broadcast -vvvv

//forge verify-contract 0x19C719029B34Ee15d5a12C8c95d09Ba35De62547 src/WrapperFactory.sol:WrapperFactory --watch --chain-id 5

//cast abi-encode "constructor(address,uint256,string,string,uint8)" "0x582072589dA9Dc9de7cb14aB98bd550A531909c4" 3000000000000000000 "Wrapped TestERC20" "wTEST" 18
//forge verify-contract 0xA0E3b5A3b06414EeF6E56144dDbfdB750a9c12fD src/wrappers/FixedRatio.sol:FixedRatio --watch --chain-id 5 --constructor-args 0x000000000000000000000000582072589da9dc9de7cb14ab98bd550a531909c400000000000000000000000000000000000000000000000029a2241af62c000000000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000e000000000000000000000000000000000000000000000000000000000000000120000000000000000000000000000000000000000000000000000000000000011577261707065642054657374455243323000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000057754455354000000000000000000000000000000000000000000000000000000
contract WrapperFactoryDeployer is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        WrapperFactory factory = new WrapperFactory();

        vm.stopBroadcast();
    }
}
