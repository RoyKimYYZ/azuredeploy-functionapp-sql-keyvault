Connect-AzureRmAccount
Get-AzureRmContext

Select-AzureRmSubscription -SubscriptionName "Visual Studio Enterprise"

Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force -Scope Process


#### Api-version
((Get-AzureRmResourceProvider -ProviderNamespace Microsoft.Web).ResourceTypes | Where-Object ResourceTypeName -eq sites).ApiVersions
(Get-AzureRmResourceProvider -ProviderNamespace Microsoft.Web).ResourceTypes | Out-GridView
$Provider=Get-AzureRmResourceProvider|Out-GridView -PassThru
$Provider.ResourceTypes
#####
$resourceGroupName = "rkfunctionapp-sql"
New-AzureRmResourceGroup -Name $resourceGroupName  -Location "Canada Central" -Force 

# Just validates the json file.
Test-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile .\arm-functionapp-sql-main.json -TemplateParameterFile .\armdeploy-functionappsql.paramaters.json

Remove-AzureRmResourceGroup $resourceGroupName -Force
New-AzureRmResourceGroup -Name $resourceGroupName  -Location "Canada Central" -Force 

$resourceGroupDeployment = New-AzureRmResourceGroupDeployment -Name $resourceGroupName'Deployment' -ResourceGroupName $resourceGroupName `
-TemplateFile .\\arm-functionapp-sql-main.json -TemplateParameterFile .\armdeploy-functionappsql.paramaters.json -DeploymentDebugLogLevel All -Mode Complete -Force

$resourceGroupDeployment
$out = $resourceGroupDeployment.Outputs["resourceGroupName"].Value
$SqlPassword = $resourceGroupDeployment.Outputs["sqlAdministratorLoginPassword"].Value

Get-AzureRmResourceGroupDeploymentOperation -DeploymentName $resourceGroupName'Deployment' -ResourceGroupName $resourceGroupName

Remove-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -Name $resourceGroupName'Deployment' 

# DEBUGGING TROUBLESHOOTING
$operations = Get-AzureRmResourceGroupDeploymentOperation –DeploymentName $resourceGroupName'Deployment' –ResourceGroupName $resourceGroupName `
    | Where-Object ProvisioningState -eq Failed

foreach($operation in $operations)
{
    Write-Host $operation.id
    Write-Host "Request:"
    $operation.Properties.Request | ConvertTo-Json -Depth 10
    Write-Host "Response:"
    $operation.Properties.Response | ConvertTo-Json -Depth 10
}

#### TEST UI Definition
.\SideLoad-CreateUIDefinition.ps1 -createUIDefFile .\createUiDefinition.json `
  -StorageResourceGroupLocation canadacentral `
  -storageContainerName arm-templates -ArtifactsStagingDirectory .\

Get-AzureRmStorageAccount -ResourceGroupName Enterprise -Name rkimstorage


