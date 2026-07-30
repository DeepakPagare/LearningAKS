@description('Azure Location')
param location string

@description('ACR Name')
param acrName string

resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: acrName
  location: location
  sku: {
    name: 'Basic'
  }

  properties: {
    adminUserEnabled: false
  }
}

output acrId string = acr.id
output acrName string = acr.name