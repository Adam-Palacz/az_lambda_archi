{
    "bindings": [
      {
        "name": "myTimer",
        "type": "timerTrigger",
        "direction": "in",
        "schedule": "* * * * * *"
      },
      {
        "name": "outputEventHubMessage",
        "connection": "${eventhub_namespace}_${eventhub_connection}_EVENTHUB",
        "eventHubName": "outeventhub",
        "direction": "out",
        "type": "eventHub"
      }
    ]
  }