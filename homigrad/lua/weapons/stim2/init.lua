if engine.ActiveGamemode() == "homigrad" then
include("shared.lua")

local healsound = Sound("weapons/arc_vm_medshot/adrenaline_needle_in.wav")

function SWEP:Heal(ply)
    if not ply or not ply:IsPlayer() then sound.Play(healsound,ply:GetPos(),75,100,0.5) return true end
    ply.pain = math.max(ply.pain - 400,0)
    ply.painlosing = ply.painlosing + 3
    ply:SetMaxHealth(ply:GetMaxHealth() + math.random(30,40))
    if ply:Health() <= 100 then
    ply:SetHealth(ply:Health() + 30)
    end
    ply:EmitSound(healsound)

    return true
end
end