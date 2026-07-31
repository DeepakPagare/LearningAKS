# ============================================
# Delete AKS
# ============================================

$ErrorActionPreference = "Stop"

$resourceGroup = "rg-aks-enterprise"
$aksName = "aks-enterprise"

Write-Host ""
Write-Host "=========================================" -ForegroundColor Yellow
Write-Host " Deleting AKS Cluster"
Write-Host "=========================================" -ForegroundColor Yellow

# Check whether the cluster exists
$clusterExists = az aks show `
    --resource-group $resourceGroup `
    --name $aksName `
    --query "name" `
    --output tsv 2>$null

if (-not $clusterExists) {
    Write-Host ""
    Write-Host "AKS cluster '$aksName' does not exist." -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "Deleting AKS cluster..." -ForegroundColor Yellow

az aks delete `
    --resource-group $resourceGroup `
    --name $aksName `
    --yes

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Failed to delete AKS cluster." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host " AKS cluster deleted successfully!"
Write-Host "=========================================" -ForegroundColor Green