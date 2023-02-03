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

return Commands