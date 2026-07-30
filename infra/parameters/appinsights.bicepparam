using '../bicep/appinsights.bicep'

param appInsightsName = 'appi-enterprise'
param location = 'centralindia'

// Existing Log Analytics Workspace Resource ID
param workspaceResourceId = '/subscriptions/<subscription-id>/resourceGroups/rg-aks-enterprise/providers/Microsoft.OperationalInsights/workspaces/<workspace-name>'