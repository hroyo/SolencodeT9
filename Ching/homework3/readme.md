# Homework3

1. What are the advantages and disadvantages of the 256 bit word length in the EVM?

The 256bit format allows cryptography related computations (Keccak256, elliptic curve computations), this allows for very high precision and applications which use a very wide range of numbers (e.g. dexes with high prices ranges, high precisions, high number of ticks)

Some operations and variables don't need 256bit, so this could lead to a waste of space and therefore can be gas inefficient, making the use of smart contracts more expensive than it should.

3. Using Remix write a simple contract that uses a memory variable, then using the debugger step through the function and inspect the memory.

Contract on Remix:

```
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract HelloWorld {
    string private text;
 
    address public owner;

    constructor() {
        text = "Hello World";
        owner = msg.sender;
    }

    function helloWorld() public view returns (string memory) {
        return text;
    }

    function inputName(string calldata newText) public onlyOwner {
        string memory text_temp = string.concat("Hello ", newText);
        text = text_temp;
    }

    modifier onlyOwner()
    {
        require (msg.sender == owner, "Caller is not the owner");
        _;
    }
}
```

calling `inputName("Laurence")` on Remix and open debugger, go to step 344
memory variable `text_temp` is set to `"Laurence"`:

![image](https://github.com/BigBangInfinity/Encode_ExpertSolidityBootcamp_Homework/assets/37957341/a07438b2-f45d-4c4e-8242-33977544bbc1)

![image](https://github.com/BigBangInfinity/Encode_ExpertSolidityBootcamp_Homework/assets/37957341/c96019ae-09b5-41bd-a797-2d0549ec6a1d)

