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
     
