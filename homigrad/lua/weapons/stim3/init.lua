if engine.ActiveGamemode() == "homigrad" then
include("shared.lua")

local healsound = Sound("weapons/arc_vm_medshot/adrenaline_needle_in.wav")

function SWEP:Heal(ply)
    if not ply or not ply:IsPlayer() then sound.Play(healsound,ply:GetPos(),75,100,0.5) return true end
    local luck = math.random(1,15)
    ply:EmitSound(healsound)

    timer.Simple(1,function ()
        if luck > 4 and luck < 9 then
            ply.painlosing = ply.painlosing + 4
            ply:SetMaxHealth(200)
            ply.hungry = math.random(25,40)
            ply:TakeDamage(math.random(15,30))
            ply.stamina = math.random(70,150)
            ply.Metabolizm = ply.Metabolizm + 6
            ply.pain = 0
            ply.Blood = 5000
        else
            ply.KillReason = "obdolbos"
            ply:Kill()
        end    
    end)

    return true
end end