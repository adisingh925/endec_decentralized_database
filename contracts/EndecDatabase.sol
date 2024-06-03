// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./EndecCollection.sol";
import "../interfaces/EndecCollectionInterface.sol";
import "./EndecUtils.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
  * A No-SQL database created using smart contracts, solidity. 
  * Available in sepolia testnet and only allows storing the data in string format as key value pairs.
 */
contract EndecDatabase is EndecUtils, Ownable{

    mapping(address => address[]) private addressToCollectionContractAddressMapping;
    mapping(address => string) private collectionContractAddressToCollectionIdMapping;
    mapping(address => uint256[]) private addressToDatabaseDetailsIndexMapping;

    string[] private databaseDetails;

    constructor() Ownable(msg.sender) {}

    /**
      * Create a new database
     */
    function createDatabase(string memory databaseId) public returns(Response memory){
        if(!checkDatabaseId(databaseId)){
            return createResponse(RESPONSE_CODES.INVALID_DATABASE_ID, "Invalid Database Id!");
        }

        uint256[] memory databaseDetailsIndex = addressToDatabaseDetailsIndexMapping[msg.sender];

        for(uint256 i = 0; i < databaseDetailsIndex.length; i++){
            if(keccak256(abi.encodePacked(databaseDetails[databaseDetailsIndex[i]])) == keccak256(abi.encodePacked(databaseId))){
                return createResponse(RESPONSE_CODES.DATABASE_ALREADY_EXISTS, "Database Already Exists!");
            }
        }

        databaseDetails.push(databaseId);
        addressToDatabaseDetailsIndexMapping[msg.sender].push(databaseDetails.length - 1);
        return createResponse(RESPONSE_CODES.DATABASE_SUCCESSFULLY_CREATED, "Database Successfully Created!");
    }

    function getMyDatabases() public view returns(string[] memory) {
        uint256[] memory databaseDetailsIndex = addressToDatabaseDetailsIndexMapping[msg.sender];
        
        if(databaseDetailsIndex.length <= 0){
            return new string[](0);
        }
        
        string[] memory myDatabases = new string[](databaseDetailsIndex.length);

        for(uint256 i = 0; i < databaseDetailsIndex.length; i++){
            myDatabases[i] = databaseDetails[databaseDetailsIndex[i]];
        }

        return myDatabases;
    }

    function createCollection(string memory collectionId, string memory databaseId) public returns(Response memory){
        if(!checkDatabaseId(databaseId)){
            return createResponse(RESPONSE_CODES.INVALID_DATABASE_ID, "Invalid Database Id!");
        }

        if(!checkCollectionId(collectionId)){
            return createResponse(RESPONSE_CODES.INVALID_COLLECTION_ID, "Invalid Collection Id!");
        }
    
        // If the database name does not exist, return an error
        if (!isDatabaseExists(databaseId)) {
            return createResponse(RESPONSE_CODES.DATABASE_NOT_EXISTS, "Database does not exist!");
        }

        EndecCollection endecCollection = new EndecCollection(collectionId);
        addressToCollectionContractAddressMapping[msg.sender].push(endecCollection.getContractAddress());
        collectionContractAddressToCollectionIdMapping[endecCollection.getContractAddress()] = collectionId;
        return createResponse(RESPONSE_CODES.COLLECTION_SUCCESSFULLY_CREATED, "Collection Successfully Created!");
    }

    function createDocument(string memory collectionId, string memory databaseId, string memory documentId) public returns(Response memory){
        address collectionContractAddress;
        
        if(!checkCollectionId(collectionId)){
            return createResponse(RESPONSE_CODES.INVALID_COLLECTION_ID, "Invalid Collection Id!");
        }

        if(!checkDatabaseId(databaseId)){
            return createResponse(RESPONSE_CODES.INVALID_DATABASE_ID, "Invalid Database Id!");
        }

        if(!checkDocumentId(documentId)){
            return createResponse(RESPONSE_CODES.INVALID_DOCUMENT_ID, "Invalid Document Id!");
        }
    
        // If the database name does not exist, return an error
        if (!isDatabaseExists(databaseId)) {
            return createResponse(RESPONSE_CODES.DATABASE_NOT_EXISTS, "Database Does Not exist!");
        }

        if(!isCollectionExists(collectionId)){
            return createResponse(RESPONSE_CODES.INVALID_COLLECTION_ID, "Collection Does Not Exist!");
        }
        
        EndecCollectionInterface endecCollectionInterface = EndecCollectionInterface(collectionContractAddress);
        endecCollectionInterface.createDocument(documentId);
        
        return createResponse(RESPONSE_CODES.DOCUMENT_SUCCESSFULLY_CREATED, "Document Successfully Created!");
    }

    function insertData() public returns(string memory data){

    }

    function isDatabaseExists(string memory databaseId) public view returns(bool){
        uint256[] memory databaseDetailsIndex = addressToDatabaseDetailsIndexMapping[msg.sender];

        for(uint256 i = 0; i < databaseDetailsIndex.length; i++){
            if(keccak256(abi.encodePacked(databaseDetails[databaseDetailsIndex[i]])) == keccak256(abi.encodePacked(databaseId))){
                return true;
            }
        }

        return false;
    }

    function isCollectionExists(string memory collectionId) public view returns(bool){
        address[] memory collectionContractAddresses = addressToCollectionContractAddressMapping[msg.sender];

        for(uint256 i = 0; i < collectionContractAddresses.length; i++){
            string memory collectionIdFromContract = collectionContractAddressToCollectionIdMapping[collectionContractAddresses[i]];
            if(keccak256(abi.encodePacked(collectionIdFromContract)) == keccak256(abi.encodePacked(collectionId))){
                return true;
            }
        }

        return false;
    }
}