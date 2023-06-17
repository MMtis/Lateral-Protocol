// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Notary.sol";
import "../src/Portfolio.sol";
import "../src/Coin.sol";
import "../src/testAPI.sol";

// Sepolia
contract TestChainlinkFunction1 is Script {
    uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
    address deployerAddress = vm.envAddress("DEPLOYER_ADDRESS");

    function run() external {
        vm.startBroadcast(deployerPrivateKey);

        address wpAddress = 0x3D01BE50fB2f399EF01A8cB60AA6De174f91fCd2;
        address linkTokenAddress = 0x779877A7B0D9E8603169DdbD7836e478b4624789;
        address linkPriceFeedAddress = 0x42585eD362B3f1BCa95c640FdFf35Ef899212734;
        address functionsOracleProxyAddress = 0x649a2C205BE7A3d5e99206CEEFF30c794f0E31EC;
        address registryProxyAddress = 0x3c79f56407DCB9dc9b852D139a317246f43750Cc;

        address wethAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

        // Functions

        APIConsumer aPIConsumer = new APIConsumer();

        IERC20 linkToken = IERC20(linkTokenAddress);

        linkToken.transfer(address(aPIConsumer), 10 * 10 ** 18);
        aPIConsumer.requestVolumeData{gas: 0.1 ether}();

        vm.stopBroadcast();
    }
}
