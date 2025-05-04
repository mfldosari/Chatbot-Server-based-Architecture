#!/bin/bash
az storage blob generate-sas \
  --account-name storageaccount7603 \
  --container-name chatbot \
  --name pdf_store \
  --permissions acdrw \
  --expiry 2025-05-05T00:00:00Z \
  --auth-mode login \
  --as-user \
  --full-uri > ./sas_token.txt
  
  az keyvault secret set --vault-name chatbot13-keyvault --name PROJ-AZURE-STORAGE-SAS-URL --value $(cat ./sas_token.txt)
