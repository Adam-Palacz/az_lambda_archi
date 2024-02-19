# data "azurerm_resource_group" "rg" {
#   name = var.rg_name
# }

# resource "azurerm_portal_dashboard" "lambda-board" {
#   name                = "Lambda"
#   resource_group_name = data.azurerm_resource_group.rg.name
#   location            = data.azurerm_resource_group.rg.location
#   tags = {
#     environment = data.azurerm_resource_group.rg.tags["environment"]
#     team        = data.azurerm_resource_group.rg.tags["team"]
#   }
#   dashboard_properties = <<DASH
# {
#   "properties": {
#     "lenses": {
#       "0": {
#         "order": 0,
#         "parts": {
#           "0": {
#             "position": {
#               "x": 0,
#               "y": 0,
#               "colSpan": 6,
#               "rowSpan": 4
#             },
#             "metadata": {
#               "inputs": [
#                 {
#                   "name": "id",
#                   "value": "/subscriptions/207adc7d-e3e9-41ae-ba94-47ab3f626fec/resourceGroups/rg-apdvc-dev-westeurope/providers/Microsoft.EventHub/namespaces/ehns-apdvc-dev-westeurope/eventhubs/rawdata",
#                   "isOptional": true
#                 },
#                 {
#                   "name": "resourceId",
#                   "isOptional": true
#                 },
#                 {
#                   "name": "menuid",
#                   "isOptional": true
#                 }
#               ],
#               "type": "Extension/HubsExtension/PartType/ResourcePart",
#               "asset": {
#                 "idInputName": "id"
#               },
#               "deepLink": "#@m365ht.onmicrosoft.com/resource/subscriptions/207adc7d-e3e9-41ae-ba94-47ab3f626fec/resourceGroups/rg-apdvc-dev-westeurope/providers/Microsoft.EventHub/namespaces/ehns-apdvc-dev-westeurope/eventhubs/rawdata/overview"
#             }
#           },
#           "1": {
#             "position": {
#               "x": 6,
#               "y": 0,
#               "colSpan": 6,
#               "rowSpan": 4
#             },
#             "metadata": {
#               "inputs": [
#                 {
#                   "name": "id",
#                   "value": "/subscriptions/207adc7d-e3e9-41ae-ba94-47ab3f626fec/resourceGroups/rg-apdvc-dev-westeurope/providers/Microsoft.Web/sites/az-fa-apdvc-dev-westeurope",
#                   "isOptional": true
#                 },
#                 {
#                   "name": "resourceId",
#                   "isOptional": true
#                 },
#                 {
#                   "name": "menuid",
#                   "isOptional": true
#                 }
#               ],
#               "type": "Extension/HubsExtension/PartType/ResourcePart",
#               "asset": {
#                 "idInputName": "id"
#               },
#               "deepLink": "#@m365ht.onmicrosoft.com/resource/subscriptions/207adc7d-e3e9-41ae-ba94-47ab3f626fec/resourceGroups/rg-apdvc-dev-westeurope/providers/Microsoft.Web/sites/az-fa-apdvc-dev-westeurope/appServices"
#             }
#           },
#           "2": {
#             "position": {
#               "x": 0,
#               "y": 4,
#               "colSpan": 6,
#               "rowSpan": 4
#             },
#             "metadata": {
#               "inputs": [
#                 {
#                   "name": "sharedTimeRange",
#                   "isOptional": true
#                 },
#                 {
#                   "name": "options",
#                   "value": {
#                     "chart": {
#                       "metrics": [
#                         {
#                           "resourceMetadata": {
#                             "id": "/subscriptions/207adc7d-e3e9-41ae-ba94-47ab3f626fec/resourceGroups/rg-apdvc-dev-westeurope/providers/Microsoft.EventHub/namespaces/ehns-apdvc-dev-westeurope"
#                           },
#                           "name": "IncomingRequests",
#                           "aggregationType": 1,
#                           "namespace": "microsoft.eventhub/namespaces",
#                           "metricVisualization": {
#                             "displayName": "Incoming Requests",
#                             "resourceDisplayName": "ehns-apdvc-dev-westeurope"
#                           }
#                         },
#                         {
#                           "resourceMetadata": {
#                             "id": "/subscriptions/207adc7d-e3e9-41ae-ba94-47ab3f626fec/resourceGroups/rg-apdvc-dev-westeurope/providers/Microsoft.EventHub/namespaces/ehns-apdvc-dev-westeurope"
#                           },
#                           "name": "SuccessfulRequests",
#                           "aggregationType": 1,
#                           "namespace": "microsoft.eventhub/namespaces",
#                           "metricVisualization": {
#                             "displayName": "Successful Requests",
#                             "resourceDisplayName": "ehns-apdvc-dev-westeurope"
#                           }
#                         },
#                         {
#                           "resourceMetadata": {
#                             "id": "/subscriptions/207adc7d-e3e9-41ae-ba94-47ab3f626fec/resourceGroups/rg-apdvc-dev-westeurope/providers/Microsoft.EventHub/namespaces/ehns-apdvc-dev-westeurope"
#                           },
#                           "name": "ServerErrors",
#                           "aggregationType": 1,
#                           "namespace": "microsoft.eventhub/namespaces",
#                           "metricVisualization": {
#                             "displayName": "Server Errors.",
#                             "resourceDisplayName": "ehns-apdvc-dev-westeurope"
#                           }
#                         },
#                         {
#                           "resourceMetadata": {
#                             "id": "/subscriptions/207adc7d-e3e9-41ae-ba94-47ab3f626fec/resourceGroups/rg-apdvc-dev-westeurope/providers/Microsoft.EventHub/namespaces/ehns-apdvc-dev-westeurope"
#                           },
#                           "name": "UserErrors",
#                           "aggregationType": 1,
#                           "namespace": "microsoft.eventhub/namespaces",
#                           "metricVisualization": {
#                             "displayName": "User Errors.",
#                             "resourceDisplayName": "ehns-apdvc-dev-westeurope"
#                           }
#                         },
#                         {
#                           "resourceMetadata": {
#                             "id": "/subscriptions/207adc7d-e3e9-41ae-ba94-47ab3f626fec/resourceGroups/rg-apdvc-dev-westeurope/providers/Microsoft.EventHub/namespaces/ehns-apdvc-dev-westeurope"
#                           },
#                           "name": "ThrottledRequests",
#                           "aggregationType": 1,
#                           "namespace": "microsoft.eventhub/namespaces",
#                           "metricVisualization": {
#                             "displayName": "Throttled Requests.",
#                             "resourceDisplayName": "ehns-apdvc-dev-westeurope"
#                           }
#                         }
#                       ],
#                       "title": null,
#                       "titleKind": 0,
#                       "visualization": {
#                         "chartType": 2,
#                         "legendVisualization": {
#                           "isVisible": true,
#                           "position": 2,
#                           "hideSubtitle": false
#                         },
#                         "axisVisualization": {
#                           "x": {
#                             "isVisible": true,
#                             "axisType": 2
#                           },
#                           "y": {
#                             "isVisible": true,
#                             "axisType": 1
#                           }
#                         }
#                       },
#                       "filterCollection": {
#                         "filters": [
#                           {
#                             "key": "EntityName",
#                             "operator": 0,
#                             "values": [
#                               "rawdata"
#                             ]
#                           }
#                         ]
#                       },
#                       "timespan": {
#                         "relative": {
#                           "duration": 3600000
#                         },
#                         "showUTCTime": false,
#                         "grain": 1
#                       }
#                     }
#                   },
#                   "isOptional": true
#                 }
#               ],
#               "type": "Extension/HubsExtension/PartType/MonitorChartPart",
#               "settings": {
#                 "content": {
#                   "options": {
#                     "chart": {
#                       "metrics": [
#                         {
#                           "resourceMetadata": {
#                             "id": "/subscriptions/207adc7d-e3e9-41ae-ba94-47ab3f626fec/resourceGroups/rg-apdvc-dev-westeurope/providers/Microsoft.EventHub/namespaces/ehns-apdvc-dev-westeurope"
#                           },
#                           "name": "IncomingRequests",
#                           "aggregationType": 1,
#                           "namespace": "microsoft.eventhub/namespaces",
#                           "metricVisualization": {
#                             "displayName": "Incoming Requests",
#                             "resourceDisplayName": "ehns-apdvc-dev-westeurope"
#                           }
#                         },
#                         {
#                           "resourceMetadata": {
#                             "id": "/subscriptions/207adc7d-e3e9-41ae-ba94-47ab3f626fec/resourceGroups/rg-apdvc-dev-westeurope/providers/Microsoft.EventHub/namespaces/ehns-apdvc-dev-westeurope"
#                           },
#                           "name": "SuccessfulRequests",
#                           "aggregationType": 1,
#                           "namespace": "microsoft.eventhub/namespaces",
#                           "metricVisualization": {
#                             "displayName": "Successful Requests",
#                             "resourceDisplayName": "ehns-apdvc-dev-westeurope"
#                           }
#                         },
#                         {
#                           "resourceMetadata": {
#                             "id": "/subscriptions/207adc7d-e3e9-41ae-ba94-47ab3f626fec/resourceGroups/rg-apdvc-dev-westeurope/providers/Microsoft.EventHub/namespaces/ehns-apdvc-dev-westeurope"
#                           },
#                           "name": "ServerErrors",
#                           "aggregationType": 1,
#                           "namespace": "microsoft.eventhub/namespaces",
#                           "metricVisualization": {
#                             "displayName": "Server Errors.",
#                             "resourceDisplayName": "ehns-apdvc-dev-westeurope"
#                           }
#                         },
#                         {
#                           "resourceMetadata": {
#                             "id": "/subscriptions/207adc7d-e3e9-41ae-ba94-47ab3f626fec/resourceGroups/rg-apdvc-dev-westeurope/providers/Microsoft.EventHub/namespaces/ehns-apdvc-dev-westeurope"
#                           },
#                           "name": "UserErrors",
#                           "aggregationType": 1,
#                           "namespace": "microsoft.eventhub/namespaces",
#                           "metricVisualization": {
#                             "displayName": "User Errors.",
#                             "resourceDisplayName": "ehns-apdvc-dev-westeurope"
#                           }
#                         },
#                         {
#                           "resourceMetadata": {
#                             "id": "/subscriptions/207adc7d-e3e9-41ae-ba94-47ab3f626fec/resourceGroups/rg-apdvc-dev-westeurope/providers/Microsoft.EventHub/namespaces/ehns-apdvc-dev-westeurope"
#                           },
#                           "name": "ThrottledRequests",
#                           "aggregationType": 1,
#                           "namespace": "microsoft.eventhub/namespaces",
#                           "metricVisualization": {
#                             "displayName": "Throttled Requests.",
#                             "resourceDisplayName": "ehns-apdvc-dev-westeurope"
#                           }
#                         }
#                       ],
#                       "title": null,
#                       "titleKind": 0,
#                       "visualization": {
#                         "chartType": 2,
#                         "legendVisualization": {
#                           "isVisible": true,
#                           "position": 2,
#                           "hideSubtitle": false
#                         },
#                         "axisVisualization": {
#                           "x": {
#                             "isVisible": true,
#                             "axisType": 2
#                           },
#                           "y": {
#                             "isVisible": true,
#                             "axisType": 1
#                           }
#                         },
#                         "disablePinning": true
#                       }
#                     }
#                   }
#                 }
#               },
#               "filters": {
#                 "EntityName": {
#                   "model": {
#                     "operator": "equals",
#                     "values": [
#                       "rawdata"
#                     ]
#                   }
#                 },
#                 "MsPortalFx_TimeRange": {
#                   "model": {
#                     "format": "local",
#                     "granularity": "auto",
#                     "relative": "60m"
#                   }
#                 }
#               }
#             }
#           },
#           "3": {
#             "position": {
#               "x": 6,
#               "y": 4,
#               "colSpan": 6,
#               "rowSpan": 4
#             },
#             "metadata": {
#               "inputs": [
#                 {
#                   "name": "sharedTimeRange",
#                   "isOptional": true
#                 },
#                 {
#                   "name": "options",
#                   "value": {
#                     "chart": {
#                       "metrics": [
#                         {
#                           "resourceMetadata": {
#                             "id": "/subscriptions/207adc7d-e3e9-41ae-ba94-47ab3f626fec/resourceGroups/rg-apdvc-dev-westeurope/providers/microsoft.insights/components/app-ins-apdvc-dev-westeurope"
#                           },
#                           "name": "customMetrics/scheduled_eventhub_output Count",
#                           "aggregationType": 1,
#                           "namespace": "microsoft.insights/components/kusto",
#                           "metricVisualization": {
#                             "displayName": "scheduled_eventhub_output Count",
#                             "resourceDisplayName": "app-ins-apdvc-dev-westeurope"
#                           }
#                         }
#                       ],
#                       "title": "Total Execution Count",
#                       "titleKind": 2,
#                       "visualization": {
#                         "chartType": 2
#                       },
#                       "openBladeOnClick": {
#                         "openBlade": true
#                       }
#                     }
#                   },
#                   "isOptional": true
#                 }
#               ],
#               "type": "Extension/HubsExtension/PartType/MonitorChartPart",
#               "settings": {
#                 "content": {
#                   "options": {
#                     "chart": {
#                       "metrics": [
#                         {
#                           "resourceMetadata": {
#                             "id": "/subscriptions/207adc7d-e3e9-41ae-ba94-47ab3f626fec/resourceGroups/rg-apdvc-dev-westeurope/providers/microsoft.insights/components/app-ins-apdvc-dev-westeurope"
#                           },
#                           "name": "customMetrics/scheduled_eventhub_output Count",
#                           "aggregationType": 1,
#                           "namespace": "microsoft.insights/components/kusto",
#                           "metricVisualization": {
#                             "displayName": "scheduled_eventhub_output Count",
#                             "resourceDisplayName": "app-ins-apdvc-dev-westeurope"
#                           }
#                         }
#                       ],
#                       "title": "Total Execution Count",
#                       "titleKind": 2,
#                       "visualization": {
#                         "chartType": 2,
#                         "disablePinning": true
#                       },
#                       "openBladeOnClick": {
#                         "openBlade": true
#                       }
#                     }
#                   }
#                 }
#               },
#               "filters": {
#                 "MsPortalFx_TimeRange": {
#                   "model": {
#                     "format": "local",
#                     "granularity": "auto",
#                     "relative": "60m"
#                   }
#                 }
#               }
#             }
#           }
#         }
#       }
#     },
#     "metadata": {
#       "model": {
#         "timeRange": {
#           "value": {
#             "relative": {
#               "duration": 24,
#               "timeUnit": 1
#             }
#           },
#           "type": "MsPortalFx.Composition.Configuration.ValueTypes.TimeRange"
#         },
#         "filterLocale": {
#           "value": "en-us"
#         },
#         "filters": {
#           "value": {
#             "MsPortalFx_TimeRange": {
#               "model": {
#                 "format": "utc",
#                 "granularity": "auto",
#                 "relative": "24h"
#               },
#               "displayCache": {
#                 "name": "UTC Time",
#                 "value": "Past 24 hours"
#               },
#               "filteredPartIds": [
#                 "StartboardPart-MonitorChartPart-e88daaf2-9768-4f5f-b90e-b3ed6fefc308",
#                 "StartboardPart-MonitorChartPart-e88daaf2-9768-4f5f-b90e-b3ed6fefc418"
#               ]
#             }
#           }
#         }
#       }
#     }
#   },
#   "name": "Lambda WSB",
#   "type": "Microsoft.Portal/dashboards",
#   "location": "INSERT LOCATION",
#   "tags": {
#     "hidden-title": "Lambda WSB"
#   },
#   "apiVersion": "2015-08-01-preview"
# }
# DASH
# }