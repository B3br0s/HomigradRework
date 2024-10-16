if engine.ActiveGamemode() == "homigrad" then
include("shared.lua")

local healsound = Sound("weapons/arc_vm_medshot/adrenaline_needle_in.wav")

function SWEP:Heal(ply)
    if not ply or not ply:IsPlayer() then sound.Play(healsound,ply:GetPos(),75,100,0.5) return true end

    ply.pain = math.max(ply.pain - 400,0)
    ply.Metabolizm = ply.Metabolizm + 3
    ply:TakeDamage(20)
    ply:SetMaxHealth(80)
    ply:SetNWBool("tremor",true)
    timer.Simple(41,function ()
        ply:SetNWBool("tremor",false)
    end)
    ply:EmitSound(healsound)

    return true
end end