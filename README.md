# Ethernaut-ctf-solutions
i'm using sepolia testnet for the transactions, u can choose testnet accordingly. All the instance code is in instances folder.

## level00 - Hello Ethernaut
  1. As we can see all the functions are directing us to authenticate() fun. where we need to
     enter password.
  2. we can get the password from console
     ```
     await contract.password()
     ```
  3. then we can either use console
     ```
     await contract.authenticate("ethernaut0")
     ```
     or run our script file level00.s.sol
     ```
     forge script ./script/level00.s.sol broadcast -vvvv --rpc-url $RPC_URL --private-key $PKEY
     ```
  4. submit the instance, u're done

## level01 - Fallback
  1. our main goal here is to be the owner and drain the contract balance, we         can do this by two ways
     1. either keep contributing using contribute() to make your contribution 
        more then the current owner and use withdraw() which is not a feasible 
        solution obvi.
     2. or we can use the receive() fun. where we need to fulfill two basic              conditions, msg.value>0 and contibutions[msg.sender]>0 , which is 
        comparatively easy, then use withdraw(), so proceeding with this option
  2. first we can use contribute() fun. to send some wei then use low level call
     function to make our msg.value>0
  3. As both condition satisfies, we'll be the owner , now all we need to do is
     use withdraw() to get all the funds out.
  4. checkout level01.s.sol for the code, run the script file on testnet
     ```
     forge script ./script/level01.s.sol broadcast -vvvv --rpc-url $RPC_URL --private-key $PKEY
     ```
  5. submit the instance , u're done
     
## level02 - Fallout
  1. same as previous one we need to get the ownership here
  2. we can achieve that by simply calling Fal1out() either from the console
     ```
     await contract.Fal1out()
     ```
     or using script file level02.s.sol
  3. submit the instance, u're done.

## level06 - Delegation
  1. our goal here is to claim ownership of the given instance which we can do 
     using pwn() fun.
  2. We need to trigger the fallback function in the Delegation contract to           invoke the pwn() function via msg.data which will then make a delegate
     call to pwn() and make msg.sender the owner.
  3. to do this first we need to get methodId of pwn()
     ```
     cast calldata "pwn()"
     ```
     then call the fallback fun.
     ```
     cast send $LEVEL_ADDRESS 0xdd365b8b --gas-limit 50000 --rpc-url $RPC_URL --private-key $PKEY
     // we need to set a custom gas limit for this transaction as the default amount insufficient
     ```
  4. send the transaction, submit instance, u're done 
     
## level07 - Force 
  1. here we need to increase the balance of our contract, but neither it has         any recieve() or fallback() fun. , so what we gonna use is selfdestruct()
  2. preferably, we'll use remix as new versions of solidity doesn't support 
     selfdestruct(), source code:
     ```
     // SPDX-License-Identifier: MIT
     pragma solidity ^0.6.0;
      
     contract Forced{
         constructor () public payable {
             selfdestruct(0x2BA0bf631A0c17C516D74634E24fCA5Fff21575f); //level add.
         }
     }
     ```
  3. we'll send some eth at deployment time to increase contract balance and cuz      of selfdestruct all this will go to Force contract 
  4. we're using selfdestruct() in constructor itself, so it can operate at           deployment time and we don't need to call any other function
  5. submit the instance after deployment, u're done.

     
