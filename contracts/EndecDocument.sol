// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./EndecUtils.sol";

contract EndecDocument is EndecUtils{

    address public owner;
    string private documentId;
    
    constructor(string memory _documentId) {
        owner = msg.sender;
        documentId = _documentId;
    }

    function getContractAddress() public view returns (address) {
        return address(this);
    }

    function getDocumentId() internal view returns (string memory){
        return documentId;
    }
}