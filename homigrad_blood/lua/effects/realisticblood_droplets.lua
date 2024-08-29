function EFFECT:Init(data)
    local ent = data:GetEntity()

    if !IsValid(ent) then return end
    if !GetConVar("realistic_blood_player_effects"):GetBool() && IsValid(ent:GetOwner()) && ent:GetOwner() == LocalPlayer() then return end
    if GetConVar("realistic_blood_droplet_lifetime"):GetInt() <= 0 then return end

    local time = data:GetMagnitude()
    local timer_name = "RealisticBlood_StreamTimer"..ent:EntIndex()
    local emitter = ParticleEmitter(ent:GetPos(), false)
    local emitter3D = ParticleEmitter(ent:GetPos(), true)

    timer.Create(timer_name, 0.1, time*10, function()
        if !IsValid(ent) then
            emitter:Finish()
            emitter3D:Finish()
            timer.Remove(timer_name)
            return
        end

        for i = 1,math.random(1, 4) do
            RealisticBlood_Droplet( ent:GetPos(), ent:GetForward(), emitter, emitter3D )
        end

        if timer.RepsLeft(timer_name) == 0 then
            emitter:Finish()
            emitter3D:Finish()
        end
    end)
end

function EFFECT:Think() return false end

function EFFECT:Render() end