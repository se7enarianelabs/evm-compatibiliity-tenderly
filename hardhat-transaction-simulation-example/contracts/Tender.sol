// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Tender {
    address public owner;
    uint public tenderEndTime;
    bool public tenderEnded;
    address public winner;
    uint public highestBid;

    mapping(address => uint) public bids;

    event TenderStarted(uint endTime);
    event BidSubmitted(address indexed bidder, uint amount);
    event WinnerSelected(address indexed winner, uint amount);

    constructor(uint _biddingTime) {
        owner = msg.sender;
        tenderEndTime = block.timestamp + _biddingTime;
        emit TenderStarted(tenderEndTime);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier tenderActive() {
        require(block.timestamp < tenderEndTime, "Tender has ended");
        _;
    }

    modifier tenderEndedCheck() {
        require(block.timestamp >= tenderEndTime, "Tender is still active");
        require(!tenderEnded, "Tender already ended");
        _;
    }

    function bid() public payable tenderActive {
        require(msg.value > highestBid, "There already is a higher bid");
        highestBid = msg.value;
        bids[msg.sender] += msg.value;
        emit BidSubmitted(msg.sender, msg.value);
    }

    function endTender() public onlyOwner tenderEndedCheck {
        tenderEnded = true;
        winner = msg.sender;
        emit WinnerSelected(winner, highestBid);
    }

    function withdraw() public {
        uint amount = bids[msg.sender];
        require(amount > 0, "No funds to withdraw");

        bids[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
}
