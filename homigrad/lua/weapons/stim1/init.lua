if engine.ActiveGamemode() == "homigrad" then
include("shared.lua")

local healsound = Sound("weapons/arc_vm_medshot/adrenaline_needle_in.wav")

function SWEP:Heal(ply)
    if not ply or not ply:IsPlayer() then sound.Play(healsound,ply:GetPos(),75,100,0.5) return true end

    if ply.MULE != true then
    ply.pain = math.max(ply.pain - 400,0)
    ply:SetHealth(ply:Health() + 50)
    ply:SetJumpPower(ply:GetJumpPower() + 100)
    ply.painlosing = ply.painlosing + 2
    ply:EmitSound(healsound)
    ply.MULE = true
    else
    for i = 1,80 do
        timer.Simple(0.05 * i,function ()
            ply.painlosing = 1  
            ply.Blood = ply.Blood - i
            if i == 80 then
                ply.KillReason = "stimulator"
                ply:Kill()
            end
        end)  
    end
    ply:EmitSound(healsound)
    end

    return true
end
end