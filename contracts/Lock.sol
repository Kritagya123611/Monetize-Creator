// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract MonetizeCreator is ERC721URIStorage, Ownable {
    address public owner;
    uint public balance;
    uint public nextTokenId;

    mapping(address => uint) public contributions;

    constructor() ERC721("SupporterBadge", "SBADGE") {
        owner = msg.sender;
    }

    receive() external payable {
        require(msg.value > 0, "Must send ETH");
        contributions[msg.sender] += msg.value;
        balance += msg.value;

        _mint(msg.sender, nextTokenId);
        _setTokenURI(nextTokenId, "ipfs://your-metadata-hash"); // Use actual metadata
        nextTokenId++;
    }

    function contribute() public payable {
        require(msg.value > 0, "Contribution must be greater than 0");
        contributions[msg.sender] += msg.value;
        balance += msg.value;

        _mint(msg.sender, nextTokenId);
        _setTokenURI(nextTokenId, "ipfs://your-metadata-hash");
        nextTokenId++;
    }

    function withdraw(address payable creator) public onlyOwner {
        require(balance > 0, "No balance to withdraw");

        uint amount = balance;
        balance = 0;
        creator.transfer(amount);
    }
}
