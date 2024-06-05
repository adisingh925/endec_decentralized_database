// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./EndecUtils.sol";

/**
  * A No-SQL database created using smart contracts, solidity. 
  * Available in sepolia testnet and only allows storing the data in string format as key value pairs.
 */
contract EndecDatabase is EndecUtils{

    mapping(address => uint256[]) private addressToDatabaseDetailsIndexMapping;
    mapping(uint256 => uint256[]) private databaseDetailsIndexToCollectionDetailsIndexMapping;
    mapping(uint256 => uint256[]) private collectionDetailIndexToDocumentDetailsIndexMapping;
    mapping(uint256 => Data[]) private documentDetailIndexToDataMapping;

    uint256 public constant MAX_UINT256 = type(uint256).max;

    string[] private databaseDetails;
    string[] private collectionDetails;
    string[] private documentDetails;

    event ContractEvent(Response response);

    struct Data{
        string key;
        string value;
    }

    /**
      * Create a new database
     */
    function createDatabase(string memory databaseId) public returns(Response memory){
        Response memory response;

        if(!checkDatabaseId(databaseId)){
            emit ContractEvent(response);
            return response;
        }

        uint256 databaseDetailIndex = getDatabaseDetailIndex(databaseId);

        if(databaseDetailIndex != MAX_UINT256){
            response = createResponse(RESPONSE_CODES.DATABASE_ALREADY_EXISTS, "Database Already Exists!");
            emit ContractEvent(response);
            return response;
        }

        databaseDetails.push(databaseId);
        addressToDatabaseDetailsIndexMapping[msg.sender].push(databaseDetails.length - 1);
        response = createResponse(RESPONSE_CODES.DATABASE_SUCCESSFULLY_CREATED, "Database Successfully Created!");
        emit ContractEvent(response);
        return response;
    }

    function getMyDatabases() public returns (Response memory) {
        uint256[] memory databaseDetailsIndex = addressToDatabaseDetailsIndexMapping[msg.sender];
        uint256 length = databaseDetailsIndex.length;
        string[] memory databaseList = new string[](length);

        for (uint256 i = 0; i < length; i++) {
            databaseList[i] = databaseDetails[databaseDetailsIndex[i]];
        }

        Response memory response = createResponse(RESPONSE_CODES.DATABASES_SUCCESSFULLY_FETCHED, "Databases Successfully Fetched!", databaseList);
        emit ContractEvent(response);
        return response;
    }

    function createCollection(string memory collectionId, string memory databaseId) public {        
        if(!checkDatabaseId(databaseId)){
            emit ContractEvent(createResponse(RESPONSE_CODES.INVALID_DATABASE_ID, "Invalid Database Id!"));
            return;
        }

        if(!checkCollectionId(collectionId)){
            emit ContractEvent(createResponse(RESPONSE_CODES.INVALID_COLLECTION_ID, "Invalid Collection Id!"));
            return;
        }

        uint256 databaseDetailIndex = getDatabaseDetailIndex(databaseId);
    
        // If the database name does not exist, return an error
        if (databaseDetailIndex == MAX_UINT256) {
            emit ContractEvent(createResponse(RESPONSE_CODES.DATABASE_NOT_EXISTS, "Database does not exist!"));
            return;
        }

        // If the collection already exists, return an error
        if(isCollectionExists(collectionId, databaseDetailIndex) != MAX_UINT256){
            emit ContractEvent(createResponse(RESPONSE_CODES.COLLECTION_ALREADY_EXISTS, "Collection Already Exists!"));
            return;
        }

        collectionDetails.push(collectionId);
        databaseDetailsIndexToCollectionDetailsIndexMapping[databaseDetailIndex].push(collectionDetails.length - 1);

        emit ContractEvent(createResponse(RESPONSE_CODES.COLLECTION_SUCCESSFULLY_CREATED, "Collection Successfully Created!"));
        return;
    }

    function getCollectionNamesForDatabase(string memory databaseId) public {
        // Check if the database ID exists
        if (!checkDatabaseId(databaseId)) {
            emit ContractEvent(createResponse(RESPONSE_CODES.INVALID_DATABASE_ID, "Invalid Database Id!"));
            return;
        }

        // Get the database detail index
        uint256 databaseDetailIndex = getDatabaseDetailIndex(databaseId);

        // Get the list of collection contract addresses for the database
        uint256[] memory collectionDetailIndexForDatabaseId = databaseDetailsIndexToCollectionDetailsIndexMapping[databaseDetailIndex];
        uint256 length = collectionDetailIndexForDatabaseId.length;
        string[] memory collectionList = new string[](length);
        for (uint256 i = 0; i < length; i++) {
            collectionList[i] = collectionDetails[collectionDetailIndexForDatabaseId[i]];
        }

        emit ContractEvent(createResponse(RESPONSE_CODES.COLLECTION_NAMES_SUCCESSFULLY_FETCHED, "Collection Names Successfully Fetched!", collectionList));
        return;
    }


    function createDocument(string memory documentId, string memory collectionId, string memory databaseId) public {        
        if(!checkCollectionId(collectionId)){
            emit ContractEvent(createResponse(RESPONSE_CODES.INVALID_COLLECTION_ID, "Invalid Collection Id!"));
            return;
        }

        if(!checkDatabaseId(databaseId)){
            emit ContractEvent(createResponse(RESPONSE_CODES.INVALID_DATABASE_ID, "Invalid Database Id!"));
            return;
        }

        if(!checkDocumentId(documentId)){
            emit ContractEvent(createResponse(RESPONSE_CODES.INVALID_DOCUMENT_ID, "Invalid Document Id!"));
            return;
        }
    
        uint256 databaseDetailIndex = getDatabaseDetailIndex(databaseId);
    
        // If the database name does not exist, return an error
        if (databaseDetailIndex == MAX_UINT256) {
            emit ContractEvent(createResponse(RESPONSE_CODES.DATABASE_NOT_EXISTS, "Database does not exist!"));
            return;
        }

        uint256 collectionDetailIndex = isCollectionExists(collectionId, databaseDetailIndex);

        if(collectionDetailIndex == MAX_UINT256){
            emit ContractEvent(createResponse(RESPONSE_CODES.INVALID_COLLECTION_ID, "Collection Does Not Exist!"));
            return;
        }

        uint256 documentDetailIndex = isDocumentExists(collectionDetailIndex, documentId);

        if(documentDetailIndex != MAX_UINT256){
            emit ContractEvent(createResponse(RESPONSE_CODES.DOCUMENT_ALREADY_EXISTS, "Document Already Exists!"));
            return;
        }

        documentDetails.push(documentId);
        collectionDetailIndexToDocumentDetailsIndexMapping[collectionDetailIndex].push(documentDetails.length - 1);
        
        emit ContractEvent(createResponse(RESPONSE_CODES.DOCUMENT_SUCCESSFULLY_CREATED, "Document Successfully Created!"));
        return;
    }

    function isCollectionExists(string memory collectionId, uint256 databaseDetailIndex) private view returns(uint256){
        uint256[] memory collectionDetailIndexForDatabaseId = databaseDetailsIndexToCollectionDetailsIndexMapping[databaseDetailIndex];

        if(collectionDetailIndexForDatabaseId.length <= 0){
            return MAX_UINT256;
        }

        for(uint256 i = 0; i < collectionDetailIndexForDatabaseId.length; i++){
            if(keccak256(abi.encodePacked(collectionDetails[collectionDetailIndexForDatabaseId[i]])) == keccak256(abi.encodePacked(collectionId))){
                return collectionDetailIndexForDatabaseId[i];
            }
        }

        return MAX_UINT256;
    }

    function isCollectionExists(string memory collectionId, string memory databaseId) public view returns(bool){
        uint256 databaseDetailIndex = getDatabaseDetailIndex(databaseId);

        if(databaseDetailIndex == MAX_UINT256){
            return false;
        }

        uint256[] memory collectionDetailIndexForDatabaseId = databaseDetailsIndexToCollectionDetailsIndexMapping[databaseDetailIndex];

        if(collectionDetailIndexForDatabaseId.length <= 0){
            return false;
        }

        for(uint256 i = 0; i < collectionDetailIndexForDatabaseId.length; i++){
            if(keccak256(abi.encodePacked(collectionDetails[collectionDetailIndexForDatabaseId[i]])) == keccak256(abi.encodePacked(collectionId))){
                return true;
            }
        }

        return false;
    }

    function getDatabaseDetailIndex(string memory databaseId) private view returns(uint256){
        uint256[] memory databaseDetailsIndex = addressToDatabaseDetailsIndexMapping[msg.sender];

        for(uint256 i = 0; i < databaseDetailsIndex.length; i++){
            if(keccak256(abi.encodePacked(databaseDetails[databaseDetailsIndex[i]])) == keccak256(abi.encodePacked(databaseId))){
                return databaseDetailsIndex[i];
            }
        }

        return MAX_UINT256;
    }

    function isDocumentExists(uint256 collectionDetailIndex, string memory documentId) private view returns(uint256){
        uint256[] memory documentDetailIndexForCollectionId = collectionDetailIndexToDocumentDetailsIndexMapping[collectionDetailIndex];
    
        if(documentDetailIndexForCollectionId.length <= 0){
            return MAX_UINT256;
        }

        for(uint256 i = 0; i < documentDetailIndexForCollectionId.length; i++){
            if(keccak256(abi.encodePacked(documentDetails[documentDetailIndexForCollectionId[i]])) == keccak256(abi.encodePacked(documentId))){
                return documentDetailIndexForCollectionId[i];
            }
        }

        return MAX_UINT256;
    }

    function readDocumentsForCollection(string memory collectionId, string memory databaseId) public {
        if(!checkCollectionId(collectionId)){
            emit ContractEvent(createResponse(RESPONSE_CODES.INVALID_COLLECTION_ID, "Invalid Collection Id!"));
            return;
        }

        if(!checkDatabaseId(databaseId)){
            emit ContractEvent(createResponse(RESPONSE_CODES.INVALID_DATABASE_ID, "Invalid Database Id!"));
            return;
        }

        uint256 databaseDetailIndex = getDatabaseDetailIndex(databaseId);

        if(databaseDetailIndex == MAX_UINT256){
            emit ContractEvent(createResponse(RESPONSE_CODES.DATABASE_NOT_EXISTS, "Database does not exist!"));
            return;
        }

        uint256 collectionDetailIndex = isCollectionExists(collectionId, databaseDetailIndex);

        if(collectionDetailIndex == MAX_UINT256){
            emit ContractEvent(createResponse(RESPONSE_CODES.COLLECTION_NOT_EXISTS, "Collection does not exist!"));
            return;
        }

        uint256[] memory documentDetailIndexForCollectionId = collectionDetailIndexToDocumentDetailsIndexMapping[collectionDetailIndex];

        if(documentDetailIndexForCollectionId.length <= 0){
            emit ContractEvent(createResponse(RESPONSE_CODES.DOCUMENT_NOT_EXISTS, "Document does not exist!"));
            return;
        }

        string[] memory documentList = new string[](documentDetailIndexForCollectionId.length);

        for(uint256 i = 0; i < documentDetailIndexForCollectionId.length; i++){
            documentList[i] = documentDetails[documentDetailIndexForCollectionId[i]];
        }

        emit ContractEvent(createResponse(RESPONSE_CODES.DOCUMENTS_SUCCESSFULLY_FETCHED, "Documents Successfully Fetched!", documentList));
        return;
    }

    function addKeyValue(string memory key, string memory value, string memory documentId, string memory collectionId, string memory databaseId) public  {
        (Response memory response, , , uint256 documentDetailIndex) = handleChecks(databaseId, collectionId, documentId);

        if(response.responseCode != RESPONSE_CODES.CHECKS_PASSED){
            emit ContractEvent(response);
            return;
        }

        // Create a new KeyValue struct and push it to the array associated with the ID
        documentDetailIndexToDataMapping[documentDetailIndex].push(Data(key, value));

        emit ContractEvent(createResponse(RESPONSE_CODES.DATA_SUCCESSFULLY_ADDED, "Data Successfully Added!"));
        return;
    }

    // Function to get a specific key-value pair by ID and index
    function getKeyValue(string memory key, string memory documentId, string memory collectionId, string memory databaseId) public {
        (Response memory response, , , uint256 documentDetailIndex) = handleChecks(databaseId, collectionId, documentId);

        if(response.responseCode != RESPONSE_CODES.CHECKS_PASSED){
            emit ContractEvent(response);
            return;
        }

        Data[] memory dataList = documentDetailIndexToDataMapping[documentDetailIndex];
        string[] memory requestedData = new string[](2);

        for (uint256 i = 0; i < dataList.length; i++) {
            if (keccak256(bytes(dataList[i].key)) == keccak256(bytes(key))) {
                requestedData[0] = dataList[i].key;
                requestedData[1] = dataList[i].value;
                emit ContractEvent(createResponse(RESPONSE_CODES.DATA_SUCCESSFULLY_FETCHED, "Data Successfully Fetched!", requestedData));
                return;
            }
        }
        
        emit ContractEvent(createResponse(RESPONSE_CODES.KEY_NOT_EXISTS, "Key Does Not Exist!"));
        return;
    }

    function getAllKeyValuesForDocument(string memory documentId, string memory collectionId, string memory databaseId) public {
        (Response memory response, , , uint256 documentDetailIndex) = handleChecks(databaseId, collectionId, documentId);

        if(response.responseCode != RESPONSE_CODES.CHECKS_PASSED){
            emit ContractEvent(response);
            return;
        }

        Data[] memory dataList = documentDetailIndexToDataMapping[documentDetailIndex];
        string[] memory requestedData = new string[](dataList.length * 2);

        uint256 index = 0;
        for (uint256 i = 0; i < dataList.length; i++) {
            requestedData[index] = dataList[i].key;
            requestedData[index + 1] = dataList[i].value;
            index += 2;
        }

        emit ContractEvent(createResponse(RESPONSE_CODES.DATA_SUCCESSFULLY_FETCHED, "Data Successfully Fetched!", requestedData));
        return;
    }

    // Function to update the value of a specific key for a given ID
    function updateKeyValue(string memory key, string memory newValue, string memory documentId, string memory collectionId, string memory databaseId) public {
        (Response memory response, , , uint256 documentDetailIndex) = handleChecks(databaseId, collectionId, documentId);

        if(response.responseCode != RESPONSE_CODES.CHECKS_PASSED){
            emit ContractEvent(response);
            return;
        }

        Data[] storage keyValues = documentDetailIndexToDataMapping[documentDetailIndex];

        for (uint256 i = 0; i < keyValues.length; i++) {
            if (keccak256(bytes(keyValues[i].key)) == keccak256(bytes(key))) {
                keyValues[i].value = newValue;
                emit ContractEvent(createResponse(RESPONSE_CODES.DATA_SUCCESSFULLY_UPDATED, "Data Successfully Updated!"));
                return;
            }
        }
        
        emit ContractEvent(createResponse(RESPONSE_CODES.KEY_NOT_EXISTS, "Key Does Not Exist!"));
        return;
    }

    // Function to delete a key-value pair by key for a given ID
    function deleteKeyValue(string memory key, string memory documentId, string memory collectionId, string memory databaseId) public {
        (Response memory response, , , uint256 documentDetailIndex) = handleChecks(databaseId, collectionId, documentId);

        if(response.responseCode != RESPONSE_CODES.CHECKS_PASSED){
            emit ContractEvent(response);
            return;
        }
        
        Data[] storage keyValues = documentDetailIndexToDataMapping[documentDetailIndex];
        for (uint256 i = 0; i < keyValues.length; i++) {
            if (keccak256(bytes(keyValues[i].key)) == keccak256(bytes(key))) {
                keyValues[i] = keyValues[keyValues.length - 1]; // Move the last element to the place of the element to delete
                keyValues.pop(); // Remove the last element
                emit ContractEvent(createResponse(RESPONSE_CODES.DATA_SUCCESSFULLY_DELETED, "Data Successfully Deleted!"));
                return;
            }
        }
        
        emit ContractEvent(createResponse(RESPONSE_CODES.KEY_NOT_EXISTS, "Key Does Not Exist!"));
        return;
    }

    function handleChecks(string memory databaseId, string memory collectionId, string memory documentId) public view returns(Response memory, uint256, uint256, uint256){
        uint256 databaseDetailIndex = MAX_UINT256;
        uint256 collectionDetailIndex = MAX_UINT256;
        
        if(!checkDatabaseId(databaseId)){
            return (createResponse(RESPONSE_CODES.INVALID_DATABASE_ID, "Invalid Database Id!"), MAX_UINT256, MAX_UINT256, MAX_UINT256);
        }
        
        if(!checkCollectionId(collectionId)){
            return (createResponse(RESPONSE_CODES.INVALID_COLLECTION_ID, "Invalid Collection Id!"), MAX_UINT256, MAX_UINT256, MAX_UINT256);
        }

        if(!checkDocumentId(documentId)){
            return (createResponse(RESPONSE_CODES.INVALID_DOCUMENT_ID, "Invalid Document Id!"), MAX_UINT256, MAX_UINT256, MAX_UINT256);
        }

        databaseDetailIndex = getDatabaseDetailIndex(databaseId);

        if(databaseDetailIndex == MAX_UINT256){
            return (createResponse(RESPONSE_CODES.DATABASE_NOT_EXISTS, "Database does not exist!"), MAX_UINT256, MAX_UINT256, MAX_UINT256);
        }

        collectionDetailIndex = isCollectionExists(collectionId, databaseDetailIndex);

        if(collectionDetailIndex == MAX_UINT256){
            return (createResponse(RESPONSE_CODES.COLLECTION_NOT_EXISTS, "Collection does not exist!"), databaseDetailIndex, MAX_UINT256, MAX_UINT256);
        }

        uint256 documentDetailIndex = isDocumentExists(collectionDetailIndex, documentId);

        if(documentDetailIndex == MAX_UINT256){
            return (createResponse(RESPONSE_CODES.DOCUMENT_NOT_EXISTS, "Document does not exist!"), databaseDetailIndex, collectionDetailIndex, MAX_UINT256);
        }

        return (createResponse(RESPONSE_CODES.CHECKS_PASSED, "Checks Passed!"), databaseDetailIndex, collectionDetailIndex, documentDetailIndex);
    }
}