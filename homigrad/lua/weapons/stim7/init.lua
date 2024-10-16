if engine.ActiveGamemode() == "homigrad" then
include("shared.lua")

local healsound = Sound("weapons/arc_vm_medshot/adrenaline_needle_in.wav")

function SWEP:Heal(ply)
    if not ply or not ply:IsPlayer() then sound.Play(healsound,ply:GetPos(),75,100,0.5) return true end

    ply.pain = 0
    ply.painlosing = ply.painlosing + 1
    ply.adrenaline = ply.adrenaline + 1.5
    ply:SetJumpPower(ply:GetJumpPower() + 120)
    ply.Metabolizm = 0.1
    ply.stamina = ply.stamina - 50
    ply:EmitSound(healsound)

    return true
end end