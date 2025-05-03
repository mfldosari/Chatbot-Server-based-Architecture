import os
import psycopg2
from dotenv import load_dotenv
from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient

def get_db_connection():
    load_dotenv()

    key_vault_name = os.environ.get("KEY_VAULT_NAME")
    table_database_name = os.environ.get("TABLE_DATABASE")

    assert key_vault_name, "KEY_VAULT_NAME not set"

    kv_uri = f"https://{key_vault_name}.vault.azure.net"
    credential = DefaultAzureCredential()
    client = SecretClient(vault_url=kv_uri, credential=credential)

    db_name = client.get_secret('PROJ-DB-NAME').value
    db_user = client.get_secret('PROJ-DB-USER').value
    db_password = client.get_secret('PROJ-DB-PASSWORD').value
    db_host = client.get_secret('PROJ-DB-HOST').value
    db_port = client.get_secret('PROJ-DB-PORT').value

    conn = psycopg2.connect(
        dbname=db_name,
        user=db_user,
        password=db_password,
        host=db_host,
        port=db_port
    )
    return conn

def test_advanced_chats_table_exists():
    load_dotenv()
    table_database_name = os.environ.get("TABLE_DATABASE", "advanced_chats")
    conn = get_db_connection()
    cursor = conn.cursor()

    query = """
        SELECT EXISTS (
            SELECT FROM information_schema.tables 
            WHERE table_name = %s
        );
    """
    cursor.execute(query, (table_database_name,))
    exists = cursor.fetchone()[0]
    cursor.close()
    conn.close()
    assert exists, f"Table '{table_database_name}' does not exist in the database"
