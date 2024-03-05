1. Look at the example of init code in today's notes
See [gist](https://gist.github.com/extropyCoder/4243c0f90e6a6e97006a31f5b9265b94)

code:

```
// SPDX-License-Identifier: MIT
pragma solidity 0.8.6;

contract Deploy1{

    uint256 value1;

    constructor(){
        value1 = 17;
    }

    function read() view public returns (uint256 result){
        return value1;
    }
}


"object": "608060405234801561001057600080fd5b50601160008190555060b6806100276000396000f
3fe6080604052348015600f57600080fd5b506004361060285760003560e01c806357d
e26a414602d575b600080fd5b60336047565b604051603e9190605d565b60405180910
390f35b60008054905090565b6057816076565b82525050565b6000602082019050607
060008301846050565b92915050565b600081905091905056fea264697066735822122
0872b5d4b9f200afddd5ed3c424f6b3b995bf467e212ec4c313f65365aeadf8e964736
f6c63430008060033",     
"opcodes": "PUSH1 0x80 PUSH1 0x40 MSTORE
CALLVALUE DUP1 ISZERO PUSH2 0x10 JUMPI PUSH1 0x0 DUP1 REVERT JUMPDEST
POP PUSH1 0x11 PUSH1 0x0 DUP2 SWAP1 SSTORE POP PUSH1 0xB6 DUP1 PUSH2
0x27 PUSH1 0x0 CODECOPY PUSH1 0x0 RETURN INVALID PUSH1 0x80 PUSH1 0x40
MSTORE CALLVALUE DUP1 ISZERO PUSH1 0xF JUMPI PUSH1 0x0 DUP1 REVERT
JUMPDEST POP PUSH1 0x4 CALLDATASIZE LT PUSH1 0x28 JUMPI PUSH1 0x0
CALLDATALOAD PUSH1 0xE0 SHR DUP1 PUSH4 0x57DE26A4 EQ PUSH1 0x2D JUMPI
JUMPDEST PUSH1 0x0 DUP1 REVERT JUMPDEST PUSH1 0x33 PUSH1 0x47 JUMP
JUMPDEST PUSH1 0x40 MLOAD PUSH1 0x3E SWAP2 SWAP1 PUSH1 0x5D JUMP
JUMPDEST PUSH1 0x40 MLOAD DUP1 SWAP2 SUB SWAP1 RETURN JUMPDEST PUSH1
0x0 DUP1 SLOAD SWAP1 POP SWAP1 JUMP JUMPDEST PUSH1 0x57 DUP2 PUSH1
0x76 JUMP JUMPDEST DUP3 MSTORE POP POP JUMP JUMPDEST PUSH1 0x0 PUSH1
0x20 DUP3 ADD SWAP1 POP PUSH1 0x70 PUSH1 0x0 DUP4 ADD DUP5 PUSH1 0x50
JUMP JUMPDEST SWAP3 SWAP2 POP POP JUMP JUMPDEST PUSH1 0x0 DUP2 SWAP1
POP SWAP2 SWAP1 POP JUMP INVALID LOG2 PUSH5 0x6970667358 0x22 SLT
KECCAK256 DUP8 0x2B 0x5D 0x4B SWAP16 KECCAK256 EXP REVERT 0xDD 0x5E
0xD3 0xC4 0x24 0xF6 0xB3 0xB9 SWAP6 0xBF CHAINID PUSH31
0x212EC4C313F65365AEADF8E964736F6C634300080600330000000000000000 "
```
When we do the CODECOPY operation, what are we overwriting ?
(debugging this in Remix might help here)

before CODECOPY:

![image](https://github.com/BigBangInfinity/Encode_ExpertSolidityBootcamp_Homework/assets/37957341/6d1397cc-92b7-4af7-9156-45c8b8ad4809)

after CODECOPY:

![image](https://github.com/BigBangInfinity/Encode_ExpertSolidityBootcamp_Homework/assets/37957341/0ef73bd4-03a7-491f-a733-af781c0a6739)

Memory is overwritten. 

`CODECOPY(0x00, 0x27, 0xB6)` copies into memory, starting at location `0x00` the bytecode with an offset of `0x27` (or 39 in decimal) bytes with length `0xb7` (182 in decimal) bytes. The copied section is marked in bold:

608060405234801561001057600080fd5b50601160008190555060b6806100276000396000f
3fe**6080604052348015600f57600080fd5b506004361060285760003560e01c806357d
e26a414602d575b600080fd5b60336047565b604051603e9190605d565b60405180910
390f35b60008054905090565b6057816076565b82525050565b6000602082019050607
060008301846050565b92915050565b600081905091905056fea264697066735822122
0872b5d4b9f200afddd5ed3c424f6b3b995bf467e212ec4c313f65365aeadf8e964736
f6c63430008060033**

2. Could the answer to Q1 allow an optimisation ?
3. Can you trigger a revert in the init code in Remix ?

Sending 1 wei with the deployment of the contract triggers a revert:

![image](https://github.com/BigBangInfinity/Encode_ExpertSolidityBootcamp_Homework/assets/37957341/d74ff1b1-6bf0-4240-ae4a-49ec8d8c1094)

![image](https://github.com/BigBangInfinity/Encode_ExpertSolidityBootcamp_Homework/assets/37957341/ed69e61a-8941-400e-aa66-760f77a19bdd)

4. Write some Yul to
    1. Add 0x07 to 0x08
    2. store the result at the next free memory location.
  
       ```
       // SPDX-License-Identifier: MIT
         pragma solidity ^0.8.6;
         
         
         contract Deploy2{
         
             constructor(){
                 assembly{
                     let value := add(0x07, 0x08)
                     mstore(msize(), value)
                 }
             }
         
         }
       ```
       
       Result 0x0f stored at location 0xe0
        
       ![image](https://github.com/BigBangInfinity/Encode_ExpertSolidityBootcamp_Homework/assets/37957341/92783e41-4099-4227-979f-7f95a75088c1)



    3. (optional) write this again in opcodes
  
       Corresponding opcodes: `PUSH1 08 PUSH1 07 ADD DUP1 MSIZE MSTORE POP`
  
       ![image](https://github.com/BigBangInfinity/Encode_ExpertSolidityBootcamp_Homework/assets/37957341/64c0f481-f8ec-4dad-8210-724821a34db8)

5. Can you think of a situation where the opcode EXTCODECOPY is used ?

    for example to distinguish between EOA and smart contracts given an address, EXTCODECOPY only returns bytes from a smart contract
6. Complete the assembly exercises in this repo [Exercises](https://github.com/ExtropyIO/ExpertSolidityBootcamp/tree/main/exercises/assembly)

   See .sol files on https://github.com/BigBangInfinity/Encode_ExpertSolidityBootcamp_Homework/tree/main/homework5
