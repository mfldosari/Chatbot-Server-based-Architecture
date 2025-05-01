#!/bin/bash
set -e

date
echo "Updating applications on VM..."

APP_DIR="/home/azureuser/stage6.5"
BRANCH="main"
rm -r -f stage6.5/
# Update code
if [ -d "$APP_DIR" ]; then
    sudo -u azureuser bash -c "cd $APP_DIR && git pull origin $BRANCH"
else
    sudo -u azureuser git clone -b $BRANCH "https://$GITHUB_TOKEN@github.com/mfldosari/stage6.5.git" "$APP_DIR"
fi
source /home/azureuser/stage6.5/myenv/bin/activate
# Install dependencies
sudo -u azureuser /home/azureuser/stage6.5/myenv/bin/pip install --upgrade pip
sudo -u azureuser /home/azureuser/stage6.5/myenv/bin/pip install -r "$APP_DIR/requirements.txt"

# Restart the service
sudo systemctl restart backend
sudo systemctl restart frontend
echo "Applications update completed!"

