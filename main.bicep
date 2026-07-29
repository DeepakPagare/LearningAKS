targetScope = 'resourceGroup'

@description('Azure Location')
param location string = resourceGroup().location

@description('AKS Cluster Name')
param aksName string

@description('Log Analytics Workspace Name')
param workspaceName string

@description('Existing Virtual Network Resource Group')
param vnetResourceGroup string

@description('Existing Virtual Network Name')
param vnetName string

@description('Existing AKS Subnet Name')
param subnetName string

// ============================================
// Existing Virtual Network
// ============================================

resource existingVnet 'Microsoft.Network/virtualNetworks@2024-01-01' existing = {
  scope: resourceGroup(vnetResourceGroup)
  name: vnetName
}

resource existingSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-01-01' existing = {
  parent: existingVnet
  name: subnetName
}

// ============================================
// Log Analytics Workspace
// ============================================

module logAnalytics 'loganalytics.bicep' = {
  name: 'logAnalyticsDeployment'

  params: {
    location: location
    workspaceName: workspaceName
  }
}

// ============================================
// AKS Cluster
// ============================================

module aks 'aks.bicep' = {
  name: 'aksDeployment'

  params: {
    location: location
    aksName: aksName
    subnetId: existingSubnet.id
    logAnalyticsWorkspaceId: logAnalytics.outputs.workspaceId
  }
}

output aksClusterName string = aks.outputs.aksName