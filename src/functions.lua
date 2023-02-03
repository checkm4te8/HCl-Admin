local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

local Functions = {}

function Functions.ParseArguments(Player, CommandArguments, ExpectedArguments)
    local ArgumentTable = {}
    for Index, ExpectedArgument in ipairs( ExpectedArguments ) do
        local Argument = CommandArguments[Index]
        if not Argument then
            return false
        end

        if ExpectedArgument == "players" then
            if Argument == "all" then
                table.insert(ArgumentTable, Players:GetPlayers())
                continue
            elseif Argument == "others" then
                local PlayerTable = Players:GetPlayers()
                local MyIndex = table.find(PlayerTable, LocalPlayer)
                if MyIndex then
                    table.remove(PlayerTable, MyIndex)
                end

                table.insert(ArgumentTable, PlayerTable)
                continue
            elseif Argument == "me" then
                table.insert(ArgumentTable, {LocalPlayer})
                continue
            end

            local PlayerTable = {}
            local PlayerNames = Argument:split(",")
            for _, PlayerName in PlayerNames do
                PlayerName = PlayerName:gsub("%W", ""):lower()
                for _, TPlayer in Players:GetPlayers() do
                    if TPlayer.Name:lower():sub(1, #PlayerName) ~= PlayerName then continue end
                    table.insert(PlayerTable, TPlayer)
                end
            end

            table.insert(ArgumentTable, PlayerTable)
        elseif ExpectedArgument == "string" then
            table.insert(ArgumentTable, Argument)
            continue
        elseif ExpectedArgument == "fullstring" then
            table.insert(ArgumentTable, table.concat(CommandArguments, " ", Index))
            break
        elseif ExpectedArgument == "boolean" then
            table.insert(ArgumentTable, Argument == "true" or Argument == "on" or Argument == "yes")
            continue
        elseif ExpectedArgument == "number" then
            local Number = tonumber(Argument)
            if not Number then
                return false
            end

            table.insert(ArgumentTable, Number)
            continue
        end
    end

    return true, ArgumentTable
end

return Functions