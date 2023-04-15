local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Network = {
    Info = {}
}

function Network:Receive(args)
    local name = args[1]
    if name == "shoot" or name == "bomb" then
        self.Info["shooting"] = args[1]
    end
end

local Event = ReplicatedStorage:WaitForChild("Event")
function Network:Send(name, ...)
    Event:FireServer(name, {...}, true)
end

function Network:Destroy()
    self.gmt.__namecall = self.namecall
    return true
end

function Network:Init()
    local gmt = getrawmetatable(game)
    setreadonly(gmt, false)
    self.gmt = gmt
    local namecall = gmt.__namecall
    self.namecall = namecall
    gmt.__namecall = function(event, ...)
        if event ~= Event then
            return namecall(event, ...)
        end
        local method = getnamecallmethod()
        if tostring(method) ~= "FireServer" then
            return namecall(event, ...)
        end
        local args = {...}
        if not args[3] then
            self:Receive(args)
        end
        return namecall(event, ...)
    end
end


return Network