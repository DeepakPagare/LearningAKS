$resourceGroup = "rg-aks-enterprise"
$location = "centralindia"
$appInsightsName = "appi-enterprise"
$workspaceName = "law-aks-enterprise"
$namespace = "microservices"

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host " Deploying Application Insights"
Write-Host "=========================================" -ForegroundColor Cyan

Write-Host ""
Write-Host "Getting Log Analytics Workspace Resource ID..." -ForegroundColor Yellow

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
Write-Host $workspaceId -ForegroundColor Green

Write-Host ""
Write-Host "Deploying Application Insights..." -ForegroundColor Yellow

az deployment group create `
    --resource-group $resourceGroup `
    --template-file "$PSScriptRoot\..\infra\bicep\appinsights.bicep" `
    --parameters `
        appInsightsName=$appInsightsName `
        location=$location `
        workspaceResourceId=$workspaceId

if ($LASTEXITCODE -ne 0) {
    Write-Error "Application Insights deployment failed."
    exit 1
}

Write-Host ""
Write-Host "Retrieving Application Insights Connection String..." -ForegroundColor Yellow

$connectionString = az monitor app-insights component show `
    --resource-group $resourceGroup `
    --app $appInsightsName `
    --query connectionString `
    --output tsv

if (-not $connectionString) {
    Write-Error "Unable to retrieve Application Insights connection string."
    exit 1
}

Write-Host ""
Write-Host "Ensuring Kubernetes namespace exists..." -ForegroundColor Yellow

kubectl create namespace $namespace `
    --dry-run=client -o yaml | kubectl apply -f -

if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to create namespace."
    exit 1
}

Write-Host ""
Write-Host "Creating/Updating Application Insights Secret..." -ForegroundColor Yellow

kubectl create secret generic appinsights-secret `
    --from-literal=APPLICATIONINSIGHTS_CONNECTION_STRING="$connectionString" `
    -n $namespace `
    --dry-run=client -o yaml | kubectl apply -f -

if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to create/update Kubernetes secret."
    exit 1
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host " Application Insights deployed successfully!"
Write-Host " Kubernetes Secret created successfully!"
Write-Host "=========================================" -ForegroundColor Green