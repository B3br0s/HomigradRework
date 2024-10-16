if engine.ActiveGamemode() == "homigrad" then
include("shared.lua")

local healsound = Sound("weapons/arc_vm_medshot/adrenaline_needle_in.wav")

function SWEP:Heal(ent)
    ent.adrenaline = ent.adrenaline + 2

    ent:EmitSound(healsound)

    if not ent.adrenalineNeed and ent.adrenalineNeed > 4 then ent.adrenalineNeed = ent.adrenalineNeed + 1 end

    return true
end
end