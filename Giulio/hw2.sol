// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract EncodeHw2 {
    uint[] public myArray = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

    function deleteNoGaps(uint myIndex) public {
        require(myArray.length > 0, "Array is empty");
        myArray[myIndex] = myArray[myArray.length - 1];
        myArray.pop();
    }
}
