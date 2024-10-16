if engine.ActiveGamemode() == "homigrad" then
include("shared.lua")

local healsound = Sound("weapons/arc_vm_medshot/adrenaline_needle_in.wav")

function SWEP:Heal(ply)
    if not ply or not ply:IsPlayer() then sound.Play(healsound,ply:GetPos(),75,100,0.5) return true end

    ply:TakeDamage(20)
    ply.Bloodlosing = 2
    ply.informedaboutneuro = false
    ply.virus = 0
    ply.otravlen = false
    ply.otravlen2 = false
    ply:SetNWBool("neurotoxinshake",false)
    ply:SetNWBool("neurotoxinpripadok",false)
    ply:EmitSound(healsound)

    return true
end end