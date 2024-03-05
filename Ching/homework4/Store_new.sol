// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Store_new {

    struct payments {
        uint256 amount;
        uint256 finalAmount;        
        uint256 initialAmount;
        address sender;
        uint8 paymentType;
        bool checked;
        bool valid;
        address receiver;
        
    }
    uint8 index;
    bool flag1;
    bool flag2;
    bool flag3;
    address admin;
    address admin2;
    uint256 public number;
    mapping (address=>uint256) balances;

    payments[8] topPayments;


    constructor(){

    }


    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number++;
    }
}
