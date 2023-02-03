if shared.HClAdmin then
    if printconsole then
        printconsole("Script already running! If you need to restart it, run the \"restart\" command.", 255, 127, 0)
    else
        warn("Script already running! If you need to restart it, run the \"restart\" command.")
    end

    return 
end

loadstring( game:HttpGet("https://raw.githubusercontent.com/wait-what314/HCl-Admin/main/src/loader.lua") )()
shared.HClAdmin = true