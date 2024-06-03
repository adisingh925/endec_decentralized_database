from brownie import EndecDatabase
from scripts.helpful_scripts import get_account

def deploy_endec_database():
    account = get_account()
    database = EndecDatabase.deploy({"from": account})
    return database

def main():
    deploy_endec_database()