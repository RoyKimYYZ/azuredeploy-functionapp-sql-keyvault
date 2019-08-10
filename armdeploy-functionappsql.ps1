Import-Module Az

Connect-AzAccount
Get-AzContext

Select-AzSubscription -SubscriptionName "Visual Studio Enterprise"

Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force -Scope Process

#### Api-version
((Get-AzResourceProvider -ProviderNamespace Microsoft.Web).ResourceTypes | Where-Object ResourceTypeName -eq sites).ApiVersions
(Get-AzResourceProvider -ProviderNamespace Microsoft.Web).ResourceTypes | Format-Table
$Provider=Get-AzResourceProvider | Format-Table 
$Provider.ResourceTypes
#####
$resourceGroupName = "rkfunctionapp-sql"
New-AzResourceGroup -Name $resourceGroupName  -Location "Canada Central" -Force 

# Just validates the json file.

# from github
Test-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateUri 'https://raw.githubusercontent.com/RoyKimYYZ/azuredeploy-functionapp-sql-keyvault/master/azuredeploy-functionapp-sql-main.json?token=AB3kogVprN3kK8DUgUVVwWS8p88JqoA3ks5cmDM9wA%3D%3D' -TemplateParameterUri 'https://raw.githubusercontent.com/RoyKimYYZ/azuredeploy-functionapp-sql-keyvault/master/azuredeploy-functionappsql.paramaters.json?token=AB3kogv4Y26g_wIxstwp-dxMsrvcCW5Eks5cmDO7wA%3D%3D'

Remove-AzResourceGroup $resourceGroupName -Force
New-AzResourceGroup -Name $resourceGroupName  -Location "Canada Central" -Force 

#$resourceGroupDeployment = New-AzResourceGroupDeployment -Name $resourceGroupName'Deployment' -ResourceGroupName $resourceGroupName `
#-TemplateFile .\\arm-functionapp-sql-main.json -TemplateParameterFile .\armdeploy-functionappsql.paramaters.json -DeploymentDebugLogLevel All -Mode Complete -Force

# Deploy from Github repo
$resourceGroupDeployment = New-AzResourceGroupDeployment -Name $resourceGroupName'Deployment' -ResourceGroupName $resourceGroupName `
-TemplateUri 'https://raw.githubusercontent.com/RoyKimYYZ/azuredeploy-functionapp-sql-keyvault/master/azuredeploy-functionapp-sql-main.json' `
-TemplateParameterUri 'https://raw.githubusercontent.com/RoyKimYYZ/azuredeploy-functionapp-sql-keyvault/master/azuredeploy-functionappsql.paramaters.json' `
-DeploymentDebugLogLevel All -Mode Complete -Force

