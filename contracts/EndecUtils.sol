// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract EndecUtils{
    
    struct Response{
        RESPONSE_CODES responseCode;
        string responseMsg;
    }

    error userDoesNotExists(Response response);
    error userAlreadyExists(Response response);
    error invalidCollectionId(Response response);
    error invalidDatabaseId(Response response);
    error databaseDoesNotExist(Response response);
    error invalidDocumentId(Response response);
    error databaseAlreadyExists(Response response);
    error documentAlreadyExists(Response response);

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

    function createResponse(RESPONSE_CODES responseCode, string memory responseMsg) pure public returns(Response memory){
        return Response({
            responseCode: responseCode,
            responseMsg: responseMsg
        });
    }

    function checkDatabaseId(string memory databaseId) pure public returns(bool){
        if(bytes(databaseId).length <= 0){
            return false;
        }
        return true;
    }

    function checkCollectionId(string memory collectionId) pure public returns(bool){
        if(bytes(collectionId).length <= 0){
            return false;
        }
        return true;
    }

    function checkDocumentId(string memory documentId) pure public returns(bool){
        if(bytes(documentId).length <= 0){
            return false;
        }
        return true;
    }
}