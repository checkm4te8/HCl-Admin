if shared.AdminLoading then return end
shared.AdminLoading = true

local URL = "https://raw.githubusercontent.com/wait-what314/HCl-Admin/main/src/loader.lua"

local CodeString
if syn and syn.request then
    CodeString = syn.request({Url = URL, Method = "GET"}).Body
else
    CodeString = game:HttpGet(URL)
end

if not CodeString then return end
local Function, Error = loadstring(CodeString)
if not Function then
    if printconsole then
        printconsole("Unable to load HClAdmin! Error: " .. Error, 255, 0, 0)
    else
        warn("Unable to load HClAdmin! Error: " .. Error)
    end

    return
end

xpcall(Function, function(ErrMsg)
    if printconsole then
        printconsole("Unable to load HClAdmin! Error: " .. debug.traceback(Error), 255, 0, 0)
    else
        warn("Unable to load HClAdmin! Error: " .. debug.traceback(Error))
    end
end)

shared.AdminLoading = false