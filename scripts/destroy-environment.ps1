# ============================================
# Destroy AKS Environment
# ============================================

$ErrorActionPreference = "Stop"

$resourceGroup = "rg-aks-enterprise"

Write-Host ""
Write-Host "=========================================" -ForegroundColor Yellow
Write-Host " Destroying AKS Environment"
Write-Host "=========================================" -ForegroundColor Yellow

$exists = az group exists --name $resourceGroup

if ($exists -eq "false") {
    Write-Host ""
    Write-Host "Resource group '$resourceGroup' does not exist." -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "Deleting resource group..." -ForegroundColor Yellow

az group delete `
    --name $resourceGroup `
    --yes

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Failed to delete resource group." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host " Environment deleted successfully!"
Write-Host "=========================================" -ForegroundColor Green