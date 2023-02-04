local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

if shared.HClAdmin then
    shared.HClAdmin:Destroy()
end

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local Connections = {}
local Instances = {}
local CharacterInfo = {}
local Values = {
    Logs = {
        Chat = {},
        Command = {}
    },
    CommandWhitelist = {LocalPlayer},
    LogCommands = true,
    LogChat = false,
    AntiFling = false,
    Prefix = "^"
}

local Assets = game:GetObjects("rbxassetid://12374697905")
local Commands = loadstring( game:HttpGet("https://raw.githubusercontent.com/wait-what314/HCl-Admin/main/src/commands.lua") )()
local Functions = loadstring( game:HttpGet("https://raw.githubusercontent.com/wait-what314/HCl-Admin/main/src/functions.lua") )()

local CommandGui = Assets[1]
local CommandBar = CommandGui:WaitForChild("CommandBar")
local CommandBox = CommandBar:WaitForChild("CommandBox")
local CommandAutoComplete = CommandBar:WaitForChild("AutoComplete")

local function ProcessCommand(Player, Message)
    local SplitMessage = Message:split(" ")
    local CommandName = table.remove(SplitMessage, 1):lower()

    local Command
    for _, CommandInfo in next, Commands do
        if CommandInfo.Name ~= CommandName and not table.find(CommandInfo.Aliases, CommandName) then continue end
        Command = CommandInfo
        break
    end

    if not Command then return end

    local Callback = Command.Callback
    if not Callback then return end

    local Success, Arguments = Functions.ParseArguments(Player, SplitMessage, Command.Arguments)
    if not Success then return end

    if Values.LogCommands then
        table.insert(Values.Logs.Command, {
            Name = Player.Name,
            UserId = Player.UserId,
            CommandRan = Message
        })
    end

    Callback(Player, unpack(Arguments))
end

local function OnPlayerChatted(Player, Message)
    if Message:sub(1, #Values.Prefix) == Values.Prefix and table.find(Values.CommandWhitelist, Player) then
        task.spawn(ProcessCommand, Player, Message:sub(#Values.Prefix + 1))
    end
end

local function OnPlayerAdded(Player)
    table.insert(Connections, Player.Chatted:Connect(function(Message)
        OnPlayerChatted(Player, Message)
    end))

    local function OnCharacterAdded(Character)
        if Player ~= LocalPlayer then return end

        CharacterInfo.Character = Character

        local Humanoid = Character:WaitForChild("Humanoid")
        local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

        CharacterInfo.Humanoid = Humanoid
        CharacterInfo.HumanoidRootPart = HumanoidRootPart
    end

    OnCharacterAdded(Player.Character or Player.CharacterAdded:Wait())
    table.insert(Connections, Player.CharacterAdded:Connect(OnCharacterAdded))
end

local function OnPlayerRemoving(Player)
    local Index = table.find(Values.CommandWhitelist, Player)
    if not Index then return end

    table.remove(Values.CommandWhitelist, Index)
end

local function OnStepped()
    local Character = CharacterInfo.Character
    if Values.AntiFling and Character and Character.Parent then
        for _, Char in next, Character.Parent:GetChildren() do
            if not Functions.IsCharacter(Char) then continue end
            Functions.ToggleCharCollisions(Char, false)
        end
    end
end

local function OnRenderStepped()
    
end

local function CommandBoxChanged(Property)
    if Property ~= "Text" then return end
    local CommandName = CommandBox.Text:split(" ")[1]:lower()

    for _, CommandInfo in next, Commands do
        if CommandInfo.Name:sub(1, #CommandName) == CommandName then
            CommandAutoComplete.Text = (" "):rep(#CommandName) .. CommandInfo.Name:sub(#CommandName)
            return
        end

        for _, Alias in next, CommandInfo.Aliases do
            if Alias:sub(1, #CommandName) == CommandName then
                CommandAutoComplete.Text = (" "):rep(#CommandName) .. Alias:sub(#CommandName - 1)
                return
            end
        end
    end

    CommandAutoComplete.Text = ""
end

local function CommandBoxFocusLost(EnterPressed)
    if not EnterPressed then return end
    
    ProcessCommand(LocalPlayer, CommandBox.Text)
end

table.insert(Instances, CommandGui)
table.insert(Connections, Players.PlayerAdded:Connect(OnPlayerAdded))
table.insert(Connections, Players.PlayerRemoving:Connect(OnPlayerRemoving))
table.insert(Connections, RunService.Stepped:Connect(OnStepped))
table.insert(Connections, RunService.RenderStepped:Connect(OnRenderStepped))
table.insert(Connections, CommandBox.Changed:Connect(CommandBoxChanged))
table.insert(Connections, CommandBox.FocusLost:Connect(CommandBoxFocusLost))
for _, Player in next, Players:GetPlayers() do
    task.spawn(OnPlayerAdded, Player)
end

local ProtectGui = syn and syn.protect_gui
if ProtectGui then
    ProtectGui(CommandGui)
    CommandGui.Parent = CoreGui
elseif gethui and not KRNL_LOADED then
    CommandBar.Parent = gethui()
else
    CommandBar.Parent = CoreGui
end

shared.HClAdmin = {
    Functions = Functions,
    Commands = Commands,
    Values = Values,
    Connections = Connections,
    Instances = Instances
}

function shared.HClAdmin:Destroy()
    if self.Destroyed then
        return
    end

    for _, Connection in next, self.Connections do
        Connection:Disconnect()
    end

    for _, Inst in next, self.Instances do
        Inst:Destroy()
    end

    table.clear(self)
    self.Destroyed = true

    shared.HClAdmin = nil
end