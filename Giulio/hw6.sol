// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract EncodeHw6 {
    
    function callvalue () external payable returns (uint) {
        uint amount;
        assembly {
            amount := callvalue()
        }
        return amount;
    }

}
