// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../instances/Ilevel00.sol";
import "forge-std/Script.sol";

contract Attacker is Script {
    Instance level0 = Instance(0x3c9f001a0C769B5f70739443E9d83227a9Db976e);

    function run() external {
        vm.startBroadcast();
        level0.authenticate("ethernaut0");
        vm.stopBroadcast();
    }
}
