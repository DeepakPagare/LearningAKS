# ============================================
# Deploy AKS
# ============================================

$ErrorActionPreference = "Stop"

$resourceGroup = "rg-aks-enterprise"
$location = "centralindia"
$aksName = "aks-enterprise"
$acrName = "deepakaksacr"

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host " Deploying AKS Infrastructure"
Write-Host "=========================================" -ForegroundColor Cyan

# ============================================
# Create Resource Group
# ============================================

Write-Host ""
Write-Host "Creating Resource Group..." -ForegroundColor Yellow

az group create `
    --name $resourceGroup `
    --location $location

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Failed to create Resource Group." -ForegroundColor Red
    exit 1
}

Write-Host "Resource Group is ready." -ForegroundColor Green

# ============================================
# Deploy Infrastructure
# ============================================

Write-Host ""
Write-Host "Deploying infrastructure..." -ForegroundColor Yellow

az deployment group create `
    --resource-group $resourceGroup `
    --template-file "$PSScriptRoot\..\infra\bicep\main.bicep"

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Infrastructure deployment failed." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Infrastructure deployed successfully." -ForegroundColor Green

# ============================================
# Get AKS Credentials
# ============================================

Write-Host ""
Write-Host "Getting AKS credentials..." -ForegroundColor Yellow

az aks get-credentials `
    --resource-group $resourceGroup `
    --name $aksName `
    --overwrite-existing

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Failed to get AKS credentials." -ForegroundColor Red
    exit 1
}

Write-Host "AKS credentials updated." -ForegroundColor Green

# ============================================
# Attach Azure Container Registry
# ============================================

Write-Host ""
Write-Host "Attaching Azure Container Registry..." -ForegroundColor Yellow

az aks update `
    --resource-group $resourceGroup `
    --name $aksName `
    --attach-acr $acrName

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Failed to attach Azure Container Registry." -ForegroundColor Red
    exit 1
}

Write-Host "Azure Container Registry attached." -ForegroundColor Green

# ============================================
# Deploy Kubernetes Resources
# ============================================

Write-Host ""
Write-Host "Deploying Kubernetes manifests..." -ForegroundColor Yellow

& "$PSScriptRoot\deploy-k8s.ps1"

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Kubernetes deployment failed." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host " AKS deployment completed successfully!"
Write-Host "=========================================" -ForegroundColor Green