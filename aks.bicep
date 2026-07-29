@description('AKS Cluster Name')
param aksName string

@description('Azure Location')
param location string

@description('Existing AKS Subnet Resource ID')
param subnetId string

@description('Log Analytics Workspace Resource ID')
param logAnalyticsWorkspaceId string

resource aks 'Microsoft.ContainerService/managedClusters@2024-02-01' = {
  name: aksName
  location: location

  identity: {
    type: 'SystemAssigned'
  }

  sku: {
    name: 'Base'
    tier: 'Free'
  }

  properties: {
    dnsPrefix: aksName

    kubernetesVersion: ''

    agentPoolProfiles: [
      {
        name: 'system'
        mode: 'System'
        count: 1
        vmSize: 'Standard_D2s_v3'   
        osType: 'Linux'
        osSKU: 'Ubuntu'
        type: 'VirtualMachineScaleSets'
        vnetSubnetID: subnetId
      }
    ]

    networkProfile: {
  networkPlugin: 'azure'
  loadBalancerSku: 'standard'

  serviceCidr: '172.20.0.0/16'
  dnsServiceIP: '172.20.0.10'
}

    addonProfiles: {
      omsagent: {
        enabled: true
        config: {
          logAnalyticsWorkspaceResourceID: logAnalyticsWorkspaceId
        }
      }
    }
  }
}

output aksId string = aks.id
output aksName string = aks.name