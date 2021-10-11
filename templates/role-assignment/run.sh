objectid=$(az ad sp list --display-name timw9078safsaf --query [].objectId --output tsv)
echo $objectid
az deployment group create --resource-group policy-rg --template-file template.json --parameters principalId=$objectid storageName=timwpolicydiags908745 sqlServerName=timw9078safsaf