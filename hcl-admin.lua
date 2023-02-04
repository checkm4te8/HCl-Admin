local URL = "https://raw.githubusercontent.com/wait-what314/HCl-Admin/main/src/loader.lua"

local CodeString
if syn and syn.request then
    CodeString = syn.request({Url = URL, Method = "GET"}).Body
else
    CodeString = game:HttpGet(URL)
end

if not CodeString then return end
loadstring(CodeString)()