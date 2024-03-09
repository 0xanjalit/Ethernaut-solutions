/* @idea
 * need to throw all required opcodes in stack <= (10opcodes)
 *
 ******RUNTIME OPCODES*********
 * 
 * stack works on LIFO pattern
 * 1.) to store 0x2a at some arbitrary position say 0x80 we use MSTORE(p,v)
 * 602a    // v: push1 0x2a (value is 0x2a = 42)
 * 6080    // p: push1 0x80 (memory slot is 0x80)
 * 52      // mstore
 * 
 * 2.) to return this value we use RETURN(p,s)
 * 6020    // s: push1 0x20 (value is 32 bytes in size)
 * 6080    // p: push1 0x80 (value was stored in slot 0x80)
 * f3      // return
 * 
 * => 602a60805260206080f3
 * 
 * **********INITIALIZATION OPCODES*******************
 * 
 * we need to replicate our runtime opcodes to memory, before returning them to EVM then EVM will automatically save the runtime sequence 604260805260206080f3 to the blockchain
 * 
 * Copying code from one place to another is handled by codecopy(t,f,s)
 * 
 * 3.) to copy runtime opcodes in memory at arbitrary position 0x00
 * 600a    // s: push1 0x0a (10 bytes)
 * 60??    // f: push1 0x?? (current position of runtime opcodes)
 * 6000    // t: push1 0x00 (destination memory index 0)
 * 39      // CODECOPY
 * 
 * 4.) to return in-memory runtime opcodes to the EVM:
 * 600a    // s: push1 0x0a (runtime opcode length)
 * 6000    // p: push1 0x00 (access memory index 0)
 * f3      // return to EVM
 * 
 * 5.) we can see our initilazation opcodes take 12 bytes or 0x0c space means our runtime opcodes will start at index 0x0c making our "f" in 3rd step 0x0c
 * 
 * 
 * => 600a600c600039600a6000f3
 */

pragma solidity ^0.8.0;

import {MagicNum} from "../instances/Ilevel18.sol";

contract Hack {
    constructor(MagicNum target) {
        bytes memory bytecode = hex"600a600c600039600a6000f3602a60805260206080f3"; // Initialization + runtime code
        address addr;
        assembly {
            // create(value, offset, size)
            addr := create(0, add(bytecode, 0x20), 0x16)
        }
        require(addr != address(0));

        target.setSolver(addr);
    }
}
