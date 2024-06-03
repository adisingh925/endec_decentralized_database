// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface EndecCollectionInterface {

    struct Response{
        RESPONSE_CODES responseCode;
        string responseMsg;
    }

    enum RESPONSE_CODES{
        USER_NOT_EXISTS,
        USER_ALREADY_EXISTS,
        DATABASE_SUCCESSFULLY_CREATED,
        INVALID_COLLECTION_ID,
        COLLECTION_SUCCESSFULLY_CREATED,
        DATABASE_NOT_EXISTS,
        INVALID_DATABASE_ID,
        DOCUMENT_SUCCESSFULLY_CREATED,
        INVALID_DOCUMENT_ID,
        DATABASE_ALREADY_EXISTS,
        DOCUMENT_ALREADY_EXISTS
    }

    function getContractAddress() external view returns (address);
    function getCollectionId() external view returns (string memory);
    function createDocument(string memory documentId) external returns(Response memory);
}
