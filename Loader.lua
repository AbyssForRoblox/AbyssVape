local dir = shared.VapePrivate and "vapeprivate/" or "vape/"
loadfile = loadfile or function(file)
    return loadstring(readfile(file))
end
return loadfile(dir .. "MainScript.lua")()