local Network: table? = {
        Info = {}
}
local cloneref: (obj: any) -> any = cloneref or function(obj)
    	return obj;
end;
local replicatedStorage: ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"));
local Event: any = replicatedStorage:WaitForChild("Event")

local Receive: (args: any) -> () = function(args: any)
        local name: string = args[1]
        if name == "shoot" or name == "bomb" then
                -- print("shooting is now"..args[2][1])
                Network.Info["shooting"] = args[2]
        end
end

local Send: (name: string, ...: any) -> () = function(name: string, ...)
        Event:FireServer(name, {...}, true)
end

local Destroy: () -> boolean = function()
        if Network.gmt and Network.namecall then
                Network.gmt.__namecall = Network.namecall
        end
        return true
end

local Init: () -> () = function()
        local gmt: any = getrawmetatable(game)
        setreadonly(gmt, false)
        
        Network.gmt = gmt
        Network.namecall = gmt.__namecall
        
        gmt.__namecall = function(event, ...)
                if event ~= Event then
                        return Network.namecall(event, ...)
                end
                
                local method: string = getnamecallmethod()
                if tostring(method) ~= "FireServer" then
                        return Network.namecall(event, ...)
                end
                
                local args: any = {...}
                Receive(args)
                return Network.namecall(event, ...)
        end
end

Network.Receive = Receive
Network.Send = Send
Network.Destroy = Destroy
Network.Init = Init

return Network
