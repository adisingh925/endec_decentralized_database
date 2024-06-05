from brownie import EndecDatabase
from scripts.helpful_scripts import get_account

accountIndex = -1

def deploy_endec_database(index):
    account = get_account(index)
    database = EndecDatabase.deploy({"from": account})
    return database

def create_database(databaseId, index):
    account = get_account(index)
    database = EndecDatabase[-1]
    tx = database.createDatabase(databaseId, {"from": account})
    tx.wait(1)    
    print(tx.events)

def create_document(documentId, collectionId, databaseId, index):
    account = get_account(index)
    database = EndecDatabase[-1]
    tx = database.createDocument(documentId, collectionId, databaseId, {"from": account})
    tx.wait(1)
    print(tx.events)

def create_collection(collectionId, databaseId, index):
    account = get_account(index)
    database = EndecDatabase[-1]
    tx = database.createCollection(collectionId, databaseId, {"from": account})
    tx.wait(1)
    print(tx.events)

def insert_data(key, value, documentId, collectionId, databaseId, index):
    account = get_account(index)
    database = EndecDatabase[-1]
    tx = database.addKeyValue(key, value, documentId, collectionId, databaseId, {"from": account})
    tx.wait(1)
    print(tx.events)

def update_data(key, value, documentId, collectionId, databaseId, index):
    account = get_account(index)
    database = EndecDatabase[-1]
    tx = database.updateKeyValue(key, value, documentId, collectionId, databaseId, {"from": account})
    tx.wait(1)
    print(tx.events)

def delete_data(key, documentId, collectionId, databaseId, index):
    account = get_account(index)
    database = EndecDatabase[-1]
    tx = database.deleteKeyValue(key, documentId, collectionId, databaseId, {"from": account})
    tx.wait(1)
    print(tx.events)

def read_data(key, documentId, collectionId, databaseId, index):
    account = get_account(index)
    database = EndecDatabase[-1]
    tx = database.getKeyValue(key, documentId, collectionId, databaseId, {"from": account})
    tx.wait(1)
    print(tx.events)

def read_databases(index):
    account = get_account(index)
    database = EndecDatabase[-1]
    tx = database.getMyDatabases({"from": account})
    tx.wait(1)
    print(tx.events)

def read_collections(databaseId, index):
    account = get_account(index)
    database = EndecDatabase[-1]
    tx = database.getCollectionNamesForDatabase(databaseId, {"from": account})
    tx.wait(1)
    print(tx.events)

def read_documents(collectionId, databaseId, index):
    account = get_account(index)
    database = EndecDatabase[-1]
    tx = database.readDocumentsForCollection(collectionId, databaseId, {"from": account})
    tx.wait(1)
    print(tx.events)

def read_all_data_for_document(documentId, collectionId, databaseId, index):
    account = get_account(index)
    database = EndecDatabase[-1]
    tx = database.getAllKeyValuesForDocument(documentId, collectionId, databaseId, {"from": account})
    tx.wait(1)
    print(tx.events)

def main():
    while True:
        print("\nEndec Decentralized Database:")
        print("0. Select Account")
        print("1. Deploy Contract\n")
        print("2. Create Database")
        print("3. Create Document")
        print("4. Create Collection\n")

        print("5. Insert Data")
        print("6. Update Data")
        print("7. Delete Data")
        print("8. Read Data\n")

        print("9. Read All Database Ids")
        print("10. Read All Collection Ids")
        print("11. Read All Document Ids")
        print("12. Read All Data For Document\n")

        print("13. Exit\n")
        choice = input("Enter your choice (1-11): ")

        if choice == "0":
            global accountIndex
            accountIndex = int(input("Enter the account index: "))
        elif choice == "1":
            deploy_endec_database(accountIndex)
        elif choice == "2":
            databaseId = input("Enter the database id: ")
            create_database(databaseId, accountIndex)
        elif choice == "3":
            documentId, collectionId, databaseId = input("Enter the document id, collection Id, database Id: ").split()
            create_document(documentId, collectionId, databaseId, accountIndex)
        elif choice == "4":
            collectionId, databaseId = input("Enter the collection id and database id: ").split()
            create_collection(collectionId, databaseId, accountIndex)
        elif choice == "5":
            key, value, documentId, collectionId, databaseId = input("Enter the key, value, document id, collection id, database id: ").split()
            insert_data(key, value, documentId, collectionId, databaseId, accountIndex)
        elif choice == "6":
            key, value, documentId, collectionId, databaseId = input("Enter the key, value, document id, collection id, database id: ").split()
            update_data(key, value, documentId, collectionId, databaseId, accountIndex)
        elif choice == "7":
            key, documentId, collectionId, databaseId = input("Enter the key, document id, collection id, database id: ").split()
            delete_data(key, documentId, collectionId, databaseId, accountIndex)
        elif choice == "8":
            key, documentId, collectionId, databaseId = input("Enter the key, document id, collection id, database id: ").split()
            read_data(key, documentId, collectionId, databaseId, accountIndex)
        elif choice == "9":
            read_databases(accountIndex)
        elif choice == "10":
            databaseId = input("Enter the database id: ")
            read_collections(databaseId, accountIndex)
        elif choice == "11":
            collectionId, databaseId = input("Enter the collection id and database id: ").split()
            read_documents(collectionId, databaseId, accountIndex)
        elif choice == "12":
            documentId, collectionId, databaseId = input("Enter the document id, collection id, database id: ").split()
            read_all_data_for_document(documentId, collectionId, databaseId, accountIndex)
        elif choice == "13":
            break
        else:
            print("Invalid choice. Please try again.")