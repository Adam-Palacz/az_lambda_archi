module.exports = async function (context, myTimer) {
    var timeStamp = new Date().toISOString();
    
    context.bindings.outputEventHubMessage = []

    for(i=0;i<5;i++){
        context.bindings.outputEventHubMessage.push(
            {
                factoryId: "factory"+String(i+1),
                timeStamp: timeStamp,
                messageType: "metrics",
                data: {
                    ProductionRate: Math.random()*100+200,
                    PowerUsage: Math.random()*500+400
                }
            }
        )
    }

    context.log('Message generated', context.bindings.outputEventHubMessage);   
};