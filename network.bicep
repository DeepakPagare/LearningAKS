@description('Virtual Network Name')
param vnetName string

@description('Subnet Name')
param subnetName string

@description('Azure Location')
param location string

resource vnet 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: vnetName
  location: location

  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.10.0.0/16'
      ]
    }

    subnets: [
      {
        name: subnetName

        properties: {
          addressPrefix: '10.10.1.0/24'
        }
      }
    ]
  }
}

output subnetId string = vnet.properties.subnets[0].id