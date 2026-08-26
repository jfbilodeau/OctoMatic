@description('Azure region for the App Service resources.')
param location string = 'canadaeast'

module appServicePlan 'br/public:avm/res/web/serverfarm:0.7.0' = {
  params: {
    name: 'octomatic-asp'
    location: location
    kind: 'linux'
    reserved: true
    skuName: 'S1'
    skuCapacity: 1
    zoneRedundant: false
  }
}

module appService 'br/public:avm/res/web/site:0.24.0' = {
  params: {
    name: 'octomatic'
    location: location
    kind: 'app,linux'
    serverFarmResourceId: appServicePlan.outputs.resourceId
    httpsOnly: true
    managedIdentities: {
      systemAssigned: true
    }
    siteConfig: {
      alwaysOn: true
      ftpsState: 'Disabled'
      http20Enabled: true
      linuxFxVersion: 'DOTNETCORE|10.0'
      minTlsVersion: '1.2'
    }
  }
}

output appServiceName string = appService.outputs.name
output appServiceUrl string = 'https://${appService.outputs.defaultHostname}'
