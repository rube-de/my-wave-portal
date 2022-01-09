// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 private seed;
    uint256 private totalWaves;
    mapping(address=>uint256) public wavers;
    mapping(address => uint256) public lastWavedAt;
    address public kingWaver;

    struct Wave {
        address waver; // The address of the user who waved.
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user waved.
    }

    Wave[] private waves;

    event NewWave(address indexed from, uint256 timestamp, string message);

    constructor() payable{
        console.log("Yo yo, I am a contract and I am smart");
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public {
        require(
            lastWavedAt[msg.sender] + 1 minutes < block.timestamp,
            "Wait 1m"
        );
        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        console.log("%s waved w/ message: %s", msg.sender, _message);
        emit NewWave(msg.sender, block.timestamp, _message);
        waves.push(Wave(msg.sender, _message, block.timestamp));     

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

        seed = (block.difficulty + block.timestamp + seed) % 100;

        console.log("Random # generated: %d", seed);

        /*
         * Give a 50% chance that the user wins the prize.
         */
        if (seed <= 50) {
            console.log("%s won!", msg.sender);
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }
    }

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }
}