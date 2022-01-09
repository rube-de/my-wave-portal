// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;

    mapping(address=>uint256) wavers;

    address kingWaver;

    constructor() {
        console.log("Yo yo, I am a contract and I am smart");
    }

    function wave() public {
        totalWaves += 1;
        wavers[msg.sender] += 1;
        if (wavers[msg.sender] == 1){
            console.log("%s has waved for the first time", msg.sender);
        }else {
            console.log("%s has waved already %s times!", msg.sender, wavers[msg.sender]);
        }
        bool newKing = false;
        if ((kingWaver == address(0) || wavers[kingWaver] < wavers[msg.sender])
                && kingWaver != msg.sender) {
            kingWaver = msg.sender;
            newKing = true;            
        }

        if (newKing) {
            console.log("new kingwaver:", kingWaver);
        }
        
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }
}