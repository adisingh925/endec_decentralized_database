// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./EndecUtils.sol";
import "./EndecDocument.sol";
import "../interfaces/EndecDocumentInterface.sol";

contract EndecCollection is EndecUtils{

    address public owner;
    string private collectionId;

    mapping(string => address) documentIdToDocumentContractAddressMapping;

    constructor(string memory _collectionId) {
        owner = msg.sender;
        collectionId = _collectionId;
    }

    function getContractAddress() public view returns (address) {
        return address(this);
    }

    function getCollectionId() internal view returns (string memory){
        return collectionId;
    }

    function createDocument(string memory documentId) public returns(Response memory){
        if(checkDocumentId(documentId)){
            revert invalidDocumentId(createResponse(RESPONSE_CODES.INVALID_DOCUMENT_ID, "Invalid Document Id!"));
        }

        if(documentIdToDocumentContractAddressMapping[documentId] != address(0)){
            revert documentAlreadyExists(createResponse(RESPONSE_CODES.DOCUMENT_ALREADY_EXISTS, "Document already exists!"));
        }

        EndecDocument endecDocument = new EndecDocument(documentId);
        documentIdToDocumentContractAddressMapping[documentId] = address(endecDocument.getContractAddress());

        return createResponse(RESPONSE_CODES.DOCUMENT_SUCCESSFULLY_CREATED, "Document Successfully Created!");
    }
}