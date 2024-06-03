from scripts.helpful_scripts import get_account
from scripts.deploy import deploy_endec_database

def test_can_create_database():
    account = get_account()
    database = deploy_endec_database()
    response = database.createDatabase("test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 2  
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
    database = deploy_endec_database()

    response = database.createDatabase("test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 2  
    assert response_code == expected_response_code

    response = database.createDatabase("test_database_2", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 2  
    assert response_code == expected_response_code

    response = database.getMyDatabases({"from": account})
    assert response[0] == "test_database"
    assert response[1] == "test_database_2"

def test_can_user_read_empty_database_list():
    account = get_account()
    database = deploy_endec_database()

    response = database.getMyDatabases({"from": account})
    assert response == []

def test_can_each_user_access_his_own_database_list():
    account = get_account()
    account_1 = get_account(1)
    database = deploy_endec_database()

    response = database.createDatabase("test_database", {"from": account})
    response_code = response.return_value[0]  
    expected_response_code = 2  
    assert response_code == expected_response_code

    response = database.createDatabase("test_database_2", {"from": account_1})
    response_code = response.return_value[0]  
    expected_response_code = 2  
    assert response_code == expected_response_code

    response = database.getMyDatabases({"from": account_1})
    assert response[0] == "test_database_2"

    response = database.getMyDatabases({"from": account})
    assert response[0] == "test_database"

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
    

