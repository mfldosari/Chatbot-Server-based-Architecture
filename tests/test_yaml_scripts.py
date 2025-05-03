import pytest
import yaml
import os
import socket

# Paths to the YAML files
yaml_file_1_path = './azure-terraform-iaac-practice2-stage5to6.5/modules/compute/vm.yaml'  # Update the filename accordingly
yaml_file_2_path = './azure-terraform-iaac-practice2-stage5to6.5/modules/compute/vmss.yaml'  # Update the filename accordingly

# Helper function to load and parse YAML from a file
def load_yaml_from_file(file_path):
    with open(file_path, 'r') as file:
        return yaml.safe_load(file)

# Test for the first YAML file
def test_yaml_structure_1():
    data = load_yaml_from_file(yaml_file_1_path)
    
    # Check if 'runcmd' key exists
    assert 'runcmd' in data, "Missing 'runcmd' in YAML"

    # Check if certain commands exist in the runcmd list
    assert "apt update && apt install -y python3-pip python3-venv git docker.io" in data['runcmd'], "Install packages command missing"
    assert "export USER" in '\n'.join(data['runcmd']), "user is not defined"
    assert "export GROUP" in '\n'.join(data['runcmd']), "group is not defined"
    # Test for specific services being created
    assert "chromadb.service" in '\n'.join(data['runcmd']), "ChromaDB service creation is missing"

    assert "sudo systemctl daemon-reload" in '\n'.join(data['runcmd']), "daemon-reload cammand is missing"

    assert "sudo systemctl enable chromadb && sudo systemctl start chromadb" in '\n'.join(data['runcmd']), "Enabling and starting service cammand is missing"


# Test for the second YAML file
def test_yaml_structure_2():
    data = load_yaml_from_file(yaml_file_2_path)
    
    # Check if 'runcmd' key exists
    assert 'runcmd' in data, "Missing 'runcmd' in YAML"

    # Check for installation of packages
    assert "apt update && apt install -y python3-pip python3-venv git" in data['runcmd'], "Install packages command missing"

    # Test for GitHub token export and other values

    assert "G_TOKEN=" in '\n'.join(data['runcmd']), "github token is not defined"
    assert "REPO_URL=" in '\n'.join(data['runcmd']), "repo url is not defined"
    assert "REPO_NAME=" in '\n'.join(data['runcmd']), "repo name is not defined"
    assert "KEY_VAULT_NAME=" in '\n'.join(data['runcmd']), "key vault name is not defined"
    assert "USERNAME=" in '\n'.join(data['runcmd']), "user is not defined"

    assert "sudo -u $USER bash -c" in '\n'.join(data['runcmd']), "Run services as user not root"
    assert "$REPO_NAME" in '\n'.join(data['runcmd']), "Repo name is missing"
    assert  'echo "KEY_VAULT_NAME=$KEY_VAULT_NAME" > .env' in '\n'.join(data['runcmd']), "Key Vault command is missing"
    assert "python3 -m venv myenv" in '\n'.join(data['runcmd']), "ENV is missing"
    assert 'git clone -b main "https://${GITHUB_TOKEN}@${REPO_URL}" &&' in '\n'.join(data['runcmd']), "Git clone command missing"

    # Test for systemd service creation
    assert 'WorkingDirectory=/home/$USER/$REPO_NAME' in '\n'.join(data['runcmd']), "Working Directory is missing in one of the services"
    assert 'ExecStart=/home/$USER/$REPO_NAME/myenv/bin/uvicorn backend:app --reload --port 5000 --host 0.0.0.0' in '\n'.join(data['runcmd']), "fastapi run command is missing in the service"
    assert 'ExecStart=/home/$USER/$REPO_NAME/myenv/bin/streamlit run chatbot.py' in '\n'.join(data['runcmd']), "streamlit run command is missing in the service"
    assert "backend.service" in '\n'.join(data['runcmd']), "Backend service creation is missing"
    assert "frontend.service" in '\n'.join(data['runcmd']), "Frontend service creation is missing"
