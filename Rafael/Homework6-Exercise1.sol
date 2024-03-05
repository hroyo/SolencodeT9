// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EthAmountGetter {
    function getEthAmount() external pure returns (uint256) {
        uint256 ethAmount;

        assembly {
            // Retrieve the value (amount of ETH) sent with the transaction
            ethAmount := calldataload(0)
        }

        return ethAmount;
    }
}