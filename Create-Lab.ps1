# ==========================================
# Create-Lab.ps1
# Creates or updates the AKS lab infrastructure
# ==========================================

# Stop on any error
$ErrorActionPreference = "Stop"

# ==========================================
# Configuration
# ==========================================

$SubscriptionId = "a8d36288-ee55-4ff2-9123-c06ed24266fc"
$ResourceGroup  = "rg-aks-enterprise"
$Location       = "Central India"

$BicepFile      = "..\bicep\main.bicep"
$ParameterFile  = "..\bicep\parameters\lab.bicepparam"

# ==========================================
# Login
# ==========================================

Write-Host ""
Write-Host "Connecting to Azure..." -ForegroundColor Cyan

Connect-AzAccount

Write-Host ""
Write-Host "Selecting subscription..." -ForegroundColor Cyan

Set-AzContext -SubscriptionId $SubscriptionId

# ==========================================
# Create Resource Group (if it doesn't exist)
# ==========================================

Write-Host ""
Write-Host "Checking Resource Group..." -ForegroundColor Cyan

$rg = Get-AzResourceGroup -Name $ResourceGroup -ErrorAction SilentlyContinue

if ($null -eq $rg)
{
    Write-Host "Creating Resource Group..." -ForegroundColor Yellow

    New-AzResourceGroup `
        -Name $ResourceGroup `
        -Location $Location
}
else
{
    Write-Host "Resource Group already exists." -ForegroundColor Green
}

# ==========================================
# Deploy Bicep
# ==========================================

Write-Host ""
Write-Host "Deploying infrastructure..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -Name "AKS-Lab-Deployment" `
    -ResourceGroupName $ResourceGroup `
    -TemplateFile $BicepFile `
    -TemplateParameterFile $ParameterFile `
    -Verbose

Write-Host ""
Write-Host "==============================================" -ForegroundColor Green
Write-Host "Deployment completed successfully." -ForegroundColor Green
Write-Host "==============================================" -ForegroundColor Green