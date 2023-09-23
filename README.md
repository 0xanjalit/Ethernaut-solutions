# Ethernaut-ctf-solutions
i'm using sepolia testnet for the transactions, u can choose testnet accordingly.
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
