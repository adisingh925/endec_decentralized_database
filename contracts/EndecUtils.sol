// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract EndecUtils{
    
    struct Response{
        RESPONSE_CODES responseCode;
        string responseMsg;
        string[] requestedData;
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
        DOCUMENT_ALREADY_EXISTS,
        COLLECTION_NAMES_SUCCESSFULLY_FETCHED,
        COLLECTION_ALREADY_EXISTS,
        DATABASES_SUCCESSFULLY_FETCHED,
        COLLECTION_NOT_EXISTS,
        DOCUMENT_NOT_EXISTS,
        DOCUMENTS_SUCCESSFULLY_FETCHED,
        CHECKS_PASSED,
        DATA_SUCCESSFULLY_ADDED,  //18
        KEY_PAIR_COUNT_SUCCESSFULLY_FETCHED,
        DATA_SUCCESSFULLY_FETCHED,
        KEY_NOT_EXISTS,
        DATA_SUCCESSFULLY_UPDATED,
        DATA_SUCCESSFULLY_DELETED
    }

    function createResponse(RESPONSE_CODES responseCode, string memory responseMsg) pure public returns(Response memory){
        return Response({
            responseCode: responseCode,
            responseMsg: responseMsg,
            requestedData: new string[](0)
        });
    }

    function createResponse(RESPONSE_CODES responseCode, string memory responseMsg, string[] memory requestedData) pure public returns(Response memory){
        return Response({
            responseCode: responseCode,
            responseMsg: responseMsg,
            requestedData: requestedData
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