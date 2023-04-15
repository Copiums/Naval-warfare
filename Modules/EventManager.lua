local HttpService = game:GetService("HttpService")


local manager = {
    functions = {},
    events = {}
}

function manager:Stop()
    for i,event in pairs(self.events) do
        event:Disconnect()
    end
end

function manager:AddEvent(event, callback)
    self.events[HttpService:GenerateGUID()] = event:Connect(callback)
end

return manager