if engine.ActiveGamemode() == "homigrad" then
include("shared.lua")

local healsound = Sound("snds_jack_gmod/ez_medical/15.wav")

function SWEP:Heal(ent)
    if not ent or not ent:IsPlayer() then sound.Play(healsound,ent:GetPos(),75,100,0.5) return true end

    if not ent:Alive() then return end

    ent:ChatPrint("Тебя клонит спать.")

    for i = 1,150 do
        timer.Simple(0.1 * i,function ()
            ent.pain = ent.pain + 5
        end)
    end

    ent:EmitSound(healsound)

    return true
end end