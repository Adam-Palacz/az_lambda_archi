import datetime
import json
import logging
import azure.functions as func
from typing import List
from random import random

app = func.FunctionApp()

@app.function_name(name="scheduled_eventhub_output")
@app.schedule(schedule="* * * * * *", 
              arg_name="timer",
              run_on_startup=True)
@app.event_hub_output(arg_name="event",
                      event_hub_name="${eventhub_name}",
                      connection="EventHubConnectionString")
def scheduled_eventhub_output(timer: func.TimerRequest, event: func.Out[List[str]]) -> None:
    utc_timestamp = datetime.datetime.utcnow().replace(tzinfo=datetime.timezone.utc).isoformat()
    all_messages = []  
    
    for i in range(1, 6):
        message = {
            "factoryId": "factory" + str(i),
            "timeStamp": utc_timestamp,
            "messageType": "metrics",
            "data": {
                "ProductionRate": random() * 100 + 200,
                "PowerUsage": random() * 500 + 400 
            }
        }
        all_messages.append(json.dumps(message)) 
    
    event.set(all_messages)
    
    logging.info('Python timer trigger function ran at %s', utc_timestamp)
    logging.info(f"Messages sent: {all_messages}")