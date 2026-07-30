targetScope = 'resourceGroup'

@description('Azure Location')
param location string = resourceGroup().location

@description('AKS Cluster Name')
param aksName string = 'aks-enterprise'

@description('Log Analytics Workspace Name')
param workspaceName string = 'law-aks-enterprise'

@description('Azure Container Registry Name')
param acrName string = 'deepakaksacr'

@description('Existing Virtual Network Resource Group')
param vnetResourceGroup string = 'AdminAppSrc'

@description('Existing Virtual Network Name')
param vnetName string = 'vnet-enterprise'

@description('Existing AKS Subnet Name')
param subnetName string = 'aks-subnet'

//
// Existing Virtual Network
//

resource existingVnet 'Microsoft.Network/virtualNetworks@2024-01-01' existing = {
  scope: resourceGroup(vnetResourceGroup)
  name: vnetName
}

resource existingSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-01-01' existing = {
  parent: existingVnet
  name: subnetName
}

//
// Azure Container Registry
//

module acr './acr.bicep' = {
  name: 'acrDeployment'

  params: {
    location: location
    acrName: acrName
  }
}

//
// Log Analytics Workspace
//

module logAnalytics './loganalytics.bicep' = {
  name: 'logAnalyticsDeployment'

  params: {
    location: location
    workspaceName: workspaceName
  }
}

//
// AKS Cluster
//

module aks './aks.bicep' = {
  name: 'aksDeployment'

  params: {
    location: location
    aksName: aksName
    subnetId: existingSubnet.id
    logAnalyticsWorkspaceId: logAnalytics.outputs.workspaceId
  }

  dependsOn: [
    acr
    logAnalytics
  ]
}

output aksClusterName string = aks.outputs.aksName
output aksId string = aks.outputs.aksId
output acrName string = acr.outputs.acrName
output acrId string = acr.outputs.acrId