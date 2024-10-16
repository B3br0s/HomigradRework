if engine.ActiveGamemode() == "homigrad" then
include("shared.lua")

local healsound = Sound("weapons/arc_vm_medshot/adrenaline_needle_in.wav")

function SWEP:Heal(ply)
    if not ply or not ply:IsPlayer() then sound.Play(healsound,ply:GetPos(),75,100,0.5) return true end

    ply.pain = 0
    ply.painlosing = ply.painlosing + 1
    ply.hungry = ply.hungry + 30
    ply.Metabolizm = ply.Metabolizm + 1
    ply.Blood = ply.Blood + 300
    ply:EmitSound(healsound)

    return true
end end