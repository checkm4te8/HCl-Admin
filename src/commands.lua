local Commands = {}
local CommandMetatable = {__index = {}}

function CommandMetatable.__index:SetCallback(Callback)
    self.Callback = Callback
    return self
end

function CommandMetatable.__index:SetDescription(Description)
    self.Description = Description
    return self
end

local function AddCommand(CommandName: string, CommandArguments, Aliases)
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