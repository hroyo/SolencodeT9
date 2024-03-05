// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ArrayContract {
    uint[] public numbers;

    constructor() {
        for(uint i = 0; i < 12; i++) {
            numbers.push(i);
        }
    }

    function deleteEntry(uint8 index) public {
        require(index < numbers.length, "Index should be less than length of array");

        for(uint8 i = index; i < numbers.length - 1; i++) {
            numbers[i] = numbers[i + 1];
        }
        numbers.pop();
    }

}
