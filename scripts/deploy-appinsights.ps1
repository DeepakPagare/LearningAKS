$resourceGroup = "rg-aks-enterprise"
$location = "centralindia"
$appInsightsName = "appi-enterprise"
$workspaceName = "law-aks-enterprise"

Write-Host "Getting Log Analytics Workspace Resource ID..."

$workspaceId = az monitor log-analytics workspace show `
    --resource-group $resourceGroup `
    --workspace-name $workspaceName `
    --query id `
    --output tsv

if (-not $workspaceId) {
    Write-Error "Unable to find Log Analytics Workspace."
    exit 1
}

Write-Host "Workspace ID:"
Write-Host $workspaceId

Write-Host "Deploying Application Insights..."

az deployment group create `
    --resource-group $resourceGroup `
    --template-file ./infra/bicep/appinsights.bicep `
    --parameters `
        appInsightsName=$appInsightsName `
        location=$location `
        workspaceResourceId=$workspaceId