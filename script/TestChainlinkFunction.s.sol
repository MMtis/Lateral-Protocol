// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Notary.sol";
import "../src/Portfolio.sol";
import "../src/Coin.sol";
import "../src/Vault.sol";
import {WeightProvider} from "../src/WeightProvider.sol";
import {FunctionsBillingRegistry} from "../src/dev/functions/FunctionsBillingRegistry.sol";
import {IERC1363} from "lib/openzeppelin-contracts/contracts/interfaces/IERC1363.sol";

// Sepolia
contract TestChainlinkFunction is Script {
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

        WeightProvider weightProvider = new WeightProvider(
            functionsOracleProxyAddress,
            0x4367f2Bf724440df577cfc4349Edd72c9d9358a0,
            wethAddress
        );
        address weightProviderAddress = address(weightProvider);

        FunctionsBillingRegistry registry = FunctionsBillingRegistry(
            registryProxyAddress
        );
        uint64 subId = registry.createSubscription();

        IERC1363 linkToken = IERC1363(linkTokenAddress);

        console.log(linkToken.balanceOf(deployerAddress));

        console.log(subId);
        registry.addConsumer(subId, weightProviderAddress);
        weightProvider.setSubId(subId);
        linkToken.transferAndCall(
            registryProxyAddress,
            10 ** 18,
            abi.encode(subId)
        );
        console.log(linkToken.balanceOf(registryProxyAddress));
        weightProvider.executeRequest{gas: 0.01 ether}();

        vm.stopBroadcast();
    }
}
