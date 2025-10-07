param diagnosticSettingName string = 'afd-to-eventhub'
param eventHubNamespaceId string = '/subscriptions/b94dd326-4ef4-4002-bc9e-ce739b32a706/resourceGroups/MSFT_PPE_Ehub_RG/providers/Microsoft.EventHub/namespaces/IAMUT-EventHub-PPEns'
param eventHubName string = 'iamut-eventhub-ppe'

resource frontDoorProfile 'Microsoft.Cdn/profiles@2023-05-01' existing = {
  name: 'aadcdnppe-legacy-msft'
  scope: resourceGroup('IAM_Tenant_Branding_Legacy_Microsoft_CDN_RG')
}

resource diagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: diagnosticSettingName
  scope: frontDoorProfile
  properties: {
    eventHubName: eventHubName
    logs: [
      {
        category: 'FrontDoorAccessLog'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
    exportToResourceSpecific: true
    identity: {
      type: 'SystemAssigned'
    }
    destination: {
      resourceId: eventHubNamespaceId
    }
  }
}
