if engine.ActiveGamemode() == "homigrad" then
include("shared.lua")

local healsound = Sound("Underwater.BulletImpact")

function SWEP:Heal(ent)
        ent.adrenaline = ent.adrenaline + 8  

    ent.vkololinh = true

    if not ent.adrenalineNeed and ent.adrenalineNeed > 4 then ent.adrenalineNeed = ent.adrenalineNeed + 8 end

    return true
end
end