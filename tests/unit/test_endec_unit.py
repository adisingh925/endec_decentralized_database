from scripts.helpful_scripts import get_account
from scripts.deploy import deploy_endec_database

def test_can_create_database():
    account = get_account()
    database = deploy_endec_database()
    response = database.createDatabase("test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 2  
    assert response_code == expected_response_code

def test_error_in_creating_empty_database():
    account = get_account()
    database = deploy_endec_database()
    response = database.createDatabase("", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 6  
    assert response_code == expected_response_code

def test_can_create_duplicate_database():
    account = get_account()
    database = deploy_endec_database()

    response = database.createDatabase("test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 2  
    assert response_code == expected_response_code

    response = database.createDatabase("test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 9  
    assert response_code == expected_response_code

def test_can_create_multiple_databases():
    account = get_account()
    database = deploy_endec_database()

    response = database.createDatabase("test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 2  
    assert response_code == expected_response_code

    response = database.createDatabase("test_database_2", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 2  
    assert response_code == expected_response_code

def test_can_owner_read_his_own_databases():
    account = get_account()
    account_1 = get_account(1)
    database = deploy_endec_database()

    response = database.createDatabase("test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 2  
    assert response_code == expected_response_code

    response = database.createDatabase("test_database_2", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 2  
    assert response_code == expected_response_code

    response = database.createDatabase("test_database_3", {"from": account_1})
    response_code = response.return_value[0]  
    expected_response_code = 2  
    assert response_code == expected_response_code

    response = database.getMyDatabases({"from": account})
    assert response[2][0] == "test_database"
    assert response[2][1] == "test_database_2"

    response = database.getMyDatabases({"from": account_1})
    assert response[2][0] == "test_database_3"

def test_can_user_read_empty_database_list():
    account = get_account()
    database = deploy_endec_database()

    response = database.getMyDatabases({"from": account})
    assert response[2] == []

def test_can_user_create_collection():
    account = get_account()
    database = deploy_endec_database()

    response = database.createDatabase("test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 2  
    assert response_code == expected_response_code

    response = database.createCollection("test_collection", "test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 4  
    assert response_code == expected_response_code

def test_will_get_error_when_creating_collection_in_non_existent_database():
    account = get_account()
    database = deploy_endec_database()

    response = database.createCollection("test_collection", "test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 5  
    assert response_code == expected_response_code

def test_can_create_multiple_collections():
    account = get_account()
    database = deploy_endec_database()

    response = database.createDatabase("test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 2  
    assert response_code == expected_response_code

    response = database.createCollection("test_collection", "test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 4  
    assert response_code == expected_response_code

    response = database.createCollection("test_collection_2", "test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 4  
    assert response_code == expected_response_code

def test_can_owner_read_his_own_collections():
    account = get_account()
    database = deploy_endec_database()

    response = database.createDatabase("test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 2  
    assert response_code == expected_response_code

    response = database.createCollection("test_collection", "test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 4  
    assert response_code == expected_response_code

    response = database.createCollection("test_collection_2", "test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 4  
    assert response_code == expected_response_code

    response = database.getCollectionNamesForDatabase("test_database", {"from": account})
    assert response[2][0] == "test_collection"
    assert response[2][1] == "test_collection_2"

def test_can_multiple_users_read_there_own_collections():
    account = get_account()
    account_1 = get_account(1)
    database = deploy_endec_database()

    response = database.createDatabase("test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 2  
    assert response_code == expected_response_code

    response = database.createCollection("test_collection", "test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 4  
    assert response_code == expected_response_code

    response = database.createDatabase("test_database", {"from": account_1})
    response_code = response.return_value[0]  
    expected_response_code = 2  
    assert response_code == expected_response_code

    response = database.createCollection("test_collection2", "test_database", {"from": account_1})
    response_code = response.return_value[0]  
    expected_response_code = 4  
    assert response_code == expected_response_code

    response = database.getCollectionNamesForDatabase("test_database", {"from": account})
    assert response[2][0] == "test_collection"

    response = database.getCollectionNamesForDatabase("test_database", {"from": account_1})
    assert response[2][0] == "test_collection2"

def test_can_read_empty_collections():
    account = get_account()
    database = deploy_endec_database()

    response = database.createDatabase("test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 2  
    assert response_code == expected_response_code

    response = database.getCollectionNamesForDatabase("test_database", {"from": account})
    assert response[2] == []

def test_can_create_document():
    account = get_account()
    database = deploy_endec_database()

    response = database.createDatabase("test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 2  
    assert response_code == expected_response_code
 
    response = database.createCollection("test_collection", "test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 4  
    assert response_code == expected_response_code

    response = database.createDocument("test_document", "test_collection", "test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 7  
    assert response_code == expected_response_code

def test_can_read_document():
    account = get_account()
    database = deploy_endec_database()

    response = database.createDatabase("test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 2  
    assert response_code == expected_response_code
 
    response = database.createCollection("test_collection", "test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 4  
    assert response_code == expected_response_code

    response = database.createDocument("test_document", "test_collection", "test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 7  
    assert response_code == expected_response_code

    response = database.readDocumentsForCollection("test_collection", "test_database", {"from": account})
    expected_response_code = 16  
    assert response[2][0] == "test_document"

def test_can_read_empty_document_list():
    account = get_account()
    database = deploy_endec_database()

    response = database.createDatabase("test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 2  
    assert response_code == expected_response_code
 
    response = database.createCollection("test_collection", "test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 4  
    assert response_code == expected_response_code

    response = database.readDocumentsForCollection("test_collection", "test_database", {"from": account})
    expected_response_code = 16  
    assert response[2] == []

def test_can_different_users_read_there_own_documents():
    account = get_account()
    account_1 = get_account(1)
    database = deploy_endec_database()

    response = database.createDatabase("test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 2  
    assert response_code == expected_response_code
 
    response = database.createCollection("test_collection", "test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 4  
    assert response_code == expected_response_code

    response = database.createDocument("test_document", "test_collection", "test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 7  
    assert response_code == expected_response_code

    response = database.createDatabase("test_database", {"from": account_1})
    response_code = response.return_value[0]  
    expected_response_code = 2  
    assert response_code == expected_response_code
 
    response = database.createCollection("test_collection", "test_database", {"from": account_1})
    response_code = response.return_value[0]  
    expected_response_code = 4  
    assert response_code == expected_response_code

    response = database.createDocument("test_document_2", "test_collection", "test_database", {"from": account_1})
    response_code = response.return_value[0]  
    expected_response_code = 7  
    assert response_code == expected_response_code

    response = database.readDocumentsForCollection("test_collection", "test_database", {"from": account})
    assert response[2][0] == "test_document"

    response = database.readDocumentsForCollection("test_collection", "test_database", {"from": account_1})
    assert response[2][0] == "test_document_2"


def test_can_insert_data_into_document():
    account = get_account()
    database = deploy_endec_database()

    response = database.createDatabase("test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 2  
    assert response_code == expected_response_code
 
    response = database.createCollection("test_collection", "test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 4  
    assert response_code == expected_response_code

    response = database.createDocument("test_document", "test_collection", "test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 7  
    assert response_code == expected_response_code

    response = database.addKeyValue("key", "value", "test_document", "test_collection", "test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 18  
    assert response_code == expected_response_code

def test_can_read_data_from_document():
    account = get_account()
    database = deploy_endec_database()

    response = database.createDatabase("test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 2  
    assert response_code == expected_response_code
 
    response = database.createCollection("test_collection", "test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 4  
    assert response_code == expected_response_code

    response = database.createDocument("test_document", "test_collection", "test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 7  
    assert response_code == expected_response_code

    response = database.addKeyValue("key", "value", "test_document", "test_collection", "test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 18  
    assert response_code == expected_response_code

    response = database.getKeyValue("key", "test_document", "test_collection", "test_database", {"from": account})
    assert response[2][0] == "key"
    assert response[2][1] == "value"

def test_can_update_data_in_document():
    account = get_account()
    database = deploy_endec_database()

    response = database.createDatabase("test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 2  
    assert response_code == expected_response_code
 
    response = database.createCollection("test_collection", "test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 4  
    assert response_code == expected_response_code

    response = database.createDocument("test_document", "test_collection", "test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 7  
    assert response_code == expected_response_code

    response = database.addKeyValue("key", "value", "test_document", "test_collection", "test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 18  
    assert response_code == expected_response_code

    response = database.updateKeyValue("key", "value2", "test_document", "test_collection", "test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 22  
    assert response_code == expected_response_code

    response = database.getKeyValue("key", "test_document", "test_collection", "test_database", {"from": account})
    assert response[2][0] == "key"
    assert response[2][1] == "value2"

def test_can_delete_data_from_document():
    account = get_account()
    database = deploy_endec_database()

    response = database.createDatabase("test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 2  
    assert response_code == expected_response_code
 
    response = database.createCollection("test_collection", "test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 4  
    assert response_code == expected_response_code

    response = database.createDocument("test_document", "test_collection", "test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 7  
    assert response_code == expected_response_code

    response = database.addKeyValue("key", "value", "test_document", "test_collection", "test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 18  
    assert response_code == expected_response_code

    response = database.deleteKeyValue("key", "test_document", "test_collection", "test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 23  
    assert response_code == expected_response_code

    response = database.getKeyValue("key", "test_document", "test_collection", "test_database", {"from": account})
    assert response[2] == []
    

