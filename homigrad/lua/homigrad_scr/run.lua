if engine.ActiveGamemode() == "homigradcom" then
AddCSLuaFile()

print("	homigrad start.")

local start = SysTime()
hg.includeDir("homigrad_scr/")--cring

print("	homigrad structure end " .. math.Round(SysTime() - start,3) .. "s")

end