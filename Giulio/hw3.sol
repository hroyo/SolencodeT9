// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract EncodeHw3 {
    function modifyArray(int[] memory inputArray) public pure returns (int[] memory) {
        int[] memory tempArray = inputArray;
        if(tempArray.length > 0) {
            tempArray[0] = 99;
        }
        return tempArray;
    }
}

// then using the debugger step through the function and inspect the memory.
