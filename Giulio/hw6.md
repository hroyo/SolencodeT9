Q1. Create a Solidity contract with one function
The solidity function should return the amount of ETH that was passed to it, and the function body should be written in assembly

A1. See hw6.sol (tested in Remix)

Q2. Do you know what this code is doing ?
https://gist.github.com/extropyCoder/9ddce05801ea7ec0f357ba2d9451b2fb

A2. Deploying this code creates 3 contracts.
Deploying the code creates contract 1.
First, the constructor payload (has 9 bytes) is stored to memory with mstore.
Second, we generate the 3 args needed for opcode codecopy, then execute it to store contract 1's runtime bytecode to memory.
Third, we create 6 args - 3 and 3 for two create opcodes - this creates contract 2 and contract 3.
Create takes three args: value, offset and size...
For contract 2, we get value from the opcode callvalue (i.e. the same as the value of contract 1).
For contract 3, we get value from the opcode returndatasize (i.e. the output data from the previous call).
Offset is 23 because the constructor payload is 9 bytes within a 32 bytes slot.
Size is the total codesize in memory, which we get by summing the result of the opcode codesize, to 9 (length of payload)
Finally, contract 1 selfdestructs (N.B. the selfdestruct opcode is being deprecated)

Q3. Explain what the following code is doing in the Yul ERC20 contract
function allowanceStorageOffset(account, spender) -> offset {
        offset := accountToStorageOffset(account)
        mstore(0, offset)
        mstore(0x20, spender)
}

A3. The complete Yul ERC20 contract is shown here https://docs.soliditylang.org/en/latest/yul.html
The function allowanceStorageOffset returns a single value called offset, which is an identifier for the account to spender pair,
in the context of token allowance - how much money of 'account' can 'spender' spend.
This identifier is used as key for sload and sstore, within the allowance and setAllowance functions.
Looking more in detail, the spender is stored in slot 0x20 of the stack, because the first slot (i.e. 32 bytes) is occupied by the account (which has been formatted).
