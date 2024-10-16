if engine.ActiveGamemode() == "homigrad" then
include("shared.lua")

local healsound = Sound("weapons/arc_vm_medshot/adrenaline_needle_in.wav")

function SWEP:Heal(ply)
    if not ply or not ply:IsPlayer() then sound.Play(healsound,ply:GetPos(),75,100,0.5) return true end

    ply:SetMaxHealth(ply:GetMaxHealth() + 15)
    ply.painlosing = ply.painlosing + 0.5
    ply.pain = ply.pain - 30
    ply.Bloodlosing = 0
    ply.Blood = ply.Blood - 200
    ply:EmitSound(healsound)

    return true
end end