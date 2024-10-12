if engine.ActiveGamemode() == "homigrad" then
include("shared.lua")

local healsound = Sound("Underwater.BulletImpact")

function SWEP:Heal(ply)
    if not ply or not ply:IsPlayer() then sound.Play(healsound,ply:GetPos(),75,100,0.5) return true end

    if not ply.informedaboutneuro then ply:ChatPrint("У тебя нет признаков нейротоксина в организме.") return end
    ply.pain = math.max(ply.pain - 400,0)
    ply.informedaboutneuro = false
    ply:SetNWBool("neurotoxinshake",false)
    ply:SetNWBool("neurotoxinpripadok",false)
    ply:ChatPrint("Ты вколол антидот.")
    ply:EmitSound(healsound)

    return true
end end