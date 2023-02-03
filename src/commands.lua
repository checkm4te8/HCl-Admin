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

AddCommand("test", {"fullstring"}, {"test2"}):SetDescription("Test Command"):SetCallback(function(Player, Message)
    print(Message)
end)

return Commands