import os
from dotenv import load_dotenv
from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient

def test_keyvault_secrets_load():
    load_dotenv()  # Load from .env

    # Get vault URL from environment
    key_vault_name = os.environ.get("KEY_VAULT_NAME")
    assert key_vault_name is not None, "KEY_VAULT_NAME is not set in the environment"

    kv_uri = f"https://{key_vault_name}.vault.azure.net"

    # Authenticate with Azure
    credential = DefaultAzureCredential()
    client = SecretClient(vault_url=kv_uri, credential=credential)

    # Try fetching each secret and assert it exists
    secret_keys = [
        'PROJ-DB-NAME',
        'PROJ-DB-USER',
        'PROJ-DB-PASSWORD',
        'PROJ-DB-HOST',
        'PROJ-DB-PORT',
        'PROJ-OPENAI-API-KEY',
        'PROJ-AZURE-STORAGE-SAS-URL',
        'PROJ-AZURE-STORAGE-CONTAINER',
        'PROJ-CHROMADB-HOST',
        'PROJ-CHROMADB-PORT'
    ]

    for key in secret_keys:
        value = client.get_secret(key).value
        assert value is not None and value != "", f"Secret {key} is empty or not found"
