local Network: table? = {
        Info = {}
}

local cloneref: (obj: any) -> any = cloneref or function(obj)
    	return obj;
end;

local replicatedStorage: ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"));
local Event: any = replicatedStorage:WaitForChild("Event")

function Network:Receive(args)
        local name: string = args[1]
        if name == "shoot" or name == "bomb" then
                -- print("shooting is now"..args[2][1])
                self.Info["shooting"] = args[2];
        end;
end;

function Network:Send(name, ...)
            Event:FireServer(name, {...}, true);
end;

function Network:Destroy()
            self.gmt.__namecall = self.namecall;
            return true;
end;

function Network:Init()
            local gmt: any = getrawmetatable(game);
            setreadonly(gmt, false);
            self.gmt = gmt;
            local namecall: any = gmt.__namecall;
            self.namecall = namecall;
end;

return Network
