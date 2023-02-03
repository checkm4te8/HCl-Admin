local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local Prefix = "^"
local Tables = {
    Logs = {
        Chat = {},
        Command = {}
    },
    CommandWhitelist = {LocalPlayer}
}

local Commands = loadstring( game:HttpGet("https://raw.githubusercontent.com/wait-what314/HCl-Admin/main/src/commands.lua") )()
local Functions = loadstring( game:HttpGet("https://raw.githubusercontent.com/wait-what314/HCl-Admin/main/src/functions.lua") )()

local function ProcessCommand(Player: Player, Message: string)
    local SplitMessage = Message:split(" ")
    local CommandName = table.remove(SplitMessage, 1):lower()

    local Command
    for _, CommandInfo in Commands do
        if CommandInfo.Name ~= CommandName and not table.find(CommandInfo.Aliases, CommandName) then continue end
        Command = CommandInfo
        break
    end

    if not Command then return end

    local Callback = Command.Callback
    if not Callback then return end

    local Success, Arguments = Functions.ParseArguments(Player, SplitMessage, Command.Arguments)
    if not Success then return end

    Callback(Player, unpack(Arguments))
end

local function OnPlayerChatted(Player: Player, Message: string)
    if Message:sub(1, #Prefix) == Prefix and table.find(Tables.CommandWhitelist, Player) then
        task.spawn(ProcessCommand, Player, Message:sub(#Prefix))
    end
end

local function OnPlayerAdded(Player: Player)
    Player.Chatted:Connect(function(Message)
        OnPlayerChatted(Player, Message)
    end)
end

local function OnPlayerRemoving(Player: Player)
    local Index = table.find(Tables.CommandWhitelist, Player)
    if not Index then return end

    table.remove(Tables.CommandWhitelist, Index)
end

Players.PlayerAdded:Connect(OnPlayerAdded)
Players.PlayerRemoving:Connect(OnPlayerRemoving)
for _, Player in Players:GetPlayers() do
    task.spawn(OnPlayerAdded, Player)
end