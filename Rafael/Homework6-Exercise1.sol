// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EthAmount {

    // Function to return the amount of ETH sent to it
    function getEthAmount() external payable returns (uint256) {
        // Assembly code to access the msg.value, which contains the amount of ETH sent
        assembly {
            // Load the msg.value into the memory
            let amount := callvalue()
            // Return the value stored in memory
            mstore(0x0, amount)
            return(0x0, 32)
        }
    }
}
