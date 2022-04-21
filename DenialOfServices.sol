// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

contract WhoIsTheKing{
    address public king;
    uint public kingPrice;

    function makeMeKing() external payable {
        require(msg.value > kingPrice, "Price must be bigger");
        (bool send, ) = king.call{value: kingPrice}("");
        require(send, "King not changed.");

        king = msg.sender;
        kingPrice = msg.value;
    }

    function showKing() external view returns(address _king, uint _price){
        _king = king;
        _price = kingPrice;
    }
}


contract DestroyAboveContrat{
    WhoIsTheKing cont;

    function attack(WhoIsTheKing _cont) external payable{
        cont = WhoIsTheKing(_cont);
        cont.makeMeKing{value: msg.value}();
    }
}

contract SaveWhoIsTheKing{
    mapping(address => uint) public claimMoney;

    address public king;
    uint public kingPrice;

    function makeMeKing() external payable {
        require(msg.value > kingPrice, "Price must be bigger");
        claimMoney[king] = kingPrice;

        king = msg.sender;
        kingPrice = msg.value;
    }

    function withdraw() external{
        uint bal = claimMoney[msg.sender];
        require(bal > 0, "Nothing to withdraw");
        (bool send, ) = payable(msg.sender).call{value: bal}("");
        require(send, "balance not send.");
    }

    function showKing() external view returns(address _king, uint _price){
        _king = king;
        _price = kingPrice;
    }
}