// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

contract MainContract{
    function Greet() external pure returns (bytes32 greet){
        greet = "Hello World";
    }
}

contract FirstCall{
    MainContract public mainContract;

    constructor(address add){
        mainContract = MainContract(add);
    }
    
    function calling() external view returns(bytes32) {
        return mainContract.Greet();
    }
}

contract SecondCall{
    function calling(MainContract mainContract) external pure {
        mainContract.Greet();
    }
}

contract ThirdCall{
    MainContract mainContract;
    constructor(MainContract _mainContract){
        mainContract = MainContract(_mainContract);
    }
    function calling() external view {
        mainContract.Greet();
    }
}