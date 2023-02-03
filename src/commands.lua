local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local Commands = {}
local Index = {}
local CommandMetatable = {__index = Index}

function Index:SetCallback(Callback)
    self.Callback = Callback
    return self
end

function Index:SetDescription(Description)
    self.Description = Description
    return self
end

local function AddCommand(CommandName, CommandArguments, Aliases)
    local Command = setmetatable({}, CommandMetatable)
    Command.Name = CommandName
    Command.Arguments = CommandArguments
    Command.Aliases = Aliases or {}

    table.insert(Commands, Command)

    return Command
end

AddCommand("antifling", {"boolean"}, {"nofling", "afling"}):SetDescription("Toggles the anti-fling"):SetCallback(function(_, Active)
    shared.HClAdmin.Values.AntiFling = Active
end)

AddCommand("close", {}, {"closeadmin", "stop"}):SetDescription("Destroys all items associated with HCl Admin"):SetCallback(function()
    shared.HClAdmin:Destroy()
end)

AddCommand("silentchat", {"fullstring"}, {"schat", "hiddenchat"}):SetDescription("Fires the .Chatted event without actually sending a message"):SetCallback(function(_, Message)
    Players:Chat(Message)
end)

AddCommand("prefix", {"fullstring"}, {}):SetDescription("Sets the command prefix"):SetCallback(function(_, Prefix)
    if utf8.len(Prefix) > 2 then return end
    shared.HClAdmin.Values.Prefix = Prefix
end)

AddCommand("rejoin", {"boolean?"}, {"rj"}):SetDescription("Rejoins the game, if first argument is true automatically loads the script"):SetCallback(function(_, Reload)
    local QueueOnTP = syn and syn.queue_on_teleport
    if QueueOnTP and Reload then
        QueueOnTP( game:HttpGet("https://raw.githubusercontent.com/wait-what314/HCl-Admin/main/hcl-admin.lua") )
    end

    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
end)

AddCommand("dex", {}, {"dexexplorer", "explorer"}):SetDescription("Opens DEX"):SetCallback(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/peyton2465/Dex/master/out.lua"))()
end)

AddCommand("reload", {}, {"restart"}):SetDescription("Reloads the admin script"):SetCallback(function()
    loadstring( game:HttpGet("https://raw.githubusercontent.com/wait-what314/HCl-Admin/main/src/loader.lua") )()
end)

return Commands