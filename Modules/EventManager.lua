local RunService = game:GetService("RunService")

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
    manager.events[RunService:GenerateGUID()] = event:Connect(callback)
end

return manager