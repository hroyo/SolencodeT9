# Homework 7
## Functions

1. The parameter X represents a function. Complete the function signature so that X is a standard ERC20 transfer function (other than the visibility). The query function should revert if the ERC20 function returns false.
  
  ```
  // SPDX-License-Identifier: MIT
  // Compatible with OpenZeppelin Contracts ^5.0.0
  pragma solidity ^0.8.20;
  
  import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
  import "@openzeppelin/contracts/access/Ownable.sol";
  
  
  contract MyToken is ERC20, Ownable {
      constructor()
          ERC20("MyToken", "MTK")
          Ownable(msg.sender)
      {
          _mint(msg.sender, 1000 * 10 ** decimals());
      }
  
      function mint(address to, uint256 amount) public onlyOwner {
          _mint(to, amount);
      }
  
      function query(uint256 _amount, address _receiver, function(address, address, uint256) external returns (bool)  callback) internal {
          require (callback(msg.sender, _receiver, _amount));
      }
  
      function reply(uint256 _amount, address _receiver) public  {
          query(_amount, _receiver, this.transferFrom);
      }
  
  }
  ```

  I tried to use `this.transfer`, but then when query is called, the code tries to sent tokens from the contract's address, not from msg.sender's address, so I had to use `this.transferFrom` instead.

2. The following function checks function details passed in the data parameter. 
  ```
  function checkCall(bytes calldata data)
  external{
  }
  ```
  The data parameter is bytes encoded  representing the following
  
  Function selector
  
  Target address
  
  Amount (uint256)
  
  Complete the function body as follows
  
  The function should revert if the function is not
  an ERC20 transfer function.
  Otherwise extract the address and amount from  the data variable and emit an event with those  details

  ```
  event transferOccurred(address,uint256);
  ```

  checkCall.sol file:

  ```
  // SPDX-License-Identifier: MIT
  // Compatible with OpenZeppelin Contracts ^5.0.0
  pragma solidity ^0.8.20;
  
  import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
  import "@openzeppelin/contracts/access/Ownable.sol";
  
  import "hardhat/console.sol";
  
  contract MyToken is ERC20, Ownable {
  
      constructor()
          ERC20("MyToken", "MTK")
          Ownable(msg.sender)
      {
          _mint(msg.sender, 1000 * 10 ** decimals());
          checkCallContract = new CheckCallContract();
      }
  
      CheckCallContract public checkCallContract;
      bytes4 public fnSelector;
      address public to_;
      uint256 public value_;
  
      function mint(address to, uint256 amount) public onlyOwner {
          _mint(to, amount);
      }
  
      function transfer(address _to, uint256 value) public override returns (bool) {
          checkCallContract.checkCall(msg.data);
          return super.transfer(_to, value);
      }
  
  
  
  }
  
  contract CheckCallContract{
      event transferOccurred(address,uint256);
  
      function checkCall(bytes calldata data) external{
          bytes4 functionSelector = bytes4(data[:4]);
          require(functionSelector == bytes4(keccak256("transfer(address,uint256)")));  
          (address to, uint256 value) = abi.decode(data[4:], (address, uint256)); 
          emit transferOccurred(to, value);
      }
  }
  ```

The ERC20 `transfer` function is overridden to add the `checkCall` function before the original `transfer` function is called.
When calling the transfer function with inputs 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2, 10000, 
the transferOccured event is triggered:

![image](https://github.com/BigBangInfinity/Encode_ExpertSolidityBootcamp_Homework/assets/37957341/916fe220-19b5-46f7-a683-9d515a451cc4)
