if engine.ActiveGamemode() == "homigrad" then
include("shared.lua")

local healsound = Sound("weapons/arc_vm_medshot/adrenaline_needle_in.wav")

function SWEP:Heal(ent)
    ent.adrenaline = ent.adrenaline + 2  

    ent.pain = math.max(ent.pain - 400,0)

    ent:SetJumpPower(ent:GetJumpPower() + 250)

    ent:EmitSound(healsound)

    ent:EmitSound(healsound)

    ent.vkololinh = true

    if not ent.adrenalineNeed and ent.adrenalineNeed > 4 then ent.adrenalineNeed = ent.adrenalineNeed + 8 end

    return true
end
end